import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';

class BackendService {
  final String baseUrl = 'http://localhost:8080';

  Future<User> registerUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/registerUser'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Wystąpił problem podczas rejestracji użytkownika.');
    }
  }

  Future<dynamic> loginUser(User user) async {
    final url = Uri.parse('http://localhost:8080/login');
    final response = await http.post(
      url,
      body: json.encode(user.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }
}
