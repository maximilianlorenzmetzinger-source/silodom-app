// lib/models/media_item.dart

enum MediaType { image, video }

class SlideItem {
  final MediaType type;
  final String url;

  const SlideItem({required this.type, required this.url});

  factory SlideItem.fromJson(Map<String, dynamic> json) {
    return SlideItem(
      type: (json['type'] as String) == 'video' ? MediaType.video : MediaType.image,
      url: json['url'] as String,
    );
  }
}

class EventItem {
  final String id;
  final String? eventName;
  final String? description;
  final List<SlideItem> slides;

  const EventItem({
    required this.id,
    required this.slides,
    this.eventName,
    this.description,
  });

  factory EventItem.fromJson(Map<String, dynamic> json) {
    final slideList = (json['slides'] as List<dynamic>)
        .map((s) => SlideItem.fromJson(s))
        .toList();
    return EventItem(
      id: json['id'] as String,
      eventName: json['event_name'] as String?,
      description: json['description'] as String?,
      slides: slideList,
    );
  }
}