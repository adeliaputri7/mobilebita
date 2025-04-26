import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class DeteksiPage extends StatefulWidget {
  const DeteksiPage({super.key});

  @override
  State<DeteksiPage> createState() => _DeteksiPageState();
}

class _DeteksiPageState extends State<DeteksiPage> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  bool isCameraInitialized = false;
  bool isRecording = false;
  late String videoPath;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  // Inisialisasi kamera
  Future<void> initializeCamera() async {
    _cameras = await availableCameras();

    // Pilih kamera depan (lensDirection.front)
    CameraDescription? frontCamera;
    for (var camera in _cameras) {
      if (camera.lensDirection == CameraLensDirection.front) {
        frontCamera = camera;
        break;
      }
    }

    if (frontCamera != null) {
      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
      );

      await _controller.initialize();
      setState(() {
        isCameraInitialized = true;
      });
    } else {
      // Jika tidak ada kamera depan ditemukan, tampilkan error atau pilih kamera belakang
      print("Kamera depan tidak ditemukan.");
    }
  }

  // Mulai merekam video
  Future<void> startRecording() async {
    if (!_controller.value.isInitialized || isRecording) {
      return;
    }

    try {
      await _controller.startVideoRecording();
      setState(() {
        isRecording = true;
      });
    } catch (e) {
      print('Error saat mulai merekam: $e');
    }
  }

  // Menghentikan rekaman video
  Future<void> stopRecording() async {
    if (!_controller.value.isInitialized || !isRecording) {
      return;
    }

    try {
      XFile videoFile = await _controller.stopVideoRecording();
      setState(() {
        isRecording = false;
        videoPath = videoFile.path;
      });

      print('Video disimpan di: $videoPath');
    } catch (e) {
      print('Error saat menghentikan rekaman: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Gesture Match'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 20,
            color: Colors.transparent, // Jarak kecil setelah AppBar
          ),
          Container(
            height: 20,
            color: Colors.blue, // Garis biru atas
          ),
          isCameraInitialized
              ? Expanded(
                  flex: 3,
                  child: CameraPreview(_controller),
                )
              : const Center(child: CircularProgressIndicator()),
          Container(
            height: 20,
            color: Colors.blue, // Garis biru bawah
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.transparent, // Bawah kosong
            ),
          ),
          // Tombol untuk merekam
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: isRecording ? stopRecording : startRecording,
              child: Text(isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
