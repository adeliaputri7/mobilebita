import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobilebita/screens/kamus/detail_alfabet_page.dart';

class AlfabetScreen extends StatefulWidget {
  @override
  _AlfabetScreenState createState() => _AlfabetScreenState();
}

class _AlfabetScreenState extends State<AlfabetScreen> {
  List<dynamic> alphabetData = [];
  bool loading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchAlphabet();
  }

  Future<void> fetchAlphabet() async {
    try {
      final url = Uri.parse('https://bisiktangan.my.id/api/alphabet');
      print('Mengirim GET request ke: $url');

      final response = await http.get(url);

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        setState(() {
          alphabetData = decodedData is List ? decodedData : [];
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
          errorMessage = 'Gagal mengambil data: ${response.statusCode}';
        });
        print('Response Error: ${response.body}');
      }
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = 'Terjadi kesalahan: $e';
      });
      print('Exception saat request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header (sama seperti sebelumnya)
          Container(
            color: Color(0xFF2D4A7A),
            padding: EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white),
                    Spacer(),
                    Text(
                      "Alfabet",
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
              ],
            ),
          ),

          // Body
          Expanded(
            child: loading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                    ? Center(child: Text(errorMessage))
                    : alphabetData.isEmpty
                        ? Center(child: Text('Tidak ada data tersedia'))
                        : ListView.builder(
                            itemCount: alphabetData.length,
                            itemBuilder: (context, index) {
                              final item = alphabetData[index];
                              return Column(
                                children: [
                                  Divider(height: 1),
                                  ListTile(
                                    title: Text(
                                      item['judul'] ?? 'No title',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    trailing:
                                        Icon(Icons.arrow_forward_ios, size: 16),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DetailAlfabetPage(
                                            huruf: item['judul'] ?? '',
                                            bahasaIsyarat:
                                                item['deskripsi'] ?? '',
                                            gambarUrl: item['gambar'] != null
                                                ? 'https://bisiktangan.my.id/storage/${item['gambar']}'
                                                : null,
                                            videoUrl: item['video_url'] != null
                                                ? 'https://bisiktangan.my.id/storage/${item['video_url']}'
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
