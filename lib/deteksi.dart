import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeteksiPage extends StatefulWidget {
  const DeteksiPage({super.key});
  @override
  DeteksiPageState createState() => DeteksiPageState();
}

class DeteksiPageState extends State<DeteksiPage> {
  CameraController? _controller;
  bool isRecording = false;
  String detectedGestures = "Belum ada gesture";
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    _controller = CameraController(camera, ResolutionPreset.medium);

    await _controller!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> startRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (isRecording) return;

    try {
      await _controller!.startVideoRecording();
      isRecording = true;
      setState(() {
        errorMessage = "";
        detectedGestures = "Merekam gesture...";
      });
    } catch (e) {
      setState(() {
        errorMessage = "Gagal memulai perekaman: $e";
      });
    }
  }

  Future<void> stopRecording() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) return;

    try {
      final XFile videoFile = await _controller!.stopVideoRecording();
      isRecording = false;
      setState(() {
        errorMessage = "";
        detectedGestures = "Mengirim video ke server...";
      });
      await sendVideoToServer(File(videoFile.path));
    } catch (e) {
      setState(() {
        errorMessage = "Gagal menghentikan perekaman: $e";
        isRecording = false;
      });
    }
  }

  Future<void> sendVideoToServer(File videoFile) async {
    final uri = Uri.parse('http://192.168.0.102:5000/detect_gesture');

    try {
      var request = http.MultipartRequest('POST', uri);
      request.files
          .add(await http.MultipartFile.fromPath('video', videoFile.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final json = response.body;
        final gestures = (jsonDecode(json)['gestures'] as List).join("");
        setState(() {
          detectedGestures =
              gestures.isEmpty ? "Tidak ada gesture terdeteksi" : gestures;
          errorMessage = "";
        });
      } else {
        setState(() {
          errorMessage =
              "Server gagal memproses video (Kode ${response.statusCode})";
          detectedGestures = "";
        });
      }
    } on SocketException {
      setState(() {
        errorMessage =
            "Tidak bisa terhubung ke server. Pastikan jaringan stabil dan server menyala.";
        detectedGestures = "";
      });
    } on TimeoutException {
      setState(() {
        errorMessage = "Permintaan ke server melebihi batas waktu.";
        detectedGestures = "";
      });
    } on http.ClientException catch (e) {
      setState(() {
        errorMessage = "Kesalahan klien HTTP: ${e.message}";
        detectedGestures = "";
      });
    } catch (e) {
      setState(() {
        errorMessage = "Terjadi kesalahan tak terduga: $e";
        detectedGestures = "";
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Deteksi Gesture dari Video")),
      body: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: CameraPreview(_controller!),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Hasil deteksi: $detectedGestures",
              style: const TextStyle(fontSize: 20),
            ),
          ),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Error: $errorMessage",
                style: const TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: isRecording ? stopRecording : startRecording,
            child: Text(isRecording ? "Berhenti Merekam" : "Mulai Merekam"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
