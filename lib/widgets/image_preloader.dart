// lib/widgets/image_preloader.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImagePreloader {
  /// Lädt ein Bild in den Cache ohne es anzuzeigen
  static Future<void> preload(String url, BuildContext context) async {
    await precacheImage(CachedNetworkImageProvider(url), context);
  }

  static void preloadAll(List<String> urls, BuildContext context) {
    for (final url in urls) {
      preload(url, context);
    }
  }
}