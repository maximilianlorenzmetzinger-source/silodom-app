// lib/models/media_item.dart

enum MediaType { image, video }

class MediaItem {
  final String id;
  final MediaType type;
  final String url;
  final String? caption;
  final String? eventName;
  final String? date;
  final String? description;  // NEU

  const MediaItem({
    required this.id,
    required this.type,
    required this.url,
    this.caption,
    this.eventName,
    this.date,
    this.description,  // NEU
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'] as String,
      type: (json['type'] as String) == 'video' ? MediaType.video : MediaType.image,
      url: json['url'] as String,
      caption: json['caption'] as String?,
      eventName: json['event_name'] as String?,
      date: json['date'] as String?,
      description: json['description'] as String?,  // NEU
    );
  }
}