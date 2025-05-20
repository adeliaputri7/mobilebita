import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'deteksi.dart';
import 'transcrib.dart';
import 'kamus.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top + 16,
                16,
                0,
              ),
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xFF253A7D),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Hai,',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                        Text('Safina Adelia',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text(
                          'Mulai petualangan bahasa isyarat Anda hari ini!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/person1.png',
                      height: MediaQuery.of(context).size.height * 0.22,
                      fit: BoxFit.contain,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // FITUR UTAMA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FeatureMenu(
                    iconPath: 'assets/deteksi.png',
                    label: 'Deteksi',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DeteksiPage(),
                        ),
                      );
                    },
                  ),
                  FeatureMenu(
                    iconPath: 'assets/transcrib.png',
                    label: ' Transcribe ',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TranscribPage(),
                        ),
                      );
                    },
                  ),
                  FeatureMenu(
                    iconPath: 'assets/kamus.png',
                    label: 'Kamus ',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KamusScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // BANNER "Yuk belajar"
            CarouselSlider(
              options: CarouselOptions(
                height: 180.0,
                enlargeCenterPage: true,
                autoPlay: true,
                viewportFraction: 0.9,
              ),
              items: [1, 2, 3, 4, 5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(
                        10,
                        MediaQuery.of(context).padding.top + 10,
                        10,
                        0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7A51B),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Yuk belajar',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Coba Fitur Sekarang',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Image.asset(
                              'assets/person2.png',
                              height: MediaQuery.of(context).size.height * 0.22,
                              fit: BoxFit.contain,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            // INFORMASI TERKINI
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Informasi Terkini',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Jangan lewatkan informasi terkini dari BiTa'),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // CARD INFORMASI
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class FeatureMenu extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onPressed;

  const FeatureMenu({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath, width: 64, height: 64),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
