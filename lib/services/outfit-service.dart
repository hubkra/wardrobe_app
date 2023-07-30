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

  Future<void> _createOutfit(List<Wardrobe> wardrobeItems) async {
    try {
      final newOutfit = await _createOutfit(wardrobeItems);
      // Możesz coś zrobić z nowym strojem, jeśli to konieczne
      // np. wyświetlić go na ekranie lub zaktualizować listę strojów
    } catch (error) {
      // Obsłuż błąd, jeśli wystąpił
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

  // Pozostałe metody serwisu...
}
