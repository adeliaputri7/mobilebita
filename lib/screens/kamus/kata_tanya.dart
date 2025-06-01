import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobilebita/screens/kamus/detail_katatanya.dart';

class KataTanyaScreen extends StatefulWidget {
  @override
  _KataTanyaScreenState createState() => _KataTanyaScreenState();
}

class _KataTanyaScreenState extends State<KataTanyaScreen> {
  List<dynamic> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKataTanya();
  }

  Future<void> fetchKataTanya() async {
    final url = Uri.parse(
        'https://bisiktangan.my.id/api/katatanya'); // Ganti sesuai URL API kamu
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          data = jsonData['data']; // Sesuaikan dengan struktur respons kamu
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kata Tanya"),
        backgroundColor: const Color(0xFF2D4A7A),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data.isEmpty
              ? const Center(child: Text("Data tidak ditemukan"))
              : ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, color: Color(0xFF2D4A7A)),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return ListTile(
                      leading: Image.network(
                        item['gambar'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
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
    );
  }
}
