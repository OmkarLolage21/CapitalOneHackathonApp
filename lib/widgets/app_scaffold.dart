import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/l10n.dart';

class AppScaffoldWrapper extends StatelessWidget {
  final Widget child;
  final String currentPath;
  
  const AppScaffoldWrapper({super.key, required this.child, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    // Only show bottom nav for main screens
    final showBottomNav = [
      '/',
      '/chat', 
      '/weather',
      '/market',
      '/alerts'
    ].contains(currentPath);

    if (!showBottomNav) {
      return child;
    }

    final l = AppLocalizations.of(context)!;
    final currentIndex = _getCurrentIndex(currentPath);

    final items = [
      (Icons.dashboard_outlined, l.advisoriesToday),
      (Icons.chat_bubble_outline, l.chat),
      (Icons.wb_sunny_outlined, l.weather),
      (Icons.currency_rupee_outlined, l.market),
      (Icons.warning_amber_outlined, l.alerts),
    ];

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceContainerLowest,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: child,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: NavigationBar(
            height: 64,
            selectedIndex: currentIndex,
            onDestinationSelected: (i) => _navigateToIndex(context, i),
            destinations: [
              for (final item in items)
                NavigationDestination(
                  icon: Icon(item.$1),
                  label: item.$2,
                )
            ],
          ),
        ),
      ),
    );
  }

  int _getCurrentIndex(String path) {
    switch (path) {
      case '/': return 0;
      case '/chat': return 1;
      case '/weather': return 2;
      case '/market': return 3;
      case '/alerts': return 4;
      default: return 0;
    }
  }

  void _navigateToIndex(BuildContext context, int index) {
    final routes = ['/', '/chat', '/weather', '/market', '/alerts'];
    if (index < routes.length) {
      context.go(routes[index]);
    }
  }
}