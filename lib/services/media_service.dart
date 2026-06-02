// lib/services/media_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/media_item.dart';

class MediaService {
  static const String _configUrl =
      'https://raw.githubusercontent.com/maximilianlorenzmetzinger-source/silodom/refs/heads/main/feed.json';

  static Future<List<EventItem>> fetchFeed() async {
    try {
      final response = await http.get(Uri.parse(_configUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((e) => EventItem.fromJson(e)).toList();
      }
    } catch (e) {
      print('❌ Exception: $e');
    }
    return _demoFeed();
  }

  static List<EventItem> _demoFeed() {
    return [
      const EventItem(
        id: '1',
        eventName: 'SILODOM',
        description: 'Eine unvergessliche Nacht mit den besten Artists der Szene.',
        slides: [
          SlideItem(
            type: MediaType.image,
            url: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=1080',
          ),
          SlideItem(
            type: MediaType.image,
            url: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=1080',
          ),
        ],
      ),
      const EventItem(
        id: '2',
        eventName: 'DARK MATTER',
        description: 'Aftermovie vom letzten Abend.',
        slides: [
          SlideItem(
            type: MediaType.video,
            url: 'https://www.w3schools.com/html/mov_bbb.mp4',
          ),
        ],
      ),
    ];
  }
}