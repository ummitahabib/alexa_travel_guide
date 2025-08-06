import 'package:flutter/material.dart';
import 'package:she_travel/utils/utils.dart';
import 'package:video_player/video_player.dart';

class HeroVideoBackground extends StatefulWidget {
  const HeroVideoBackground({super.key});

  @override
  State<HeroVideoBackground> createState() => _HeroVideoBackgroundState();
}

class _HeroVideoBackgroundState extends State<HeroVideoBackground> {
  late VideoPlayerController _controller;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.asset(
      'assets/AdobeStock_506875945.mov',
    );

    _controller
        .initialize()
        .then((_) {
          if (mounted) {
            setState(() {});
            _controller.setLooping(true);
            _controller.setVolume(0.0);
            _controller.play();
          }
        })
        .catchError((error) {
          if (mounted) {
            setState(() {
              _hasError = true;
              _errorMessage = 'Failed to load video: $error';
            });
          }
          print('Video initialization error: $error');
        });

    _controller.addListener(() {
      if (_controller.value.hasError) {
        if (mounted) {
          setState(() {
            _hasError = true;
            _errorMessage =
                'Video playback error: ${_controller.value.errorDescription}';
          });
        }
        print('Video playback error: ${_controller.value.errorDescription}');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 48),
              const SizedBox(height: 16),
              Text(
                'Video unavailable',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio:
          _controller.value.isInitialized
              ? _controller.value.aspectRatio
              : 16 / 9,
      child:
          _controller.value.isInitialized
              ? FittedBox(
                fit: isDesktop(context) ? BoxFit.fill : BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
              : Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
    );
  }
}
