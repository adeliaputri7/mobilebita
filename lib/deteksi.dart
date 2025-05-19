import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class DeteksiPage extends StatefulWidget {
  const DeteksiPage({super.key});

  @override
  State<DeteksiPage> createState() => _DeteksiPageState();
}

class _DeteksiPageState extends State<DeteksiPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isRecording = false;
  String _gestureResult = "Menunggu rekaman video...";

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: true,
      );
      await _cameraController!.initialize();
      setState(() {});
    }
  }

  Future<void> _startVideoRecording() async {
    if (_cameraController == null || _cameraController!.value.isRecordingVideo)
      return;

    try {
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
        _gestureResult = "Merekam video...";
      });
    } catch (e) {
      print("Error mulai rekam video: $e");
    }
  }

  Future<void> _stopVideoRecording() async {
    if (_cameraController == null || !_cameraController!.value.isRecordingVideo)
      return;

    try {
      XFile videoFile = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _gestureResult = "Video selesai direkam, mengirim ke server...";
      });

      await _sendVideoToServer(videoFile);
    } catch (e) {
      print("Error stop rekam video: $e");
      setState(() {
        _gestureResult = "Gagal merekam video";
      });
    }
  }

  Future<void> _sendVideoToServer(XFile videoFile) async {
    try {
      final bytes = await videoFile.readAsBytes();
      final base64Video = base64Encode(bytes);

      final response = await http.post(
        Uri.parse('http://10.0.0.2:5000/predict_video'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'video': base64Video}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String result = data['result'] ?? "Tidak terdeteksi";
        setState(() {
          _gestureResult = "Gesture terdeteksi: $result";
        });
      } else {
        setState(() {
          _gestureResult = "Gagal kirim video ke server";
        });
      }
    } catch (e) {
      print("Error kirim video ke server: $e");
      setState(() {
        _gestureResult = "Error kirim video ke server";
      });
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
      appBar: AppBar(
        title: Text("Deteksi Gesture dari Video"),
      ),
      body: Column(
        children: [
          Expanded(
            child: _cameraController != null &&
                    _cameraController!.value.isInitialized
                ? CameraPreview(_cameraController!)
                : Center(child: CircularProgressIndicator()),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.black,
            width: double.infinity,
            child: Text(
              _gestureResult,
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isRecording ? null : _startVideoRecording,
                child: Text("Mulai Rekam Video"),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: _isRecording ? _stopVideoRecording : null,
                child: Text("Stop Rekam Video"),
              ),
            ],
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
