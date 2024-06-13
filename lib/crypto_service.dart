import 'dart:convert'; // JSON 인코딩 및 디코딩을 위한 패키지
import 'package:http/http.dart' as http; // HTTP 요청을 위한 패키지

class CryptoService {
  List<Map<String, dynamic>> favoriteCoins = []; // 즐겨찾기 코인 목록을 저장할 리스트

  // 코인 데이터를 가져오는 메서드
  Future<List<dynamic>> fetchAllCoins() async {
    final apiKey = const String.fromEnvironment('BINANCE_API_KEY');
    final response = await http.get(
      Uri.parse('https://api.binance.com/api/v3/ticker/price'),
      headers: {
        'X-MBX-APIKEY': apiKey,
      },
    ); // Binance API에서 코인 데이터를 가져옴

    if (response.statusCode == 200) {
      List<dynamic> coins = jsonDecode(response.body); // 응답 데이터를 JSON 형식으로 디코딩
      // USDT로 끝나는 코인들만 필터링
      List<dynamic> usdtCoins = coins
          .where((coin) => coin['symbol'].endsWith('USDT'))
          .toList(); // USDT로 끝나는 코인만 필터링하여 리스트에 저장
      return usdtCoins; // 필터링된 코인 리스트 반환
    } else {
      throw Exception('Failed to load coin data'); // 데이터 로드 실패 시 예외 발생
    }
  }

  // 즐겨찾기 추가 메서드
  void addToFavorites(Map<String, dynamic> coin) {
    if (!favoriteCoins.any((element) => element['symbol'] == coin['symbol'])) {
      // 이미 즐겨찾기에 없는 코인만 추가
      favoriteCoins.add(coin); // 즐겨찾기 리스트에 코인 추가
    }
  }

  // 즐겨찾기 목록 가져오는 메서드
  List<Map<String, dynamic>> getFavoriteCoins() {
    return favoriteCoins; // 즐겨찾기 코인 리스트 반환
  }
}
