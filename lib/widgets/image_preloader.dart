// lib/widgets/image_preloader.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImagePreloader {
  static Future<void> preload(String url, BuildContext context) async {
    final provider = CachedNetworkImageProvider(url);
    await precacheImage(provider, context);
  }

  static void preloadAll(List<String> urls, BuildContext context) {
    for (final url in urls) {
      preload(url, context);
    }
  }
}