import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/wardrobe.dart';

class WardrobeService {
  final String apiUrl = 'http://localhost:8080/wardrobe';

  Future<List<Wardrobe>> findClothes() async {
    final response = await http.get(Uri.parse('$apiUrl/all'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      return jsonData.map((item) => Wardrobe.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch clothes: ${response.statusCode}');
    }
  }

  Future<Wardrobe> findClothesById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/find/$id'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return Wardrobe.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch clothes: ${response.statusCode}');
    }
  }

  Future<Wardrobe> addClothes(Wardrobe wardrobe) async {
    final response = await http.post(
      Uri.parse('$apiUrl/add'),
      body: jsonEncode(wardrobe.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return Wardrobe.fromJson(jsonData);
    } else {
      throw Exception('Failed to add clothes: ${response.statusCode}');
    }
  }

  Future<Wardrobe> updateClothes(Wardrobe wardrobe) async {
    final response = await http.put(
      Uri.parse('$apiUrl/update'),
      body: jsonEncode(wardrobe.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return Wardrobe.fromJson(jsonData);
    } else {
      throw Exception('Failed to update clothes: ${response.statusCode}');
    }
  }

  Future<void> deleteClothes(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/delete/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete clothes: ${response.statusCode}');
    }
  }
}
