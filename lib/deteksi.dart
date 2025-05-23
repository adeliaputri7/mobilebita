import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DeteksiPage extends StatefulWidget {
  const DeteksiPage({super.key});
  @override
  DeteksiPageState createState() => DeteksiPageState();
}

class DeteksiPageState extends State<DeteksiPage> {
  CameraController? _controller;
  bool isRecording = false;
  String detectedGestures = "Belum ada gesture";

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
      setState(() {});
    } catch (e) {
      print("Error starting recording: $e");
    }
  }

  Future<void> stopRecording() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) return;

    try {
      XFile videoFile = await _controller!.stopVideoRecording();
      isRecording = false;
      setState(() {});
      await sendVideoToServer(File(videoFile.path));
    } catch (e) {
      print("Error stopping recording: $e");
    }
  }

  Future<void> sendVideoToServer(File videoFile) async {
    final uri = Uri.parse('http://192.168.1.2:5000/detect_gesture');

    var request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('video', videoFile.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final json = response.body;
      print("Response from server: $json");
      final gestures = (jsonDecode(json)['gestures'] as List).join(", ");
      setState(() {
        detectedGestures =
            gestures.isEmpty ? "Tidak ada gesture terdeteksi" : gestures;
      });
    } else {
      print("Failed to detect gesture: ${response.body}");
      setState(() {
        detectedGestures = "Error mendeteksi gesture: ${response.body}";
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
      appBar: AppBar(title: const Text("Deteksi Gesture Video")),
      body: Column(
        children: [
          Expanded(
            // <-- Ini bikin CameraPreview expand maksimal ruang yg tersedia
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: CameraPreview(_controller!),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("Gesture terdeteksi: $detectedGestures",
                style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 20),
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
