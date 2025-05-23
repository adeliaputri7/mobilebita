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

  @override
  void initState() {
    super.initState();
    fetchAlphabet();
  }

  Future<void> fetchAlphabet() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.10.183.50:8000/api/alphabet'));
      if (response.statusCode == 200) {
        setState(() {
          alphabets = jsonDecode(
              response.body); // Sesuaikan jika response pakai key data
          loading = false;
        });
      } else {
        // Handle error
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      // Handle error
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text('Daftar Alfabet')),
      body: ListView.builder(
        itemCount: alphabets.length,
        itemBuilder: (context, index) {
          final item = alphabets[index];
          return ListTile(
            title: Text(item['judul'] ?? 'No Title'),
            subtitle: Text(item['deskripsi'] ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailAlfabetPage(
                    huruf: item['judul'] ?? '',
                    bahasaIsyarat: item['deskripsi'] ?? '',
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
