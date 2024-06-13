import 'package:flutter/material.dart'; // Flutter의 UI 요소를 위한 패키지
import 'crypto_service.dart'; // CryptoService 클래스를 가져오기 위한 패키지

// FavoriteCoinsScreen 클래스 정의
class FavoriteCoinsScreen extends StatefulWidget {
  FavoriteCoinsScreen({super.key}); // 생성자 정의

  @override
  _FavoriteCoinsScreenState createState() =>
      _FavoriteCoinsScreenState(); // 상태 클래스 생성
}

// 상태 클래스 정의
class _FavoriteCoinsScreenState extends State<FavoriteCoinsScreen> {
  final CryptoService cryptoService = CryptoService(); // CryptoService 인스턴스 생성
  final List<Map<String, dynamic>> _favoriteCoins = []; // 즐겨찾기 코인 목록을 저장할 리스트

  // 코인 삭제 메서드
  void _deleteCoin(String coinName) {
    setState(() {
      _favoriteCoins
          .removeWhere((coin) => coin['name'] == coinName); // 코인 이름으로 리스트에서 삭제
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Coins'), // 앱바 타이틀 설정
      ),
      body: ListView.builder(
        itemCount: _favoriteCoins.length, // 리스트 항목 개수 설정
        itemBuilder: (context, index) {
          final data = _favoriteCoins[index]; // 현재 인덱스의 코인 데이터 가져오기
          return ListTile(
            title: Text(data['name']), // 코인 이름 표시
            subtitle: Text('USD: ${data['price']}'), // 코인 가격 표시
            trailing: IconButton(
              icon: const Icon(Icons.delete), // 삭제 아이콘 설정
              onPressed: () =>
                  _deleteCoin(data['name']), // 삭제 버튼 클릭 시 코인 삭제 메서드 호출
            ),
          );
        },
      ),
    );
  }
}
