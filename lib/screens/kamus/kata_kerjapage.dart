import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class KataKerjaPage extends StatefulWidget {
  final int id;
  final String kata;
  final String? gambarUrl;
  final String? videoUrl;
  final String? deskripsi;

  const KataKerjaPage({
    Key? key,
    required this.id,
    required this.kata,
    this.gambarUrl,
    this.videoUrl, 
    this.deskripsi,
  }) : super(key: key);

  @override
  State<KataKerjaPage> createState() => _KataKerjaPageState();
}

class _KataKerjaPageState extends State<KataKerjaPage> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl != null) {
      _controller = VideoPlayerController.network(widget.videoUrl!)
        ..initialize().then((_) {
          setState(() {});
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
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            color: const Color(0xFF2D4A7A),
            padding:
                const EdgeInsets.only(top: 50, left: 8, right: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                  icon: const Icon(Icons.replay, color: Colors.white),
                  onPressed: () {
                    if (_controller != null) {
                      _controller!.seekTo(Duration.zero);
                      _controller!.play();
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Gambar
          if (widget.gambarUrl != null)
            Image.network(
              widget.gambarUrl!,
              height: 200,
              fit: BoxFit.contain,
            ),

          const SizedBox(height: 20),

          // Kotak kata
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  widget.kata,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Text("Bisindo", style: TextStyle(fontSize: 16)),

          const SizedBox(height: 20),

          // Video
          if (_controller != null && _controller!.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
        ],
      ),
    );
  }
}
