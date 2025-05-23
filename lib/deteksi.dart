import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class DeteksiPage extends StatefulWidget {
  const DeteksiPage({super.key});

  @override
  DeteksiPageState createState() => DeteksiPageState();
}

class DeteksiPageState extends State<DeteksiPage> {
  late Interpreter _interpreter;
  late List<String> _labels;
  String _prediction = "Belum ada prediksi";

  @override
  void initState() {
    super.initState();
    _loadModelAndLabels();
  }

  Future<void> _loadModelAndLabels() async {
    // Load model dari asset
    final modelData = await rootBundle.load('assets/gesture_model.tflite');
    final modelBytes = modelData.buffer.asUint8List();
    _interpreter = await Interpreter.fromBuffer(modelBytes);

    // Load labels dari JSON asset
    final labelData = await rootBundle.loadString('assets/gesture_labels.json');
    _labels = List<String>.from(json.decode(labelData));

    setState(() {});
  }

  Future<void> _runInference() async {
    // Simulasi input gesture: list 126 float (ganti dengan data nyata)
    List<double> inputData = List.filled(126, 0);

    // Contoh modifikasi supaya hasil beda-beda (dummy)
    inputData[0] = 0.5;

    var input = [inputData];
    var output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);

    _interpreter.run(input, output);

    final predictionScores = output[0];
    int maxIdx = 0;
    double maxScore = predictionScores[0];
    for (int i = 1; i < predictionScores.length; i++) {
      if (predictionScores[i] > maxScore) {
        maxIdx = i;
        maxScore = predictionScores[i];
      }
    }

    setState(() {
      _prediction =
          "Prediksi gesture: ${_labels[maxIdx]} (confidence: ${maxScore.toStringAsFixed(3)})";
    });
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gesture Detection Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _interpreter != null ? _runInference : null,
              child: Text('Detect Gesture'),
            ),
            SizedBox(height: 30),
            Text(
              _prediction,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
