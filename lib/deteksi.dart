import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class DeteksiPage extends StatefulWidget {
  const DeteksiPage({super.key});

  @override
  State<DeteksiPage> createState() => _DeteksiPageState();
}

class _DeteksiPageState extends State<DeteksiPage> {
  File? _image;
  String _result = "";

  Future<void> _pickAndDetect() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      String base64Image = base64Encode(bytes);

      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:5000/predict'), // ganti IP jika perlu
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'image': base64Image}),
        );

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          setState(() {
            _image = File(picked.path);
            _result = json['result'];
          });
        } else {
          setState(() {
            _result = "Gagal mendeteksi gesture. Kode: ${response.statusCode}";
          });
        }
      } catch (e) {
        setState(() {
          _result = "Terjadi kesalahan: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Deteksi Bahasa Isyarat")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _image != null
                ? Image.file(_image!, width: 200)
                : Placeholder(fallbackHeight: 200),
            const SizedBox(height: 16),
            Text(_result, style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickAndDetect,
              child: Text("Ambil & Deteksi Gambar"),
            ),
          ],
        ),
      ),
    );
  }
}
