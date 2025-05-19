import 'package:flutter/material.dart';
import 'alfabetpage.dart'; // import halaman alfabetpage.dart

class AlfabetScreen extends StatelessWidget {
  final List<String> alfabet =
      List.generate(26, (index) => String.fromCharCode(65 + index));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            color: Color(0xFF2D4A7A),
            padding: EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white),
                    Spacer(),
                    Text(
                      "Alfabet",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Spacer(),
                    SizedBox(width: 24),
                  ],
                ),
                SizedBox(height: 20),
                Image.asset(
                  'assets/abc.png',
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),

          // Daftar huruf
          Expanded(
            child: ListView.builder(
              itemCount: alfabet.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Divider(height: 1),
                    ListTile(
                      title: Text(
                        alfabet[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Navigasi ke halaman huruf
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlfabetPage(
                              huruf: alfabet[index],
                              bahasaIsyarat: "Bisindo",
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
