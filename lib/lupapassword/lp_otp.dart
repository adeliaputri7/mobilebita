import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'lp_resetpw.dart'; // halaman reset password

class VerifyCodePage extends StatefulWidget {
  final String email; // Kirim dari halaman sebelumnya

  const VerifyCodePage({required this.email, Key? key}) : super(key: key);

  @override
  _VerifyCodePageState createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final List<TextEditingController> _controllers =
      List.generate(5, (_) => TextEditingController());

  bool _isLoading = false;

  Future<void> _verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();

    if (otp.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lengkapi semua kolom OTP")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(
            'https://localhost:8000/api/verify-otp'), // Ganti URL sesuai hosting kamu
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'otp': otp,
        }),
      );

      final result = jsonDecode(response.body);
      if (response.statusCode == 200 && result['status'] == 'success') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PasswordResetPage(
              email: widget.email,
              otp: otp,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? "OTP tidak valid")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal terhubung ke server")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _resendEmail() async {
    // Panggil endpoint untuk resend OTP
    try {
      await http.post(
        Uri.parse('http://localhost:8000/api//verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email}),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kode OTP telah dikirim ulang")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengirim ulang kode")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(height: 20),
            Text("Check email anda",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Masukkan 5 digit kode yang tertera"),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _controllers[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: InputDecoration(counterText: ""),
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtp,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Verifikasi Kode"),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50)),
            ),
            TextButton(
              onPressed: _resendEmail,
              child: Text("Kirim ulang email"),
            )
          ],
        ),
      ),
    );
  }
}
