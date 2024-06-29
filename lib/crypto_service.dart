import 'dart:convert'; // JSON encoding and decoding
import 'package:flutter/services.dart' show rootBundle; // For loading resources
import 'package:http/http.dart' as http; // For HTTP requests

class CryptoService {
  List<Map<String, dynamic>> favoriteCoins = []; // List to store favorite coins

  // Method to fetch all coins
  Future<List<dynamic>> fetchAllCoins() async {
    final response = await http.get(Uri.parse(
        'https://api.binance.com/api/v3/ticker/price')); // Fetch coin data from Binance API

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

  // Method to load the API key
  static Future<String> loadApiKey() async {
    try {
      final jsonStr = await rootBundle.loadString(
          'assets/config.json'); // Load API key from config.json
      final jsonMap = jsonDecode(jsonStr); // Decode the JSON
      return jsonMap['BINANCE_API_KEY'] ??
          (throw Exception('API key not found')); // Return the API key or throw an exception
    } catch (e) {
      throw Exception('Failed to load API key: $e'); // Throw an exception if loading failed
    }
  }

  // Method to load the secret key
  static Future<String> loadSecretKey() async {
    try {
      final jsonStr = await rootBundle.loadString(
          'assets/config.json'); // Load secret key from config.json
      final jsonMap = jsonDecode(jsonStr); // Decode the JSON
      return jsonMap['BINANCE_SECRET_KEY'] ??
          (throw Exception('Secret key not found')); // Return the secret key or throw an exception
    } catch (e) {
      throw Exception('Failed to load secret key: $e'); // Throw an exception if loading failed
    }
  }

  // Initialization method
  Future<void> initialize() async {
    final apiKey = await loadApiKey(); // Load the API key
    final secretKey = await loadSecretKey(); // Load the secret key
    // Use the loaded keys
  }
}
