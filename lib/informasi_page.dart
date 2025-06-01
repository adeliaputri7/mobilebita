import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InformasiPage extends StatefulWidget {
  const InformasiPage({super.key});

  @override
  State<InformasiPage> createState() => _InformasiPageState();
}

class _InformasiPageState extends State<InformasiPage> {
  List<dynamic> informasi = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchInformasi();
  }

  Future<void> fetchInformasi() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://bisiktangan.my.id/api/informasi'), // Sesuaikan endpoint
      );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi'),
        backgroundColor: const Color(0xFF2D4A7A),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : informasi.isEmpty
                  ? const Center(child: Text('Tidak ada informasi.'))
                  : ListView.builder(
                      itemCount: informasi.length,
                      itemBuilder: (context, index) {
                        final item = informasi[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            onTap: () => showDetailDialog(item),
                            borderRadius: BorderRadius.circular(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Gambar di atas
                                if (item['gambar'] != null)
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: Image.network(
                                      item['gambar'],
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                else
                                  Container(
                                    height: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(16)),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),

                                // Konten teks
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['judul'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item['caption'],
                                        style: const TextStyle(fontSize: 15),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
