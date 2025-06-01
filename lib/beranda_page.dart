import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobilebita/informasi_page.dart';
import 'package:mobilebita/profil_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'deteksi.dart';
import 'transcrib.dart';
import 'kamus.dart';



class User {
  final String name;

  User({required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(name: json['name']);
  }
}

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  late Future<User> futureUser;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigasi ke halaman yang sesuai
    switch (index) {
      case 0:
        // Sudah di halaman Beranda, tidak perlu navigasi
        break;
      case 1:
        // Navigasi ke halaman Informasi
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InformasiPage(),
          ),
        ).then((_) {
          // Reset selected index ketika kembali ke beranda
          setState(() {
            _selectedIndex = 0;
          });
        });
        break;
      case 2:
        // Navigasi ke halaman Profil
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilPage(),
          ),
        ).then((_) {
          // Reset selected index ketika kembali ke beranda
          setState(() {
            _selectedIndex = 0;
          });
        });
        break;
    }
  }

  Future<User> fetchUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Token disimpan setelah login

    if (token == null) throw Exception('Token tidak ditemukan');

    final response = await http.get(
      Uri.parse('https://bisiktangan.my.id/api/user'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<User>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return buildHeader(snapshot.data!.name);
                } else if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Gagal memuat nama pengguna",
                        style: TextStyle(color: Colors.red)),
                  );
                }
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                );
              },
            ),
            const SizedBox(height: 20),

            // Menu fitur
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
                    label: 'Transcribe',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TranscribPage(),
                        ),
                      );
                    },
                  ),
                  FeatureMenu(
                    iconPath: 'assets/kamus.png',
                    label: 'Kamus',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KamusScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Banner carousel
            CarouselSlider(
              options: CarouselOptions(
                height: 180.0,
                enlargeCenterPage: true,
                autoPlay: true,
                viewportFraction: 0.9,
              ),
              items: [1, 2, 3].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
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
                              height: 100,
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

            // Informasi terkini
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

            // Card informasi
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF253A7D),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Informasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget buildHeader(String name) {
    return Container(
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
              children: [
                const Text('Hai,',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                Text(name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                const Text(
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
