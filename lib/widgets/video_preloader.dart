// lib/widgets/video_preloader.dart

import 'package:video_player/video_player.dart';

class VideoPreloader {
  final Map<String, VideoPlayerController> _controllers = {};

  void inject(String url, VideoPlayerController controller) {
    _controllers[url] = controller;
  }

  Future<VideoPlayerController?> preload(String url) async {
    if (_controllers.containsKey(url)) return _controllers[url];

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    _controllers[url] = controller;

    await controller.initialize();
    controller.setLooping(true);
    controller.setVolume(0.0);
    await controller.seekTo(Duration.zero);

    return controller;
  }

  VideoPlayerController? getIfReady(String url) {
    final c = _controllers[url];
    if (c != null && c.value.isInitialized) return c;
    return null;
  }

  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _controllers.clear();
  }
}