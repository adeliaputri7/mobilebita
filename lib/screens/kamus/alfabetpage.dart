import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobilebita/screens/kamus/detail_alfabet_page.dart';
import 'dart:convert';

class AlfabetPage extends StatefulWidget {
  const AlfabetPage({Key? key}) : super(key: key);

  @override
  _AlfabetPageState createState() => _AlfabetPageState();
}

class _AlfabetPageState extends State<AlfabetPage> {
  List<dynamic> alphabets = [];
  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchAlphabet();
  }

Future<void> fetchAlphabet() async {
    try {
      final response = await http.get(
        Uri.parse('https://bisiktangan.my.id/api/alphabet'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);

        setState(() {
          // Jika response menggunakan wrapper dengan key 'data'
          if (decodedResponse is Map && decodedResponse.containsKey('data')) {
            alphabets = decodedResponse['data'];
          } else {
            alphabets = decodedResponse;
          }
          loading = false;
          errorMessage = null;
        });

        // Debug: Print untuk melihat struktur data
        print('Response data: $decodedResponse');
        if (alphabets.isNotEmpty) {
          print('First item structure: ${alphabets[0]}');
        }
      } else {
        setState(() {
          loading = false;
          errorMessage = 'Failed to load data. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = 'Error: $e';
      });
      print('Error fetching alphabet: $e');
    }
  }


  // Fungsi untuk refresh data
  Future<void> _refreshData() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });
    await fetchAlphabet();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Daftar Alfabet'),
          backgroundColor: Color(0xFF2D4A7A),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Memuat data alfabet...'),
            ],
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Daftar Alfabet'),
          backgroundColor: Color(0xFF2D4A7A),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _refreshData,
                child: Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (alphabets.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Daftar Alfabet'),
          backgroundColor: Color(0xFF2D4A7A),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Tidak ada data alfabet'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _refreshData,
                child: Text('Refresh'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Alfabet'),
        backgroundColor: Color(0xFF2D4A7A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: alphabets.length,
          itemBuilder: (context, index) {
            final item = alphabets[index];

            // Debugging: Print item structure
            print('Item $index: $item');

            return Card(
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                // Tambahkan leading image jika ada
                leading: item['gambar'] != null &&
                        item['gambar'].toString().isNotEmpty
                    ? Container(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item['gambar'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(Icons.image_not_supported,
                                    color: Colors.grey),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D4A7A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            (item['judul'] ?? 'A')
                                .toString()
                                .substring(0, 1)
                                .toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),

                title: Text(
                  item['judul'] ?? 'No Title',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item['deskripsi'] != null &&
                        item['deskripsi'].toString().isNotEmpty)
                      Text(item['deskripsi']),

                    // Indikator jika ada video
                    if (item['video_url'] != null &&
                        item['video_url'].toString().isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(Icons.play_circle_outline,
                                size: 16, color: Colors.blue),
                            SizedBox(width: 4),
                            Text(
                              'Video tersedia',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                trailing: Icon(Icons.arrow_forward_ios, size: 16),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailAlfabetPage(
                        huruf: item['judul'] ?? '',
                        bahasaIsyarat: item['deskripsi'] ?? '',
                        gambarUrl: item['gambar']?.toString().isEmpty == true
                            ? null
                            : item['gambar']?.toString(),
                        videoUrl: item['video_url']?.toString().isEmpty == true
                            ? null
                            : item['video_url']?.toString(),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
