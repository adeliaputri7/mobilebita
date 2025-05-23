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
  bool _isSpeaking = false;
  bool _permissionGranted = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initTTS();
    _initPermissions();
  }

  @override
  void dispose() {
    _speech.stop();
    _flutterTts.stop();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _initTTS() async {
    await _flutterTts.setLanguage("id-ID"); // Set bahasa Indonesia
    _flutterTts.setStartHandler(() {
      setState(() => _isSpeaking = true);
    });
    _flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
    });
    _flutterTts.setErrorHandler((msg) {
      setState(() {
        _isSpeaking = false;
        _errorMessage = 'Error TTS: $msg';
      });
    });
  }

  Future<void> _initPermissions() async {
    final status = await Permission.microphone.request();
    setState(() {
      _permissionGranted = status == PermissionStatus.granted;
      if (!_permissionGranted) {
        _errorMessage = 'Izin mikrofon tidak diberikan';
      }
    });
  }

  Future<void> _listen() async {
    if (!_permissionGranted) {
      setState(() => _errorMessage = 'Izin mikrofon diperlukan');
      return;
    }

    if (_isListening) {
      setState(() => _isListening = false);
      await _speech.stop();
      return;
    }

    bool available = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => setState(() => _errorMessage = 'Error: $error'),
    );

    if (available) {
      setState(() {
        _isListening = true;
        _errorMessage = '';
      });

      await _speech.listen(
        onResult: (result) {
          setState(() {
            if (result.finalResult) {
              _text = result.recognizedWords;
              _textController.text = _text;
            }
          });
        },
        localeId: 'id_ID', // Bahasa Indonesia
        listenFor: Duration(seconds: 30),
        cancelOnError: true,
        partialResults: true,
      );
    } else {
      setState(() => _errorMessage = 'Speech recognition tidak tersedia');
    }
  }

  Future<void> _speak() async {
    if (_textController.text.isEmpty) {
      setState(() => _errorMessage = 'Tidak ada teks untuk dibacakan');
      return;
    }

    try {
      await _flutterTts.speak(_textController.text);
      setState(() => _errorMessage = '');
    } catch (e) {
      setState(() => _errorMessage = 'Gagal membacakan teks: $e');
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
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            TextField(
              controller: _textController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Teks',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _textController.clear();
                    setState(() => _text = '');
                  },
                ),
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
                  backgroundColor: _isListening ? Colors.red : Colors.orange,
                ),
                FloatingActionButton(
                  onPressed: _isSpeaking ? null : _speak,
                  tooltip: 'Text to Speech',
                  child: _isSpeaking
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                      : Icon(Icons.volume_up),
                  backgroundColor: _isSpeaking ? Colors.grey : Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
            ),
          ],
        ),
      ),
    );
  }
}
