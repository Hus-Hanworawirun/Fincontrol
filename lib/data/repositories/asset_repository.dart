import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/asset_model.dart';

class AssetRepository {
  final String baseUrl = 'http://10.0.2.2:8000';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Stream<List<AssetModel>> getAssets([String? portfolioId]) async* {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/assets'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      var assets = data.map((item) => AssetModel.fromMap(item, item['id'])).toList();
      
      if (portfolioId != null && portfolioId.isNotEmpty) {
        assets = assets.where((a) => a.portfolioId == portfolioId).toList();
      }
      yield assets;
    } else {
      throw Exception('Failed to load assets');
    }
  }

  Future<void> addAsset(AssetModel asset) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/assets'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(asset.toMap()..remove('id')), // Remove empty ID
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add asset');
    }
  }

  Future<void> updateAssetCurrentPrice(String id, double currentPrice) async {
    // We can fetch it first, or just hit the PUT endpoint with the full object
    // Or we could make a PATCH endpoint. Since we only have PUT, let's omit or change.
    // For now we just implement the full update:
  }

  Future<void> updateAsset(AssetModel asset) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/assets/${asset.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(asset.toMap()..remove('id')),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update asset');
    }
  }

  Future<void> deleteAsset(String id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/assets/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete asset');
    }
  }
}
