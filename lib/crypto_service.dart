import 'dart:convert'; // JSON 인코딩 및 디코딩을 위한 패키지
import 'package:flutter/services.dart' show rootBundle; // 리소스 로드를 위한 패키지
import 'package:http/http.dart' as http; // HTTP 요청을 위한 패키지

class CryptoService {
  List<Map<String, dynamic>> favoriteCoins = []; // 즐겨찾기 코인 목록을 저장할 리스트

  // 코인 데이터를 가져오는 메서드
  Future<List<dynamic>> fetchAllCoins() async {
    final response = await http.get(Uri.parse(
        'https://api.binance.com/api/v3/ticker/price')); // Binance API에서 코인 데이터를 가져옴

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

  // API 키 로드 메서드
  static Future<String> loadApiKey() async {
    try {
      final jsonStr = await rootBundle.loadString(
          'assets/config.json'); // assets/config.json 파일에서 API 키를 로드
      final jsonMap = jsonDecode(jsonStr); // 로드된 JSON 문자열을 디코딩하여 맵 형식으로 변환
      return jsonMap['BINANCE_API_KEY'] ??
          (throw Exception('API key not found')); // API 키가 존재하면 반환, 없으면 예외 발생
    } catch (e) {
      throw Exception('Failed to load API key: $e'); // API 키 로드 실패 시 예외 발생
    }
  }

  // 시크릿 키 로드 메서드
  static Future<String> loadSecretKey() async {
    try {
      final jsonStr = await rootBundle.loadString(
          'assets/config.json'); // assets/config.json 파일에서 시크릿 키를 로드
      final jsonMap = jsonDecode(jsonStr); // 로드된 JSON 문자열을 디코딩하여 맵 형식으로 변환
      return jsonMap['BINANCE_SECRET_KEY'] ??
          (throw Exception(
              'Secret key not found')); // 시크릿 키가 존재하면 반환, 없으면 예외 발생
    } catch (e) {
      throw Exception('Failed to load secret key: $e'); // 시크릿 키 로드 실패 시 예외 발생
    }
  }

  // 초기화 메서드
  Future<void> initialize() async {
    final apiKey = await loadApiKey(); // API 키 로드
    final secretKey = await loadSecretKey(); // 시크릿 키 로드
    // 로드된 키 사용
  }
}
