import 'package:flutter/material.dart'; // Flutter의 UI 요소를 위한 패키지
import 'crypto_service.dart'; // CryptoService 클래스를 가져오기 위한 패키지
import 'all_coins.dart'; // AllCoinsScreen 클래스를 가져오기 위한 패키지
import 'favorite_stocks_screen.dart'; // FavoriteStocksScreen 클래스를 가져오기 위한 패키지
import 'search_coins.dart'; // SearchCoins 클래스를 가져오기 위한 패키지

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 위젯 바인딩 초기화
  final cryptoService = CryptoService(); // CryptoService 인스턴스 생성
  await cryptoService.initialize(); // CryptoService 초기화
  runApp(MyApp(cryptoService: cryptoService)); // MyApp 실행
}

// MyApp 클래스 정의
class MyApp extends StatelessWidget {
  final CryptoService cryptoService; // CryptoService 인스턴스 변수 선언

  const MyApp({super.key, required this.cryptoService}); // 생성자 정의

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto App', // 앱 제목 설정
      theme: ThemeData(
        primarySwatch: Colors.blue, // 앱 테마 색상 설정
      ),
      home: MyHomePage(cryptoService: cryptoService), // MyHomePage로 이동
    );
  }
}

// MyHomePage 클래스 정의
class MyHomePage extends StatefulWidget {
  final CryptoService cryptoService; // CryptoService 인스턴스 변수 선언

  const MyHomePage({super.key, required this.cryptoService}); // 생성자 정의

  @override
  _MyHomePageState createState() => _MyHomePageState(); // 상태 클래스 생성
}

// _MyHomePageState 클래스 정의
class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController; // TabController 인스턴스 변수 선언

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // TabController 초기화
  }

  @override
  void dispose() {
    _tabController.dispose(); // TabController 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto App'), // 앱바 제목 설정
        bottom: TabBar(
          controller: _tabController, // TabController 설정
          tabs: const [
            Tab(icon: Icon(Icons.search), text: 'Search Coin'), // 탭 아이콘과 텍스트 설정
            Tab(icon: Icon(Icons.list), text: 'All Coins'), // 탭 아이콘과 텍스트 설정
            Tab(icon: Icon(Icons.star), text: 'Favorites'), // 탭 아이콘과 텍스트 설정
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController, // TabController 설정
        children: [
          SearchCoins(cryptoService: widget.cryptoService),
          AllCoinsScreen(cryptoService: widget.cryptoService), // AllCoinsScreen 설정
          FavoriteStocksScreen(cryptoService: widget.cryptoService), // FavoriteStocksScreen 설정
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
