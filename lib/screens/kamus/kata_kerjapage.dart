import 'package:flutter/material.dart';

class KataKerjaPage extends StatelessWidget {
  final String kata;

  const KataKerjaPage({Key? key, required this.kata}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            color: Color(0xFF2D4A7A),
            padding:
                const EdgeInsets.only(top: 50, left: 8, right: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                  icon: Icon(Icons.replay, color: Colors.white),
                  onPressed: () {
                    // Aksi ulang (putar ulang animasi/suara) bisa ditambahkan di sini
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 100),

          // Kotak kata
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  kata,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),
          Text(
            "Bisindo",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
