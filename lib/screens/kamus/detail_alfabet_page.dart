import 'package:flutter/material.dart';

class DetailAlfabetPage extends StatelessWidget {
  final String huruf;
  final String bahasaIsyarat;
  final String? gambarUrl; // opsional, jika ingin tampilkan gambar
  final String? videoUrl; // opsional, jika ingin tampilkan video

  const DetailAlfabetPage({
    Key? key,
    required this.huruf,
    required this.bahasaIsyarat,
    this.gambarUrl,
    this.videoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Huruf'),
        backgroundColor: Color(0xFF2D4A7A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Card Huruf
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  huruf,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Deskripsi
            Text(
              bahasaIsyarat,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Tampilkan gambar jika ada
            if (gambarUrl != null)
              Image.network(
                gambarUrl!,
                height: 200,
                errorBuilder: (context, error, stackTrace) =>
                    Text("Gambar tidak tersedia"),
              ),

            const SizedBox(height: 20),

            // Tampilkan video jika ada
            if (videoUrl != null)
              Text(
                'Video bahasa isyarat:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            if (videoUrl != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  videoUrl!,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
