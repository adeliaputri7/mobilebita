import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmailConfirmationPage extends StatefulWidget {
  const EmailConfirmationPage({Key? key}) : super(key: key);

  @override
  State<EmailConfirmationPage> createState() => _EmailConfirmationPageState();
}

class _EmailConfirmationPageState extends State<EmailConfirmationPage> {
  final TextEditingController _emailController = TextEditingController();
  bool loading = false;

  final String baseUrl =
      'http://localhost:8000/api/request-otp'; // Ganti dengan API kamu

  Future<void> verifyEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan email yang valid')),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/request-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      setState(() {
        loading = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email valid, OTP telah dikirim.')),
        );
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Email tidak ditemukan')),
        );
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konfirmasi Email')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      hintText: 'Masukkan email Anda',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                  onPressed: verifyEmail,
                 style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.blue, // Warna tombol biru
                 minimumSize: const Size(double.infinity, 50),
                 shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(8),
                 ),
                 ),
                 child: const Text(
                'Verifikasi Email',
                 style: TextStyle(color: Colors.white), // Warna teks putih
                 ),
                  ),

                ],
              ),
      ),
    );
  }
}
