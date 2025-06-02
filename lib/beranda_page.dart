// Tetap seperti semula, bagian import
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobilebita/informasi_page.dart';
import 'package:mobilebita/profil_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'deteksi.dart';
import 'transcrib.dart';
import 'kamus.dart';

// Model User
class User {
  final String name;

  User({required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('user') && json['user'] != null) {
      return User(name: json['user']['name']);
    } else if (json.containsKey('name')) {
      return User(name: json['name']);
    } else {
      throw Exception('Struktur response tidak valid');
    }
  }
}

// Main Page
class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  List<dynamic> informasi = [];
  bool isLoading = true;
  String? error;
  late Future<User> futureUser;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
    fetchInformasi();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InformasiPage()),
        ).then((_) => setState(() => _selectedIndex = 0));
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilPage()),
        ).then((_) => setState(() => _selectedIndex = 0));
        break;
    }
  }

  Future<User> fetchUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      print('Token from SharedPreferences: $token');

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await http.get(
        Uri.parse('https://bisiktangan.my.id/api/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is Map<String, dynamic>) {
          return User.fromJson(jsonResponse);
        } else {
          throw Exception('Format response tidak valid');
        }
      } else if (response.statusCode == 401) {
        await _handleTokenExpired();
        throw Exception('Token tidak valid atau expired');
      } else {
        throw Exception('Gagal memuat data user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchUser: $e');
      rethrow;
    }
  }

  Future<void> _handleTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
    Get.offAllNamed('/login');
  }

  Future<void> fetchInformasi() async {
    try {
      final response =
          await http.get(Uri.parse('https://bisiktangan.my.id/api/informasi'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          informasi = jsonData;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Gagal mengambil data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void showDetailDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item['judul']),
        content: SingleChildScrollView(
          child: Column(
            children: [
              if (item['gambar'] != null)
                Image.network(item['gambar'], height: 150),
              const SizedBox(height: 10),
              Text(item['detail_informasi']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dataTerbaru =
        informasi.cast<Map<String, dynamic>>().take(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<User>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildLoadingHeader(context);
                } else if (snapshot.hasError) {
                  return buildErrorHeader(context);
                } else if (snapshot.hasData) {
                  return buildHeader(snapshot.data!.name);
                }
                return buildDefaultHeader();
              },
            ),
            const SizedBox(height: 20),

            // Menu Fitur
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FeatureMenu(
                    iconPath: 'assets/deteksi.png',
                    label: 'Deteksi',
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DeteksiPage())),
                  ),
                  FeatureMenu(
                    iconPath: 'assets/transcrib.png',
                    label: 'Transcribe',
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TranscribPage())),
                  ),
                  FeatureMenu(
                    iconPath: 'assets/kamus.png',
                    label: 'Kamus',
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => KamusScreen())),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Banner Carousel
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
                                Text('Yuk belajar',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                SizedBox(height: 10),
                                Text('Coba Fitur Sekarang',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.white)),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Image.asset('assets/person2.png',
                                height: 150, fit: BoxFit.contain),
                          )
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            // Informasi Terkini
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

            // Daftar informasi
            SizedBox(
              height: 120,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: informasi.isEmpty
                      ? const Center(child: Text("Belum ada informasi."))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: dataTerbaru.length,
                          itemBuilder: (context, index) {
                            final item = dataTerbaru[index];
                            return GestureDetector(
                              onTap: () => showDetailDialog(item),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: index == dataTerbaru.length - 1
                                        ? 0
                                        : 12),
                                child: Container(
                                  width: 180,
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Gambar (jika ada)
                                      if (item['gambar'] != null &&
                                          item['gambar'] != '')
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15)),
                                          child: Image.network(
                                            item['gambar'],
                                            height: 80,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      // Judul
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          item['judul'] ?? 'Tanpa Judul',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Header Helper
  Widget buildLoadingHeader(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(
            16, MediaQuery.of(context).padding.top + 16, 16, 20),
        height: 200,
        decoration: const BoxDecoration(color: Color(0xFF253A7D)),
        child: const Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
      );

  Widget buildErrorHeader(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(
            16, MediaQuery.of(context).padding.top + 16, 16, 20),
        height: 200,
        decoration: const BoxDecoration(color: Color(0xFF253A7D)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 48),
            const SizedBox(height: 8),
            const Text("Gagal memuat data pengguna",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => setState(() => futureUser = fetchUser()),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );

  Widget buildDefaultHeader() => Container(
      height: 200, decoration: const BoxDecoration(color: Color(0xFF253A7D)));

  Widget buildHeader(String name) => Container(
        padding: EdgeInsets.fromLTRB(
            16, MediaQuery.of(context).padding.top + 16, 16, 0),
        height: 200,
        decoration: const BoxDecoration(color: Color(0xFF253A7D)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selamat Datang,',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text(name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text('Mulai petualangan bahasa isyarat Anda hari ini!',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/person1.png',
                  height: MediaQuery.of(context).size.height * 0.22,
                  fit: BoxFit.contain),
            )
          ],
        ),
      );
}

// Feature Menu
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
