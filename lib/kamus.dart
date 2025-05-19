import 'package:flutter/material.dart';

void main() => runApp(KamusApp());

class KamusApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kamus Bisindo',
      home: KamusScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class KamusScreen extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {'title': 'Alfabet', 'image': 'assets/alfabet.png'},
    {'title': 'Kata Tanya', 'image': 'assets/kata_tanya.png'},
    {'title': 'Kata Kerja', 'image': 'assets/kata_kerja.png'},
    {'title': 'Kata Sifat', 'image': 'assets/kata_sifat.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Color(0xFF2B4570),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Kamus',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Ayo, Belajar\nBahasa Isyarat Bisindo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Jangan biarkan batasan bahasa menghalangi!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: GridView.builder(
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryCard(
                      title: category['title']!,
                      imagePath: category['image']!,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;

  const CategoryCard({
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
