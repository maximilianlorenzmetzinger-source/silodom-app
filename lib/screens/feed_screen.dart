// lib/screens/feed_screen.dart

import 'package:flutter/material.dart';
import '../models/media_item.dart';
import '../services/media_service.dart';
import '../widgets/image_feed_item.dart';
import '../widgets/image_preloader.dart';
import '../widgets/video_feed_item.dart';
import '../widgets/video_preloader.dart';

class FeedScreen extends StatefulWidget {
  final List<EventItem>? preloadedEvents;
  final VoidCallback? onMenuOpen;

  const FeedScreen({
    super.key,
    this.preloadedEvents,
    this.onMenuOpen,
  });

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late PageController _verticalController;
  final VideoPreloader _videoPreloader = VideoPreloader();
  List<EventItem> _events = [];
  bool _loading = true;
  int _currentEventIndex = 0;
  int _currentSlideIndex = 0;
  bool _detailOpen = false;

  final Map<int, PageController> _slideControllers = {};

  PageController _getSlideController(int eventIndex) {
    if (!_slideControllers.containsKey(eventIndex)) {
      _slideControllers[eventIndex] = PageController();
    }
    return _slideControllers[eventIndex]!;
  }

  @override
  void initState() {
    super.initState();
    _verticalController = PageController();
    _loadFeed();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_events.isNotEmpty) {
      _preloadImagesAround(0);
    }
  }

  @override
  void dispose() {
    _verticalController.dispose();
    for (final c in _slideControllers.values) {
      c.dispose();
    }
    _videoPreloader.dispose();
    super.dispose();
  }

  Future<void> _loadFeed() async {
    final events = widget.preloadedEvents ?? await MediaService.fetchFeed();
    if (mounted) {
      setState(() {
        _events = events;
        _loading = false;
      });
      final allImageUrls = events
          .expand((e) => e.slides)
          .where((s) => s.type == MediaType.image)
          .map((s) => s.url)
          .toList();
      ImagePreloader.preloadAll(allImageUrls, context);
      _preloadVideosAround(0);
    }
  }

  void _preloadImagesAround(int eventIndex) {
    for (int i = eventIndex; i <= eventIndex + 1; i++) {
      if (i < _events.length) {
        final urls = _events[i]
            .slides
            .where((s) => s.type == MediaType.image)
            .map((s) => s.url)
            .toList();
        ImagePreloader.preloadAll(urls, context);
      }
    }
  }

  void _preloadVideosAround(int eventIndex) {
    for (int i = eventIndex; i <= eventIndex + 1; i++) {
      if (i < _events.length) {
        for (final slide in _events[i].slides) {
          if (slide.type == MediaType.video) {
            _videoPreloader.preload(slide.url);
          }
        }
      }
    }
  }

  void _openDetail() => setState(() => _detailOpen = true);
  void _closeDetail() => setState(() => _detailOpen = false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _loading
          ? _buildLoadingScreen()
          : _events.isEmpty
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
            child: CircularProgressIndicator(color: Colors.white30, strokeWidth: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text('Keine Inhalte',
          style: TextStyle(color: Colors.white38, letterSpacing: 3)),
    );
  }

  Widget _buildFeed() {
    final screenWidth = MediaQuery.of(context).size.width;
    final currentEvent = _events[_currentEventIndex];
    final slideCount = currentEvent.slides.length;

    return GestureDetector(
      onTapUp: (details) {
        if (_detailOpen) {
          _closeDetail();
        } else {
          if (details.localPosition.dx > screenWidth * 0.7) {
            _openDetail();
          }
        }
      },
      child: Stack(
        children: [
          // Vertikaler Feed
          PageView.builder(
            controller: _verticalController,
            scrollDirection: Axis.vertical,
            physics: _detailOpen
                ? const NeverScrollableScrollPhysics()
                : const PageScrollPhysics(),
            onPageChanged: (i) {
              setState(() {
                _currentEventIndex = i;
                _currentSlideIndex = 0;
              });
              _preloadImagesAround(i);
              _preloadVideosAround(i);
            },
            itemCount: _events.length,
            itemBuilder: (context, eventIndex) {
              final event = _events[eventIndex];
              return PageView.builder(
                controller: _getSlideController(eventIndex),
                scrollDirection: Axis.horizontal,
                physics: _detailOpen
                    ? const NeverScrollableScrollPhysics()
                    : const PageScrollPhysics(),
                onPageChanged: (slideIndex) {
                  if (eventIndex == _currentEventIndex) {
                    setState(() => _currentSlideIndex = slideIndex);
                  }
                },
                itemCount: event.slides.length,
                itemBuilder: (context, slideIndex) {
                  final slide = event.slides[slideIndex];
                  if (slide.type == MediaType.video) {
                    return VideoFeedItem(
                      item: slide,
                      visibilityKey: 'video-$eventIndex-$slideIndex',
                      preloader: _videoPreloader,
                      isFirst: eventIndex == 0 && slideIndex == 0,
                    );
                  } else {
                    return ImageFeedItem(item: slide);
                  }
                },
              );
            },
          ),


          // Schwarze Ebene
          if (_detailOpen)
            AnimatedOpacity(
              opacity: 0.7,
              duration: const Duration(milliseconds: 300),
              child: Container(color: Colors.black),
            ),

          // Beschreibungstext
          if (_detailOpen)
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 300),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 60, 28, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (currentEvent.description != null)
                        Text(
                          currentEvent.description!,
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
                          style: TextStyle(color: Colors.white38, fontSize: 14),
                        ),
                    ],
                  ),
                ),
              ),
            ),

          // Slide-Punkte unten
          if (!_detailOpen && slideCount > 1)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(slideCount, (i) {
                  final isActive = i == _currentSlideIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : Colors.white38,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),

          // Vertikaler Scroll-Indikator
          if (!_detailOpen)
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_events.length, (i) {
                    final isActive = i == _currentEventIndex;
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