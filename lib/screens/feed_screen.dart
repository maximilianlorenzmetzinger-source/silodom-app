// lib/screens/feed_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/media_item.dart';
import '../services/media_service.dart';
import '../widgets/image_feed_item.dart';
import '../widgets/video_feed_item.dart';
import '../widgets/video_preloader.dart';


class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late PageController _pageController;
  final VideoPreloader _preloader = VideoPreloader();
  List<MediaItem> _items = [];
  bool _loading = true;
  int _currentIndex = 0;
  double _dragOffset = 0.0;
  bool _detailOpen = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadFeed();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _preloader.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _loadFeed() async {
    final items = await MediaService.fetchFeed();
    if (mounted) {
      setState(() {
        _items = items;
        _loading = false;
      });
      _preloadAround(0);
    }
  }

  /// Lädt das aktuelle + nächste Video vor
  void _preloadAround(int index) {
    for (int i = index; i <= index + 1; i++) {
      if (i < _items.length && _items[i].type == MediaType.video) {
        _preloader.preload(_items[i].url);
      }
    }
  }

  void _openDetail() => setState(() => _detailOpen = true);

  void _closeDetail() => setState(() {
        _detailOpen = false;
        _dragOffset = 0.0;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _loading
          ? _buildLoadingScreen()
          : _items.isEmpty
              ? _buildEmptyState()
              : _buildFeed(),
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'SILODOM',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 10,
            ),
          ),
          SizedBox(height: 32),
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.white30,
              strokeWidth: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'Keine Inhalte',
        style: TextStyle(color: Colors.white38, letterSpacing: 3),
      ),
    );
  }

  Widget _buildFeed() {
    final screenWidth = MediaQuery.of(context).size.width;
    final dragProgress = (_detailOpen
            ? 1.0
            : (_dragOffset < 0
                ? (-_dragOffset / screenWidth).clamp(0.0, 1.0)
                : 0.0))
        .toDouble();

    final currentItem = _items[_currentIndex];

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (_detailOpen) {
          if (details.delta.dx > 0) {
            setState(() => _dragOffset = details.delta.dx);
          }
        } else {
          if (details.delta.dx < 0) {
            setState(() => _dragOffset += details.delta.dx);
          }
        }
      },
      onHorizontalDragEnd: (details) {
        if (_detailOpen) {
          if (details.primaryVelocity! > 300) {
            _closeDetail();
          } else {
            setState(() => _dragOffset = 0.0);
          }
        } else {
          if (details.primaryVelocity! < -300 ||
              -_dragOffset > screenWidth * 0.3) {
            _openDetail();
            _dragOffset = 0.0;
          } else {
            setState(() => _dragOffset = 0.0);
          }
        }
      },
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: _detailOpen
                ? const NeverScrollableScrollPhysics()
                : const PageScrollPhysics(),
            onPageChanged: (i) {
              setState(() => _currentIndex = i);
              _preloadAround(i);
            },
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              if (item.type == MediaType.video) {
                return VideoFeedItem(item: item, preloader: _preloader);
              } else {
                return ImageFeedItem(item: item);
              }
            },
          ),

          // Schwarze Ebene
          if (dragProgress > 0)
            Opacity(
              opacity: (dragProgress * 0.7).clamp(0.0, 0.7),
              child: Container(color: Colors.black),
            ),

          // Beschreibungstext
          if (dragProgress > 0.5)
            Opacity(
              opacity: ((dragProgress - 0.5) * 2).clamp(0.0, 1.0),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 60, 28, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (currentItem.description != null)
                        Text(
                          currentItem.description!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.8,
                            letterSpacing: 0.4,
                          ),
                        )
                      else
                        const Text(
                          'Keine Beschreibung vorhanden.',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 14,
                            letterSpacing: 1,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

          // Scroll-Indikator
          if (!_detailOpen)
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_items.length, (i) {
                    final isActive = i == _currentIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      width: 2,
                      height: isActive ? 24 : 6,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.white : Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
              ),
            ),
        ],
      ),
    );
  }
}