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
        Uri.parse('http://192.168.1.202:8000/api/informasi'), // Sesuaikan endpoint
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
                              horizontal: 12, vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: item['gambar'] != null
                                ? Image.network(
                                    item['gambar'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            title: Text(
                              item['judul'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(item['caption']),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () => showDetailDialog(item),
                          ),
                        );
                      },
                    ),
    );
  }
}
