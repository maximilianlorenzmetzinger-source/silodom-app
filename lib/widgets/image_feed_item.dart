import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/media_item.dart';

class ImageFeedItem extends StatelessWidget {
  final SlideItem item;

  const ImageFeedItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Colors.black),
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