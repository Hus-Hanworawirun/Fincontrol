import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/portfolio_model.dart';

class PortfolioRepository {
  final String baseUrl = 'http://10.0.2.2:8000';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Stream<List<PortfolioModel>> getPortfolios(String userId) async* {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/portfolios'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      yield data.map((item) => PortfolioModel.fromMap(item, item['id'])).toList();
    } else {
      throw Exception('Failed to load portfolios');
    }
  }

  Future<void> addPortfolio(PortfolioModel portfolio) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/portfolios'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(portfolio.toMap()..remove('id')), // Remove empty ID
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add portfolio');
    }
  }

  Future<void> updatePortfolio(PortfolioModel portfolio) async {
    // We didn't add PUT /portfolios to the backend yet, but we can if needed
  }

  Future<void> deletePortfolio(String id) async {
    // We didn't add DELETE /portfolios to the backend yet, but we can if needed
  }
}
