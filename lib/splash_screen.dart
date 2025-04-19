import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart'; // Halaman utama yang akan dituju

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay 3 detik lalu pindah ke halaman utama
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MyHomePage(title: 'Aplikasi Donasi'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Ganti gambar sesuai dengan tema aplikasi donasi
            Image.asset(
              'assets/splash/splashscreen.png', // Pastikan gambar sudah ada di folder assets
              width: 200,
            ),
            const SizedBox(height: 20),
            // Menambahkan teks atau logo jika perlu
            const Text(
              'Selamat Datang di Aplikasi Donasi!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
