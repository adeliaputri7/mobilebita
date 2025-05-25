import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DetailKataTanyaPage extends StatefulWidget {
  final String kata;
  final String? gambarUrl;
  final String? videoUrl;
  final String? deskripsi;

  const DetailKataTanyaPage({
    Key? key,
    required this.kata,
    this.gambarUrl,
    this.videoUrl,
    this.deskripsi,
  }) : super(key: key);

  @override
  _DetailKataTanyaPageState createState() => _DetailKataTanyaPageState();
}

class _DetailKataTanyaPageState extends State<DetailKataTanyaPage> {
  late VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) {
      _videoController = VideoPlayerController.network(widget.videoUrl!)
        ..initialize().then((_) {
          setState(() {});
        });
    } else {
      _videoController = null;
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _replayVideo() {
    if (_videoController != null) {
      _videoController!.seekTo(Duration.zero);
      _videoController!.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                  onPressed: _replayVideo,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(widget.kata,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (widget.gambarUrl != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Image.network(widget.gambarUrl!,
                  height: 180, fit: BoxFit.contain),
            ),
          const SizedBox(height: 20),
          if (_videoController != null && _videoController!.value.isInitialized)
            AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            )
          else if (widget.videoUrl != null)
            const Text("Memuat video..."),
          const SizedBox(height: 16),
          const Text("Bahasa Isyarat Indonesia (BISINDO)",
              style: TextStyle(fontSize: 16)),
        ],
      ),
      floatingActionButton: _videoController != null
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _videoController!.value.isPlaying
                      ? _videoController!.pause()
                      : _videoController!.play();
                });
              },
              child: Icon(
                _videoController!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
