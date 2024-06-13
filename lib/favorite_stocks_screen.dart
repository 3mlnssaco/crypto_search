import 'package:flutter/material.dart'; // Flutter의 UI 요소를 위한 패키지
import 'crypto_service.dart'; // CryptoService 클래스를 가져오기 위한 패키지

// FavoriteStocksScreen 클래스 정의
class FavoriteStocksScreen extends StatelessWidget {
  final CryptoService cryptoService; // CryptoService 인스턴스 변수 선언

  const FavoriteStocksScreen(
      {super.key, required this.cryptoService}); // 생성자 정의

  @override
  Widget build(BuildContext context) {
    final favoriteCoins = cryptoService.getFavoriteCoins(); // 즐겨찾기 코인 목록 가져오기

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Coins'), // 앱바 타이틀 설정
      ),
      body: favoriteCoins.isEmpty
          ? const Center(
              child: Text('No favorite coins')) // 즐겨찾기 코인이 없을 때 메시지 표시
          : ListView.builder(
              itemCount: favoriteCoins.length, // 리스트 항목 개수 설정
              itemBuilder: (context, index) {
                final coin = favoriteCoins[index]; // 현재 인덱스의 코인 데이터 가져오기
                return ListTile(
                  title: Text(coin['symbol']), // 코인 심볼 표시
                  subtitle: Text('Price: \$${coin['price']}'), // 코인 가격 표시
                );
              },
            ),
    );
  }
}
