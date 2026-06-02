import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../models/media_item.dart';
import 'video_preloader.dart';

class VideoFeedItem extends StatefulWidget {
  final SlideItem item;
  final String visibilityKey;
  final VideoPreloader preloader;
  final bool isFirst;

  const VideoFeedItem({
    super.key,
    required this.item,
    required this.visibilityKey,
    required this.preloader,
    this.isFirst = false,
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
    // Schon im Preloader? Direkt nehmen
    final existing = widget.preloader.getIfReady(widget.item.url);
    if (existing != null) {
      setState(() {
        _controller = existing;
        _initialized = true;
      });
      return;
    }

    if (widget.isFirst) {
      // Erstes Video: direkt initialisieren und in Preloader injizieren
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.item.url),
      );
      await controller.initialize();
      if (!mounted) {
        controller.dispose();
        return;
      }
      controller.setLooping(true);
      controller.setVolume(1.0);
      controller.play();
      // In Preloader injizieren damit es beim Zurückscrollen sofort da ist
      widget.preloader.inject(widget.item.url, controller);
      setState(() {
        _controller = controller;
        _initialized = true;
      });
    } else {
      final controller = await widget.preloader.preload(widget.item.url);
      if (!mounted || controller == null) return;
      setState(() {
        _controller = controller;
        _initialized = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.pause();
    _controller?.setVolume(0.0);
    // Controller NIE disposen – Preloader verwaltet ihn
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return VisibilityDetector(
      key: Key(widget.visibilityKey),
      onVisibilityChanged: (info) {
        if (!mounted || !_initialized || _controller == null) return;
        if (info.visibleFraction >= 0.5) {
          _controller!.setVolume(1.0);
          _controller!.play();
        } else {
          _controller!.pause();
          _controller!.setVolume(0.0);
          _controller!.seekTo(Duration.zero);
        }
      },
      child: SizedBox(
        width: size.width,
        height: size.height,
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
      ),
    );
  }
}