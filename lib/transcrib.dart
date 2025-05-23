import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MaterialApp(
    home: SpeechTextApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class SpeechTextApp extends StatefulWidget {
  @override
  _SpeechTextAppState createState() => _SpeechTextAppState();
}

class _SpeechTextAppState extends State<SpeechTextApp> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Tekan mikrofon untuk mulai bicara...';
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initPermissions();
  }

  Future<void> _initPermissions() async {
    await Permission.microphone.request();
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
              _textController.text = _text;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _speak() async {
    if (_textController.text.isNotEmpty) {
      await _flutterTts.speak(_textController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech ⇄ Text'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Teks',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: _listen,
                  tooltip: 'Speech to Text',
                  child: Icon(_isListening ? Icons.mic_off : Icons.mic),
                  backgroundColor: Colors.orange,
                ),
                FloatingActionButton(
                  onPressed: _speak,
                  tooltip: 'Text to Speech',
                  child: Icon(Icons.volume_up),
                  backgroundColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Output Suara:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _text,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
