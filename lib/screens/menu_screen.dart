// lib/screens/menu_screen.dart

import 'package:flutter/material.dart';

enum MenuPage { home, lovePeace, calendar, faq }

class MenuOverlay extends StatefulWidget {
  final MenuPage currentPage;
  final Function(MenuPage) onPageSelected;
  final VoidCallback onClose;

  const MenuOverlay({
    super.key,
    required this.currentPage,
    required this.onPageSelected,
    required this.onClose,
  });

  @override
  State<MenuOverlay> createState() => _MenuOverlayState();
}

class _MenuOverlayState extends State<MenuOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _itemAnimations;
  late Animation<double> _backgroundAnimation;
  late MenuPage _activePage;

  final List<_MenuItem> _items = [
    _MenuItem(page: MenuPage.home, label: 'HOME'),
    _MenuItem(page: MenuPage.lovePeace, label: 'LOVE & PEACE'),
    _MenuItem(page: MenuPage.calendar, label: 'CALENDAR'),
    _MenuItem(page: MenuPage.faq, label: 'FAQ'),
  ];

  @override
  void initState() {
    super.initState();
    _activePage = widget.currentPage;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _itemAnimations = List.generate(_items.length, (i) {
      final start = 0.1 + i * 0.12;
      final end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(-1.5, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    await _controller.reverse();
    widget.onClose();
  }

  Future<void> _selectPage(MenuPage page) async {
    if (page == _activePage) {
      await _close();
      return;
    }

    // Aktiven Zustand sofort im Menü umschalten
    setState(() => _activePage = page);

    // Kurz warten damit Animation sichtbar ist
    await Future.delayed(const Duration(milliseconds: 400));

    // Menü zuklappen
    await _controller.reverse();
    widget.onPageSelected(page);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        if (details.localPosition.dx > MediaQuery.of(context).size.width * 0.75) {
          _close();
        }
      },
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! < -300) {
          _close();
        }
      },
      child: Stack(
        children: [
          // Dunkler Hintergrund rechts
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) => Container(
              color: Colors.black.withOpacity(_backgroundAnimation.value * 0.5),
            ),
          ),

          // Menü Panel links
          FractionallySizedBox(
            widthFactor: 0.75,
            child: Container(
              color: Colors.black,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(36, 80, 24, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      SlideTransition(
                        position: _itemAnimations[0],
                        child: Image.asset(
                          'assets/SiloLogo_WhiteTrans.png',
                          width: 80,
                        ),
                      ),
                      const SizedBox(height: 60),

                      // Menüpunkte
                      ..._items.asMap().entries.map((entry) {
                        final i = entry.key;
                        final item = entry.value;
                        final isActive = item.page == _activePage;

                        return SlideTransition(
                          position: _itemAnimations[i],
                          child: GestureDetector(
                            onTap: () => _selectPage(item.page),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                children: [
                                  // Animierter Strich
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.easeInOut,
                                    width: isActive ? 24 : 0,
                                    height: 2,
                                    color: Colors.white,
                                    margin: EdgeInsets.only(
                                      right: isActive ? 12 : 0,
                                    ),
                                  ),
                                  // Animierter Text
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.easeInOut,
                                    style: TextStyle(
                                      color: isActive
                                          ? Colors.white
                                          : Colors.white54,
                                      fontSize: isActive ? 22 : 18,
                                      fontWeight: isActive
                                          ? FontWeight.w900
                                          : FontWeight.w400,
                                      letterSpacing: 4,
                                    ),
                                    child: Text(item.label),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final MenuPage page;
  final String label;
  const _MenuItem({required this.page, required this.label});
}