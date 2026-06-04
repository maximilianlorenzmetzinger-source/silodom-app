// lib/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/media_item.dart';
import 'feed_screen.dart';
import 'menu_screen.dart';
import 'placeholder_screen.dart';

class MainScreen extends StatefulWidget {
  final List<EventItem>? preloadedEvents;

  const MainScreen({super.key, this.preloadedEvents});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MenuPage _currentPage = MenuPage.home;
  bool _menuOpen = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _openMenu() => setState(() => _menuOpen = true);
  void _closeMenu() => setState(() => _menuOpen = false);

  void _selectPage(MenuPage page) {
    setState(() {
      _currentPage = page;
      _menuOpen = false;
    });
  }

  Widget _buildCurrentPage() {
    switch (_currentPage) {
      case MenuPage.home:
        return FeedScreen(
          preloadedEvents: widget.preloadedEvents,
          onMenuOpen: _openMenu,
        );
      case MenuPage.lovePeace:
        return const PlaceholderScreen(title: 'Love & Peace');
      case MenuPage.calendar:
        return const PlaceholderScreen(title: 'Calendar');
      case MenuPage.faq:
        return const PlaceholderScreen(title: 'FAQ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Schmaler Swipe-Bereich links – funktioniert auf allen Seiten
          _buildCurrentPage(),

          if (!_menuOpen)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 24,
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity != null &&
                      details.primaryVelocity! > 200) {
                    _openMenu();
                  }
                },
                behavior: HitTestBehavior.translucent,
              ),
            ),

          if (_menuOpen)
            MenuOverlay(
              currentPage: _currentPage,
              onPageSelected: _selectPage,
              onClose: _closeMenu,
            ),
        ],
      ),
    );
  }
}