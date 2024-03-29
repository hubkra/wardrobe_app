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

  Future<void> createOutfit(String name, List<Wardrobe> wardrobeItems) async {
    final Map<String, dynamic> requestBody = {
      'wardrobeItems': wardrobeItems.map((item) => item.toJson()).toList(),
      'name': name
    };

    try {
      await http.post(
        Uri.parse('http://localhost:8080/api/outfits'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('Pomyślnie wysłano żądanie utworzenia stroju.');
    } catch (error) {
      print('Błąd podczas wysyłania żądania utworzenia stroju: $error');
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

    if (response.statusCode == 204) {
      // Outfit usunięty pomyślnie
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<Outfit> updateOutfit(int id, Outfit outfit) async {
    final response = await http.put(
      Uri.parse('http://localhost:8080/api/outfits/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(outfit.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final Outfit updatedOutfit = Outfit.fromJson(json);
      return updatedOutfit;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }
}
