import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DetailAlfabetPage extends StatefulWidget {
  final String huruf;
  final String bahasaIsyarat;
  final String? gambarUrl;
  final String? videoUrl;

  const DetailAlfabetPage({
    Key? key,
    required this.huruf,
    required this.bahasaIsyarat,
    this.gambarUrl,
    this.videoUrl,
  }) : super(key: key);

  @override
  State<DetailAlfabetPage> createState() => _DetailAlfabetPageState();
}

class _DetailAlfabetPageState extends State<DetailAlfabetPage> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _hasVideoError = false;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) {
      _initializeVideo();
    }
  }

  void _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl!),
      );

      await _videoController!.initialize();

      setState(() {
        _isVideoInitialized = true;
      });
    } catch (e) {
      setState(() {
        _hasVideoError = true;
      });
      print('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Huruf'),
        backgroundColor: Color(0xFF2D4A7A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Card Huruf
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  widget.huruf,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Deskripsi
            Text(
              widget.bahasaIsyarat,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Tampilkan gambar jika ada
            if (widget.gambarUrl != null && widget.gambarUrl!.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.gambarUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported,
                                size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              "Gambar tidak tersedia",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Tampilkan video jika ada
            if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) ...[
              Text(
                'Video bahasa isyarat:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              if (_hasVideoError)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.videocam_off, size: 50, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        "Video tidak dapat dimuat",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _hasVideoError = false;
                            _isVideoInitialized = false;
                          });
                          _initializeVideo();
                        },
                        child: Text("Coba Lagi"),
                      ),
                    ],
                  ),
                )
              else if (!_isVideoInitialized)
                Container(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        VideoPlayer(_videoController!),
                        Positioned.fill(
                          child: Center(
                            child: IconButton(
                              iconSize: 64,
                              icon: Icon(
                                _videoController!.value.isPlaying
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_filled,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              onPressed: () {
                                setState(() {
                                  _videoController!.value.isPlaying
                                      ? _videoController!.pause()
                                      : _videoController!.play();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
