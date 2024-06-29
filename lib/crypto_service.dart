import 'dart:convert'; // JSON encoding and decoding
import 'package:http/http.dart' as http; // HTTP requests

class CryptoService {
  List<Map<String, dynamic>> favoriteCoins = []; // List to store favorite coins

  // Read API key from environment variables
  final String _apiKey = const String.fromEnvironment('BINANCE_API_KEY');
  final String _secretKey = const String.fromEnvironment('BINANCE_SECRET_KEY');

  // Initialization method
  Future<void> initialize() async {
    // Print the API key and secret key loaded from environment variables
    print('API Key: $_apiKey');
    print('Secret Key: $_secretKey');
  }

  // Method to fetch all coins
  Future<List<dynamic>> fetchAllCoins() async {
    final response = await http.get(
      Uri.parse('https://api.binance.com/api/v3/ticker/price'),
      headers: {
        'X-MBX-APIKEY': _apiKey,
      },
    ); // Fetch coin data from Binance API

    if (response.statusCode == 200) {
      List<dynamic> coins = jsonDecode(response.body); // Decode the JSON response
      // Filter coins that end with 'USDT'
      List<dynamic> usdtCoins = coins
          .where((coin) => coin['symbol'].endsWith('USDT'))
          .toList();
      return usdtCoins; // Return the filtered list
    } else {
      throw Exception('Failed to load coin data'); // Throw an exception if the request failed
    }
  }

  // Method to add a coin to favorites
  void addToFavorites(Map<String, dynamic> coin) {
    if (!favoriteCoins.any((element) => element['symbol'] == coin['symbol'])) {
      favoriteCoins.add(coin); // Add coin to the list if it doesn't already exist
    }
  }

  // Method to get favorite coins
  List<Map<String, dynamic>> getFavoriteCoins() {
    return favoriteCoins; // Return the list of favorite coins
  }
}
