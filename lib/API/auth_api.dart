import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthAPI {
  static const String baseUrl = 'http://127.0.0.1:8000/api/alphabet'; // Ganti URL backend-mu

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> fetchAlphabet(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/alphabet'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // kalau backend pakai Bearer token
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Biasanya list data
    } else {
      throw Exception('Failed to fetch alphabet');
    }
  }

}
