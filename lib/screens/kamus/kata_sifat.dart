import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_katasifat.dart';

class KataSifatScreen extends StatefulWidget {
  @override
  _KataSifatScreenState createState() => _KataSifatScreenState();
}

class _KataSifatScreenState extends State<KataSifatScreen> {
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
          // Header
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
                    fontSize: 22,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          // List data dari API
          Expanded(
            child: ListView.separated(
              itemCount: data.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: Color(0xFF2D4A7A)),
              itemBuilder: (context, index) {
                final item = data[index];
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
