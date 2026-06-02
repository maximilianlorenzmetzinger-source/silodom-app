import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../models/media_item.dart';

class VideoFeedItem extends StatefulWidget {
  final SlideItem item;
  final String visibilityKey;

  const VideoFeedItem({
    super.key,
    required this.item,
    required this.visibilityKey,
  });

  @override
  State<VideoFeedItem> createState() => _VideoFeedItemState();
}

class _VideoFeedItemState extends State<VideoFeedItem> {
  VideoPlayerController? _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.item.url),
    );
    await controller.initialize();
    if (!mounted) {
      controller.dispose();
      return;
    }
    controller.setLooping(true);
    setState(() {
      _controller = controller;
      _initialized = true;
    });
  }

  @override
  void dispose() {
    _controller?.pause();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.visibilityKey),
      onVisibilityChanged: (info) {
        if (!mounted || !_initialized || _controller == null) return;
        if (info.visibleFraction > 0.7) {
          _controller!.setVolume(1.0);
          _controller!.play();
        } else {
          _controller!.pause();
          _controller!.setVolume(0.0);
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.black),
          if (_initialized && _controller != null)
            Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white24,
                strokeWidth: 1,
              ),
            ),
        ],
      ),
    );
  }
}