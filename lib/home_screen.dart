import 'package:flutter/material.dart'; // Flutter의 UI 요소를 위한 패키지
import 'crypto_service.dart'; // CryptoService 클래스를 가져오기 위한 패키지

// HomeScreen 클래스 정의
class HomeScreen extends StatelessWidget {
  final CryptoService cryptoService; // CryptoService 인스턴스 변수 선언

  const HomeScreen({super.key, required this.cryptoService}); // 생성자 정의

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 수직 중앙 정렬
        children: [
          ElevatedButton(
            onPressed: () {
              // 홈 화면 버튼 동작 추가
            },
            child: const Text('Home Screen Button'), // 버튼 텍스트 설정
          ),
        ],
      ),
    );
  }
}
