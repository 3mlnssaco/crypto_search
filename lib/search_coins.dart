import 'package:flutter/material.dart'; // Flutter의 UI 요소를 위한 패키지
import 'crypto_service.dart'; // CryptoService 클래스를 가져오기 위한 패키지
import 'dart:async'; // 비동기 작업을 위한 Dart 패키지

// StatefulWidget인 SearchCoins 클래스 정의
class SearchCoins extends StatefulWidget {
  final CryptoService cryptoService; // CryptoService 객체를 받기 위한 변수

  SearchCoins({super.key, required this.cryptoService}); // 생성자 정의

  @override
  _SearchCoins createState() => _SearchCoins(); // 상태 생성
}

// 상태 관리 클래스 정의
class _SearchCoins extends State<SearchCoins> {
  List<Map<String, dynamic>> coins = []; // 코인 목록 저장 변수
  String searchText = ''; // 검색어

  @override
  void initState() {
    super.initState();
    _loadInitialCoins(); // 초기 코인 로드
  }

// 초기 코인 데이터를 로드하는 메서드
  Future<void> _loadInitialCoins() async {
    try {
      final initialCoins =
          await widget.cryptoService.fetchAllCoins(); // 코인 데이터 가져오기
      setState(() {
        coins = initialCoins.map((coin) {
          return {
            'symbol': coin['symbol'],
            'price': double.parse(coin['price']),
          };
        }).toList(); // 코인 데이터를 리스트에 저장
      });
    } catch (e) {
      print('Failed to load initial coins: $e'); // 오류 발생 시 메시지 출력
    }
  }

// 리스트뷰 카드 클릭 이벤트 핸들러
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
    return MaterialApp(
      title: 'CryptoApp', // 앱의 아이콘 이름
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Search Coins'), // 앱 상단바 설정
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
      ),
    );
  }
}

// 선택한 항목의 내용을 보여주는 추가 페이지
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
