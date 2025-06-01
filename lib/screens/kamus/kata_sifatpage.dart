import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobilebita/screens/kamus/detail_katasifat.dart';

class KataSifatPage extends StatefulWidget {
  final int id;
  final String kata;
  final String? gambarUrl;
  final String? videoUrl;
  final String? deskripsi;

  const KataSifatPage({
    Key? key,
    required this.id,
    required this.kata,
    this.gambarUrl,
    this.videoUrl,
    this.deskripsi,
  }) : super(key: key);

  @override
  State<KataSifatPage> createState() => _KataSifatPageState();
}

class _KataSifatPageState extends State<KataSifatPage> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchKataSifat();
  }

  Future<void> fetchKataSifat() async {
    final response =
        await http.get(Uri.parse('https://bisiktangan.my.id/api/katasifat'));
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      print('Gagal memuat data kata sifat');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color(0xFF2D4A7A),
            padding:
                const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
            child: Row(
              children: const [
                Spacer(),
                Text(
                  "Kata Sifat",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                Spacer(),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return ListTile(
                  title: Text(item['judul'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailKataSifatPage(
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
