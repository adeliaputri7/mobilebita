import 'package:flutter/material.dart';
import 'kata_tanyapage.dart'; // Pastikan file ini ada

class KataTanyaScreen extends StatelessWidget {
  final List<String> kataTanya = [
    'Apa?',
    'Siapa?',
    'Kapan?',
    'Di mana?',
    'Mengapa?',
    'Bagaimana?',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Color(0xFF2D4A7A),
            padding:
                const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Spacer(),
                    Text(
                      "Kata Tanya",
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
                Center(
                  child: Image.asset(
                    'assets/question.png',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: kataTanya.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: Color(0xFF2D4A7A)),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    kataTanya[index],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KataTanyaPage(
                          kata: kataTanya[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
