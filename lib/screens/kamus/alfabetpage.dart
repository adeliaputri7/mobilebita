import 'package:flutter/material.dart';

class AlfabetPage extends StatelessWidget {
  final String huruf;
  final String bahasaIsyarat;

  const AlfabetPage({
    Key? key,
    required this.huruf,
    required this.bahasaIsyarat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header biru dengan tombol kembali dan bulatan kanan atas
          Container(
            height: 100,
            color: Color(0xFF2D4A7A),
            child: Stack(
              children: [
                Positioned(
                  top: 50,
                  left: 10,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 20,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xFF2D4A7A),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 100),

          // Huruf besar dalam card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
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
                  fontSize: 24,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            bahasaIsyarat,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
