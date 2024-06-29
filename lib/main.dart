import 'package:flutter/material.dart';
import 'crypto_service.dart';
import 'all_coins.dart';
import 'favorite_stocks_screen.dart';
import 'search_coins.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cryptoService = CryptoService();
  await cryptoService.initialize();
  runApp(MyApp(cryptoService: cryptoService));
}

class MyApp extends StatelessWidget {
  final CryptoService cryptoService;

  const MyApp({super.key, required this.cryptoService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(cryptoService: cryptoService),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final CryptoService cryptoService;

  const MyHomePage({super.key, required this.cryptoService});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.search), text: 'Search Coin'),
            Tab(icon: Icon(Icons.list), text: 'All Coins'),
            Tab(icon: Icon(Icons.star), text: 'Favorites'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SearchCoins(cryptoService: widget.cryptoService),
          SearchCoinScreen(cryptoService: widget.cryptoService),
          FavoriteStocksScreen(cryptoService: widget.cryptoService),
        ],
      ),
    );
  }
}

class SearchCoins extends StatefulWidget {
  final CryptoService cryptoService;

  const SearchCoins({super.key, required this.cryptoService});

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
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            decoration: const InputDecoration(
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
                return const SizedBox.shrink();
              } else {
                return Card(
                  elevation: 3,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.elliptical(20, 20))),
                  child: ListTile(
                    title: Text(coin['symbol']),
                    trailing: Text(coin['price'].toString()),
                    onTap: () => cardClickEvent(context, coin['symbol'], coin['price']),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class ContentPage extends StatelessWidget {
  final String content;

  const ContentPage({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content'),
      ),
      body: Center(
        child: Text(content),
      ),
    );
  }
}
