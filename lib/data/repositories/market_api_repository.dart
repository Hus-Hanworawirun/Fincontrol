import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketApiRepository {
  final String _apiKey = 'YOUR_ALPHA_VANTAGE_API_KEY';
  final String _baseUrl = 'https://www.alphavantage.co/query';

  Future<double> getStockPrice(String symbol) async {
    final url = Uri.parse('$_baseUrl?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$_apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('Global Quote') && data['Global Quote'].containsKey('05. price')) {
          return double.parse(data['Global Quote']['05. price']);
        }
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> getCryptoPrice(String symbol) async {
    // Note: Alpha Vantage uses CURRENCY_EXCHANGE_RATE for crypto to fiat.
    final url = Uri.parse('$_baseUrl?function=CURRENCY_EXCHANGE_RATE&from_currency=$symbol&to_currency=USD&apikey=$_apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('Realtime Currency Exchange Rate') && 
            data['Realtime Currency Exchange Rate'].containsKey('5. Exchange Rate')) {
          return double.parse(data['Realtime Currency Exchange Rate']['5. Exchange Rate']);
        }
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }
}
