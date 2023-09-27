import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class UserApiService {
  final String baseUrl = 'http://localhost:8080/api/users';

  Future<String> uploadProfilePicture(User user, String filePath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));
      request.fields['userEmailId'] = user.emailId;

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        filePath,
      ));

      var response = await request.send();
      if (response.statusCode == 200) {
        return 'Zdjęcie użytkownika zostało zaktualizowane.';
      } else if (response.statusCode == 404) {
        return 'Użytkownik o podanym adresie e-mail nie istnieje.';
      } else {
        return 'Błąd podczas przesyłania zdjęcia.';
      }
    } catch (e) {
      return 'Błąd podczas przesyłania zdjęcia: $e';
    }
  }

  Future<String> updateUser(User user) async {
    try {
      var response = await http.put(
        Uri.parse('$baseUrl/update/${user.emailId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        return 'Dane użytkownika zostały zaktualizowane.';
      } else if (response.statusCode == 404) {
        return 'Użytkownik o podanym adresie e-mail nie istnieje.';
      } else {
        return 'Błąd podczas aktualizacji danych użytkownika.';
      }
    } catch (e) {
      return 'Błąd podczas aktualizacji danych użytkownika: $e';
    }
  }

  Future<User?> getUser(String userEmailId) async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/$userEmailId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> userMap = json.decode(response.body);
        return User.fromJson(userMap);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Błąd podczas pobierania użytkownika');
      }
    } catch (e) {
      throw Exception('Błąd podczas pobierania użytkownika: $e');
    }
  }
}
