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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/AdobeStock_506875945.mov')
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.setVolume(0); // Mute
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio:
          _controller.value.isInitialized
              ? _controller.value.aspectRatio
              : 16 / 9, // fallback aspect ratio
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
              : Container(color: Colors.black),
    );
  }
}
