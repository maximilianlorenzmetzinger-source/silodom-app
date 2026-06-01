# 🎧 Silodom App

Techno Club Feed App – vertikaler Medien-Feed wie Instagram Reels.

---

## 📁 Projektstruktur

```
silodom/
├── lib/
│   ├── main.dart                  ← App-Einstiegspunkt
│   ├── models/
│   │   └── media_item.dart        ← Datenmodell (Foto/Video)
│   ├── services/
│   │   └── media_service.dart     ← JSON laden & Demo-Daten
│   ├── screens/
│   │   └── feed_screen.dart       ← Haupt-Feed (Reels-Scroll)
│   └── widgets/
│       ├── image_feed_item.dart   ← Foto-Anzeige
│       └── video_feed_item.dart   ← Video-Anzeige (Autoplay)
├── assets/
│   └── feed.json                  ← Vorlage für JSON-Feed
└── pubspec.yaml
```

---

## 🚀 Setup

### 1. Flutter installieren
https://docs.flutter.dev/get-started/install

### 2. Abhängigkeiten installieren
```bash
cd silodom
flutter pub get
```

### 3. App starten
```bash
# iOS Simulator
flutter run -d ios

# Android Emulator
flutter run -d android
```

---

## 🔄 Inhalte wechseln (wöchentlich)

### Option A: Eigener Server / GitHub
1. Lade deine Fotos/Videos auf deinen Server hoch
2. Bearbeite deine `feed.json` Datei:

```json
[
  {
    "id": "1",
    "type": "image",
    "url": "https://dein-server.de/bild.jpg",
    "event_name": "EVENT NAME",
    "caption": "Kurze Beschreibung",
    "date": "21.06.2025"
  },
  {
    "id": "2",
    "type": "video",
    "url": "https://dein-server.de/video.mp4",
    "event_name": "AFTERMOVIE",
    "caption": "Rückblick letzter Abend",
    "date": "14.06.2025"
  }
]
```

3. Lade die JSON-Datei auf deinen Server hoch
4. Trage die URL in `lib/services/media_service.dart` ein:
```dart
static const String _configUrl = 'https://dein-server.de/feed.json';
```

### Option B: GitHub (kostenlos)
1. Erstelle ein GitHub Repository
2. Lade `feed.json` dort hoch
3. Nutze den "Raw"-Link als `_configUrl`

---

## 📱 Funktionen

- ✅ Vertikales Snapping (wie Reels)
- ✅ Fotos (mit Caching)
- ✅ Videos (Autoplay beim Scrollen, Loop)
- ✅ Ton-Button bei Videos (Mute/Unmute)
- ✅ Event-Name, Caption, Datum als Overlay
- ✅ Vollbild-Modus
- ✅ Scroll-Indikator rechts
- ✅ Dunkles Techno-Design

---

## 🛠 iOS Konfiguration

In `ios/Runner/Info.plist` sicherstellen dass vorhanden:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## 🛠 Android Konfiguration

In `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```
Und im `<application>` Tag:
```xml
android:usesCleartextTraffic="true"
```

---

## 📦 Dependencies

| Paket | Verwendung |
|-------|-----------|
| `video_player` | Video-Wiedergabe |
| `cached_network_image` | Bilder mit Cache |
| `http` | JSON von Server laden |
| `visibility_detector` | Autoplay beim Scrollen |
