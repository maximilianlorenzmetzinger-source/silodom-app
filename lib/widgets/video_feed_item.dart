// lib/widgets/video_feed_item.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../models/media_item.dart';
import 'video_preloader.dart';

class VideoFeedItem extends StatefulWidget {
  final MediaItem item;
  final VideoPreloader preloader;

  const VideoFeedItem({
    super.key,
    required this.item,
    required this.preloader,
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
    final controller = await widget.preloader.getController(widget.item.url);
    if (mounted) {
      setState(() {
        _controller = controller;
        _initialized = true;
      });
    }
  }

  @override
  void dispose() {
    // Controller NICHT disposen – wird vom Preloader verwaltet
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video-${widget.item.id}'),
      onVisibilityChanged: (info) {
        if (!mounted || !_initialized || _controller == null) return;
        if (info.visibleFraction > 0.7) {
          _controller!.play();
        } else {
          _controller!.pause();
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Hintergrund: gestreckt, geblurred, gedunkelt
          if (_initialized && _controller != null)
            Stack(
              fit: StackFit.expand,
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.55),
                    BlendMode.darken,
                  ),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller!.value.size.width,
                      height: _controller!.value.size.height,
                      child: VideoPlayer(_controller!),
                    ),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(color: Colors.transparent),
                ),
              ],
            )
          else
            Container(color: Colors.black),

          // Vordergrund: Video in Originalproportionen
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