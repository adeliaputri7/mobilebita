import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobilebita/screens/register_screens.dart';
import 'package:mobilebita/beranda_page.dart';
import 'package:mobilebita/lupapassword/lp_email.dart';

import 'package:mobilebita/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false; // Loading state

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Validasi input
  bool _validateInput() {
    if (_emailController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Email tidak boleh kosong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (!GetUtils.isEmail(_emailController.text.trim())) {
      Get.snackbar(
        "Error",
        "Format email tidak valid",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (_passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Password tidak boleh kosong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (_passwordController.text.length < 6) {
      Get.snackbar(
        "Error",
        "Password minimal 6 karakter",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  Future<void> _loginUser() async {
    // Validasi input dulu
    if (!_validateInput()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse(
          'https://bisiktangan.my.id/api/login'); // Tambahkan port 8000

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json', // Penting untuk Laravel API
            },
            body: json.encode({
              'email': _emailController.text.trim(),
              'password': _passwordController.text,
            }),
          )
          .timeout(const Duration(seconds: 15)); // Timeout 15 detik

      // Debug: print response
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Handle different response structures
        final token =
            data['token'] ?? data['access_token'] ?? data['data']?['token'];
        final user = data['user'] ?? data['data']?['user'] ?? data['data'];

        if (token != null) {
          // Simpan token dan data user
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);

          if (user != null) {
            await prefs.setString('user_data', json.encode(user));
          }

          // Simpan "Remember Me" preference
          if (_rememberMe) {
            await prefs.setBool('remember_me', true);
            await prefs.setString('saved_email', _emailController.text.trim());
          }

          Get.snackbar(
            "Sukses",
            "Login berhasil!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Navigate dengan delay untuk menampilkan snackbar
          await Future.delayed(const Duration(milliseconds: 500));
          Get.offAll(() => const HomePage());
        } else {
          Get.snackbar(
            "Error",
            "Token tidak ditemukan dalam response",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else if (response.statusCode == 401) {
        Get.snackbar(
          "Error",
          "Email atau password salah",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (response.statusCode == 422) {
        // Validation errors
        final errorData = json.decode(response.body);
        String errorMessage = "Validation error";

        if (errorData['errors'] != null) {
          final errors = errorData['errors'] as Map<String, dynamic>;
          errorMessage = errors.values.first[0].toString();
        } else if (errorData['message'] != null) {
          errorMessage = errorData['message'].toString();
        }

        Get.snackbar(
          "Error",
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Server error: ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on SocketException {
      Get.snackbar(
        "Error",
        "Tidak dapat terhubung ke server. Periksa koneksi internet Anda.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } on http.ClientException {
      Get.snackbar(
        "Error",
        "Network error. Periksa koneksi internet Anda.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } on FormatException {
      Get.snackbar(
        "Error",
        "Response server tidak valid",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Login Error: $e');
      Get.snackbar(
        "Error",
        "Terjadi kesalahan: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Load saved email jika "Remember Me" aktif
  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('remember_me') ?? false;

    if (rememberMe) {
      String savedEmail = prefs.getString('saved_email') ?? '';
      setState(() {
        _rememberMe = rememberMe;
        _emailController.text = savedEmail;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text(
              'Login',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Jika anda belum punya akun, anda dapat '),
                GestureDetector(
                  onTap: () => Get.to(() => const RegisterPage()),
                  child: const Text(
                    'Daftar disini !',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            const Text("Email"),
            const SizedBox(height: 4),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: 'Masukkan email anda',
                prefixIcon: Icon(Icons.email),
                border: UnderlineInputBorder(),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Password"),
            const SizedBox(height: 4),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _loginUser(),
              decoration: InputDecoration(
                hintText: 'Masukkan password anda',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: const UnderlineInputBorder(),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text("Ingat Saya"),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EmailConfirmationPage()),
                    );
                  },
                  child: const Text(
                    "Lupa Password ?",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isLoading ? Colors.grey : const Color(0xFF6495ED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Logging in...',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Atau lanjutkan dengan',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: () {
                  // TODO: Implement Google Sign In
                  Get.snackbar("Info", "Google Sign In belum tersedia");
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(
                    Icons.g_mobiledata,
                    size: 32,
                    color: Colors.red,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
