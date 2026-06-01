// lib/widgets/video_preloader.dart

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Hält alle VideoPlayerController zentral vor –
/// so wird das nächste Video schon geladen bevor man dazu scrollt.
class VideoPreloader extends ChangeNotifier {
  final Map<String, VideoPlayerController> _controllers = {};
  final Map<String, bool> _initialized = {};

  Future<VideoPlayerController> getController(String url) async {
    if (_controllers.containsKey(url)) {
      return _controllers[url]!;
    }

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controllers[url] = controller;
    _initialized[url] = false;

    await controller.initialize();
    controller.setLooping(true);
    _initialized[url] = true;
    notifyListeners();

    return controller;
  }

  bool isInitialized(String url) => _initialized[url] ?? false;

  void preload(String url) {
    if (!_controllers.containsKey(url)) {
      getController(url);
    }
  }

  void disposeUrl(String url) {
    _controllers[url]?.dispose();
    _controllers.remove(url);
    _initialized.remove(url);
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }
}