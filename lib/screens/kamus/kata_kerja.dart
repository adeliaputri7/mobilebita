import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'kata_kerjapage.dart';

class KataKerjaScreen extends StatefulWidget {
  const KataKerjaScreen({Key? key}) : super(key: key);

  @override
  State<KataKerjaScreen> createState() => _KataKerjaScreenState();
}

class _KataKerjaScreenState extends State<KataKerjaScreen> {
  List<dynamic> kataKerja = [];

  @override
  void initState() {
    super.initState();
    fetchKataKerja();
  }

  Future<void> fetchKataKerja() async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.202:8000/api/katakerja')); // Ganti URL jika perlu

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        kataKerja =
            data; // Sesuaikan jika response-nya berbentuk { "data": [...] }
      });
    } else {
      // Gagal ambil data
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            color: const Color(0xFF2D4A7A),
            padding:
                const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    const Text(
                      "Kata Kerja",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 24),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'assets/kerja.png',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          // List data
          Expanded(
            child: ListView.separated(
              itemCount: kataKerja.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: Color(0xFF2D4A7A)),
              itemBuilder: (context, index) {
                final item = kataKerja[index];
                return ListTile(
                  title: Text(
                    item['judul'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KataKerjaPage(
                          id: item['id'],
                          kata: item['judul'],
                          deskripsi: item['deskripsi'],
                          gambarUrl: item['gambar'],
                          videoUrl: item['video_url'],
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
