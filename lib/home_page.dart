import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda BisikTangan'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/splash/splashscreen.png', // bisa ganti dengan logo kecil
              width: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Selamat datang di BisikTangan!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Aplikasi donasi & kepedulian sosial\nbersama komunitas terbaik ❤️',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman donasi, login, dll
              },
              child: const Text('Mulai Sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}
