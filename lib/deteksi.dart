import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class DeteksiPage extends StatefulWidget {
  const DeteksiPage({super.key});

  @override
  State<DeteksiPage> createState() => _DeteksiPageState();
}

class _DeteksiPageState extends State<DeteksiPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  String _currentOutput = "Menunggu deteksi gesture...";
  bool _isDetecting = false;

  // Tambahan variabel state untuk deteksi kalimat
  String _detectedLetter = '';
  String _currentWord = '';
  String _currentSentence = '';
  DateTime _lastDetected = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController =
          CameraController(_cameras![0], ResolutionPreset.medium);
      await _cameraController!.initialize();

      // Set listener untuk setiap frame kamera
      _cameraController!.startImageStream((CameraImage image) {
        if (!_isDetecting) {
          _isDetecting = true;
          _processCameraImage(image);
        }
      });

      setState(() {});
    }
  }

  // Fungsi convert YUV420 ke JPEG (tetap pakai yang kamu punya)
  Uint8List _convertYUV420ToJpeg(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final img.Image imgBuffer = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex = (x ~/ 2) + (y ~/ 2) * (width ~/ 2);
        final int yp = image.planes[0].bytes[y * width + x];
        final int up = image.planes[1].bytes[uvIndex];
        final int vp = image.planes[2].bytes[uvIndex];

        int r = (yp + 1.370705 * (vp - 128)).round();
        int g = (yp - 0.337633 * (up - 128) - 0.698001 * (vp - 128)).round();
        int b = (yp + 1.732446 * (up - 128)).round();

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        imgBuffer.setPixelRgba(x, y, r, g, b, 255);
      }
    }
    return Uint8List.fromList(img.encodeJpg(imgBuffer));
  }

  Future<void> _processCameraImage(CameraImage image) async {
    try {
      final jpeg = _convertYUV420ToJpeg(image);

      final response = await http
          .post(
            Uri.parse('http://192.168.1.2:5000/detect_gesture'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'image': base64Encode(jpeg)}),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String gesture = data['gesture'] ?? 'no_hand';
        int handsDetected = data['hands_detected'] ?? 0;

        if (handsDetected > 0 && gesture.isNotEmpty && gesture != "no_hand") {
          final now = DateTime.now();
          if (now.difference(_lastDetected) > Duration(seconds: 1)) {
            // Update huruf, kata, kalimat sesuai gesture
            setState(() {
              _detectedLetter = gesture;

              if (gesture == "space") {
                _currentSentence += ' ';
                _currentWord = '';
              } else if (gesture == "clear") {
                _currentSentence = '';
                _currentWord = '';
              } else {
                _currentWord += gesture;
                _currentSentence += gesture;
              }

              _lastDetected = now;
            });
          }
        } else {
          // Jika no_hand, bisa update status atau kosongkan huruf sekarang
          setState(() {
            _detectedLetter = '';
          });
        }

        setState(() {
          _currentOutput =
              "Kalimat: $_currentSentence\nKata saat ini: $_currentWord\nHuruf: $_detectedLetter\nTangan terdeteksi: $handsDetected";
        });
      } else {
        setState(() {
          _currentOutput = "Error: Server respons ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _currentOutput = "Error saat request: $e";
      });
    } finally {
      await Future.delayed(const Duration(milliseconds: 300));
      _isDetecting = false;
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 40,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF1A2B5C),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: _cameraController != null &&
                        _cameraController!.value.isInitialized
                    ? CameraPreview(_cameraController!)
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF1A2B5C),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Text(
                _currentOutput,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
