import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketApiRepository {
  final String _baseUrl = 'https://query1.finance.yahoo.com/v8/finance/chart';

  Future<double> getPrice(String tickerSymbol) async {
    if (tickerSymbol.isEmpty) return 0.0;
    
    final url = Uri.parse('$_baseUrl/$tickerSymbol');
    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'Mozilla/5.0'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['chart']?['result'];
        if (result != null && result.isNotEmpty) {
          final meta = result[0]['meta'];
          if (meta != null && meta['regularMarketPrice'] != null) {
            return (meta['regularMarketPrice'] as num).toDouble();
          }
        }
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> getStockPrice(String tickerSymbol) => getPrice(tickerSymbol);
  
  Future<double> getCryptoPrice(String tickerSymbol) => getPrice(tickerSymbol);

  Future<List<double>> getChartData(String tickerSymbol, {String interval = '15m', String range = '1d'}) async {
    if (tickerSymbol.isEmpty) return [];
    
    final url = Uri.parse('$_baseUrl/$tickerSymbol?interval=$interval&range=$range');
    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'Mozilla/5.0'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['chart']?['result'];
        if (result != null && result.isNotEmpty) {
          final indicators = result[0]['indicators'];
          if (indicators != null && indicators['quote'] != null && indicators['quote'].isNotEmpty) {
            final closePrices = indicators['quote'][0]['close'];
            if (closePrices is List) {
              return closePrices.where((e) => e != null).map((e) => (e as num).toDouble()).toList();
            }
          }
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
