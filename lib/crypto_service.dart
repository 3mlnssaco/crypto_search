import 'dart:convert'; // JSON 인코딩 및 디코딩을 위한 패키지
 import 'package:http/http.dart' as http; // HTTP 요청을 위한 패키지

 class CryptoService {
   List<Map<String, dynamic>> favoriteCoins = []; // 즐겨찾기 코인 목록을 저장할 리스트

   // 환경 변수에서 API 키를 읽어옴
   final String _apiKey = const String.fromEnvironment('BINANCE_API_KEY');
   final String _secretKey = const String.fromEnvironment('BINANCE_SECRET_KEY');

   // 초기화 메서드
   void initialize() {
     // 환경 변수에서 API 키와 시크릿 키를 로드하여 사용
     print('API Key: $_apiKey');
     print('Secret Key: $_secretKey');
   }

   // 코인 데이터를 가져오는 메서드
   Future<List<dynamic>> fetchAllCoins() async {
     final response = await http.get(
       Uri.parse('https://api.binance.com/api/v3/ticker/price'),
       headers: {
         'X-MBX-APIKEY': _apiKey,
       },
     ); // Binance API에서 코인 데이터를 가져옴

     if (response.statusCode == 200) {
       List<dynamic> coins = jsonDecode(response.body); // 응답 데이터를 JSON 형식으로 디코딩
 @@ -48,4 +34,38 @@ class CryptoService {
   List<Map<String, dynamic>> getFavoriteCoins() {
     return favoriteCoins; // 즐겨찾기 코인 리스트 반환
   }
