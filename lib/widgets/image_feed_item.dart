// lib/widgets/image_feed_item.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/media_item.dart';

class ImageFeedItem extends StatelessWidget {
  final MediaItem item;

  const ImageFeedItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Hintergrund: gestreckt, geblurred, gedunkelt
        CachedNetworkImage(
          imageUrl: item.url,
          fit: BoxFit.cover,
          imageBuilder: (context, imageProvider) => Stack(
            fit: StackFit.expand,
            children: [
              // Gestreckt + gedunkelt
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.55),
                  BlendMode.darken,
                ),
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              // Blur drüber
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(color: Colors.transparent),
              ),
            ],
          ),
          placeholder: (context, url) => Container(color: Colors.black),
          errorWidget: (context, url, error) => Container(color: Colors.black),
        ),

        // Vordergrund: Originalproportionen, volle Breite
        Center(
          child: CachedNetworkImage(
            imageUrl: item.url,
            fit: BoxFit.fitWidth,
            width: double.infinity,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(
                color: Colors.white24,
                strokeWidth: 1,
              ),
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.broken_image_outlined,
              color: Colors.white24,
              size: 48,
            ),
          ),
        ),
      ],
    );
  }
}