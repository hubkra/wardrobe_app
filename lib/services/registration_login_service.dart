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

  Future<User> loginUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Wystąpił problem podczas logowania.');
    }
  }
}
