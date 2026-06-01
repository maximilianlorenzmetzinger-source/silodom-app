// lib/services/media_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/media_item.dart';

class MediaService {
  static const String _configUrl =
      'https://raw.githubusercontent.com/maximilianlorenzmetzinger-source/silodom/refs/heads/main/feed.json';

  static Future<List<MediaItem>> fetchFeed() async {
    try {
      print('🔍 Lade Feed von: $_configUrl');
      final response = await http.get(Uri.parse(_configUrl));
      print('📡 Status Code: ${response.statusCode}');
      print('📄 Antwort: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('✅ ${jsonList.length} Einträge geladen');
        return jsonList.map((e) => MediaItem.fromJson(e)).toList();
      } else {
        print('❌ Fehler: Status ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception: $e');
    }
    print('⚠️ Fallback auf Demo-Daten');
    return _demoFeed();
  }

  static List<MediaItem> _demoFeed() {
    return [
      const MediaItem(
        id: '1',
        type: MediaType.image,
        url: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=1080',
        eventName: 'SILODOM',
        caption: 'Nächste Veranstaltung – Samstag 23:00',
        date: '15.06.2025',
      ),
      const MediaItem(
        id: '2',
        type: MediaType.video,
        url: 'https://www.w3schools.com/html/mov_bbb.mp4',
        eventName: 'DARK MATTER',
        caption: 'Aftermovie – letzter Abend',
        date: '08.06.2025',
      ),
      const MediaItem(
        id: '3',
        type: MediaType.image,
        url: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=1080',
        eventName: 'SILODOM',
        caption: 'Die Nacht gehört euch',
        date: '01.06.2025',
      ),
      const MediaItem(
        id: '4',
        type: MediaType.image,
        url: 'https://images.unsplash.com/photo-1549213783-8284d0336c4f?w=1080',
        eventName: 'BASS KONSTRUKT',
        caption: 'Underground – Raum 2',
        date: '25.05.2025',
      ),
    ];
  }
}