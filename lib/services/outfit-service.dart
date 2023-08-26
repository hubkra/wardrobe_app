import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/outfit.dart';
import '../models/wardrobe.dart';

class OutfitService {
  Future<List<Outfit>> fetchOutfits() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/outfits'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<Outfit> outfits =
          jsonList.map((e) => Outfit.fromJson(e)).toList();

      return outfits;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<Outfit> createOutfit(String name, List<Wardrobe> wardrobeItems) async {
    final Map<String, dynamic> requestBody = {
      'wardrobeItems': wardrobeItems.map((item) => item.toJson()).toList(),
      'name': name
    };

    final response = await http.post(
      Uri.parse('http://localhost:8080/api/outfits'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final Outfit newOutfit = Outfit.fromJson(json);
      return newOutfit;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<Outfit> fetchOutfitById(int id) async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/outfits/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final Outfit outfit = Outfit.fromJson(json);
      return outfit;
    } else {
      throw Exception(
          'Failed to fetch outfit with status code: ${response.statusCode}.');
    }
  }

  Future<void> deleteOutfit(int id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:8080/api/outfits/$id'),
    );

    if (response.statusCode == 200) {
      // Outfit usunięty pomyślnie
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }
}
