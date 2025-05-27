import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobilebita/screens/kamus/detail_katatanya.dart';

class KataTanyaPage extends StatefulWidget {
  @override
  _KataTanyaPageState createState() => _KataTanyaPageState();
}

class _KataTanyaPageState extends State<KataTanyaPage> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchKataTanya();
  }

  Future<void> fetchKataTanya() async {
    final response =
        await http.get(Uri.parse('http://10.10.180.39:8000/api/katatanya'));
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      print('Gagal memuat data kata tanya');
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
                  "Kata Tanya",
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
                        builder: (_) => DetailKataTanyaPage(
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
