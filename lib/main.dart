import 'package:flutter/material.dart';
import 'crypto_service.dart';

void main() {
  CryptoService cryptoService = CryptoService();
  cryptoService.initialize(); // 환경 변수 초기화
  runApp(MyApp(cryptoService: cryptoService));
}

class MyApp extends StatelessWidget {
  final CryptoService cryptoService;

  MyApp({required this.cryptoService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchCoins(cryptoService: cryptoService),
    );
  }
}

class SearchCoins extends StatefulWidget {
  final CryptoService cryptoService;

  SearchCoins({required this.cryptoService});

  @override
  _SearchCoinsState createState() => _SearchCoinsState();
}

class _SearchCoinsState extends State<SearchCoins> {
  List<Map<String, dynamic>> coins = [];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    _loadInitialCoins();
  }

  Future<void> _loadInitialCoins() async {
    try {
      final initialCoins = await widget.cryptoService.fetchAllCoins();
      setState(() {
        coins = initialCoins.map((coin) {
          return {
            'symbol': coin['symbol'],
            'price': double.parse(coin['price']),
          };
        }).toList();
      });
    } catch (e) {
      print('Failed to load initial coins: $e');
    }
  }

  void cardClickEvent(BuildContext context, String symbol, double price) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContentPage(content: '$symbol: $price'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Coins'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '검색어를 입력해주세요.',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: coins.length,
              itemBuilder: (BuildContext context, int index) {
                final coin = coins[index];
                if (searchText.isNotEmpty &&
                    !coin['symbol']
                        .toLowerCase()
                        .contains(searchText.toLowerCase())) {
                  return SizedBox.shrink();
                } else {
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(20, 20))),
                    child: ListTile(
                      title: Text(coin['symbol']),
                      trailing: Text(coin['price'].toString()),
                      onTap: () => cardClickEvent(
                          context, coin['symbol'], coin['price']),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ContentPage extends StatelessWidget {
  final String content;

  const ContentPage({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Content'),
      ),
      body: Center(
        child: Text(content),
      ),
    );
  }
}
