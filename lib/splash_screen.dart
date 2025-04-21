import 'dart:async';
import 'package:flutter/material.dart';
import 'home_page.dart'; // Halaman utama yang akan dituju

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Background penuh satu layar
            Positioned.fill(
              child: Image.asset(
                'assets/splash/splashscreen.png',
                fit: BoxFit.cover, // Gambar akan menyesuaikan ukuran layar
              ),
            ),
          ],
        ),
      ),
    );
  }
}
