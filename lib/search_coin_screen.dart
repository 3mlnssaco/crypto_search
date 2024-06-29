import 'dart:async'; // 비동기 작업을 위한 Dart 패키지
import 'package:flutter/material.dart'; // Flutter의 UI 요소를 위한 패키지
import 'crypto_service.dart'; // CryptoService 클래스를 가져오기 위한 파일

// StatefulWidget인 SearchCoinScreen 클래스 정의
class SearchCoinScreen extends StatefulWidget {
  final CryptoService cryptoService; // CryptoService 객체를 받기 위한 변수

  SearchCoinScreen({super.key, required this.cryptoService}); // 생성자 정의

  @override
  _SearchCoinScreenState createState() => _SearchCoinScreenState(); // 상태 생성
}

// 상태 관리 클래스 정의
class _SearchCoinScreenState extends State<SearchCoinScreen> {
  List<Map<String, dynamic>> coins = []; // 코인 목록 저장 변수
  Map<String, double> previousPrices = {}; // 이전 가격 저장 변수
  Timer? _timer; // 타이머 변수

  @override
  void initState() {
    super.initState();
    _loadInitialCoins(); // 초기 코인 로드
    _startTimer(); // 타이머 시작
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

  // 타이머를 시작하는 메서드
  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
      await _updateCoins(); // 주기적으로 코인 데이터를 업데이트
    });
  }

  // 코인 데이터를 업데이트하는 메서드
  Future<void> _updateCoins() async {
    try {
      final updatedCoins =
          await widget.cryptoService.fetchAllCoins(); // 코인 데이터 가져오기
      setState(() {
        coins = updatedCoins.map((coin) {
          final symbol = coin['symbol'];
          final price = double.parse(coin['price']);
          final previousPrice = previousPrices[symbol] ?? price;
          previousPrices[symbol] = price;

          return {
            'symbol': symbol,
            'price': price,
            'color': price > previousPrice
                ? Colors.green
                : price < previousPrice
                    ? Colors.red
                    : Colors.black,
          };
        }).toList(); // 코인 데이터를 업데이트하여 리스트에 저장
      });
    } catch (e) {
      print('Failed to update coins: $e'); // 오류 발생 시 메시지 출력
    }
  }

  String searchText = '';

  @override
  void dispose() {
    _timer?.cancel(); // 타이머 취소
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Coins'), // 앱바 타이틀 설정
      ),
      body: coins.isEmpty
          ? const Center(
              child: CircularProgressIndicator()) // 코인 데이터가 없을 때 로딩 표시
          : ListView.builder(
              itemCount: coins.length, // 코인 목록 길이
              itemBuilder: (context, index) {
                final coin = coins[index];
                return ListTile(
                  title: Text(coin['symbol']), // 코인 심볼 표시
                  subtitle: Text('Price: \$${coin['price']}'), // 코인 가격 표시
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: coin['color'], // 가격 변화에 따른 색상 표시
                      ),
                      IconButton(
                        icon: Icon(Icons.star_border), // 즐겨찾기 버튼 아이콘
                        onPressed: () {
                          widget.cryptoService.addToFavorites(coin); // 즐겨찾기 추가
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${coin['symbol']} added to favorites'), // 즐겨찾기 추가 메시지
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
