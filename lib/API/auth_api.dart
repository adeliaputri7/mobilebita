import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthAPI {
  static const String baseUrl = 'https://bisiktangan.my.id/api';
  static const Duration timeoutDuration = Duration(seconds: 15);

  // 1. LOGIN dengan error handling lengkap
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      // Validasi input
      if (email.isEmpty || password.isEmpty) {
        return {
          'success': false,
          'message': 'Email and password are required',
        };
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(timeoutDuration);

      // Handle different status codes
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'token': data['token'] ??
              data['access_token'], // Handle different token keys
          'user': data['user'] ?? data['data'],
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Invalid email or password',
        };
      } else if (response.statusCode == 422) {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Validation error',
          'errors': errorData['errors'] ?? errorData['message'],
        };
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } on SocketException {
      return {
        'success': false,
        'message': 'No internet connection or server unreachable',
      };
    } on http.ClientException {
      return {
        'success': false,
        'message': 'Network error occurred',
      };
    } on FormatException {
      return {
        'success': false,
        'message': 'Invalid response format from server',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Unexpected error: ${e.toString()}',
      };
    }
  }

  // 2. REGISTER dengan error handling
  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      // Validasi input
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        return {
          'success': false,
          'message': 'All fields are required',
        };
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'password_confirmation':
                  password, // Jika backend memerlukan konfirmasi
            }),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Registration successful',
        };
      } else if (response.statusCode == 422) {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Validation error',
          'errors': errorData['errors'] ?? errorData['message'],
        };
      } else {
        return {
          'success': false,
          'message': 'Registration failed: ${response.statusCode}',
        };
      }
    } on SocketException {
      return {
        'success': false,
        'message': 'No internet connection',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Registration error: ${e.toString()}',
      };
    }
  }

  // 3. LOGOUT function
  static Future<Map<String, dynamic>> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Logged out successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Logout failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Logout error: ${e.toString()}',
      };
    }
  }

  // 4. GET USER PROFILE
  static Future<Map<String, dynamic>> getUserProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'user': data,
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Token expired or invalid',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to get user profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error getting profile: ${e.toString()}',
      };
    }
  }

  // 5. FETCH ALPHABET (diperbaiki)
  static Future<Map<String, dynamic>> fetchAlphabet(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/alphabet'), // atau katasifat
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Token expired or invalid',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch data',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error fetching data: ${e.toString()}',
      };
    }
  }

  // 6. CHECK CONNECTION - untuk debug
  static Future<bool> checkConnection() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/test'), // atau endpoint yang pasti ada
          )
          .timeout(Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      print('Connection check failed: $e');
      return false;
    }
  }

  // 7. REFRESH TOKEN (jika backend support)
  static Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'token': data['token'] ?? data['access_token'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to refresh token',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Refresh token error: ${e.toString()}',
      };
    }
  }

  // 8. VALIDATE TOKEN
  static Future<bool> validateToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/validate-token'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
