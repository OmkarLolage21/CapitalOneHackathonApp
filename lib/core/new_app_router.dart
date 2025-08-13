import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

// New pages
import '../features/dashboard/dashboard_page.dart';
import '../features/chat/chat_page.dart';
import '../features/weather/weather_page.dart';
import '../features/market/market_page.dart';

// Existing pages 
import '../src/features/pest/pest_screen.dart';
import '../src/features/schemes/scheme_screen.dart';
import '../src/features/library/library_screen.dart';
import '../src/features/profile/profile_screen.dart';
import '../src/features/news/news_screen.dart';
import '../src/features/maps/maps_screen.dart';
import '../src/features/analytics/analytics_screen.dart';

// Wrapper
import '../widgets/app_scaffold.dart';

final newAppRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      // Main routes with new design
      GoRoute(
        path: '/',
        builder: (context, state) => AppScaffoldWrapper(
          currentPath: state.uri.toString(),
          child: const DashboardPage(),
        ),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => AppScaffoldWrapper(
          currentPath: state.uri.toString(),
          child: const ChatPage(),
        ),
      ),
      GoRoute(
        path: '/weather',
        builder: (context, state) => AppScaffoldWrapper(
          currentPath: state.uri.toString(),
          child: const WeatherPage(),
        ),
      ),
      GoRoute(
        path: '/market',
        builder: (context, state) => AppScaffoldWrapper(
          currentPath: state.uri.toString(),
          child: const MarketPage(),
        ),
      ),
      GoRoute(
        path: '/alerts',
        builder: (context, state) => AppScaffoldWrapper(
          currentPath: state.uri.toString(),
          child: const _AlertsPage(),
        ),
      ),
      
      // Legacy routes without new scaffold (for secondary screens)
      GoRoute(path: '/pest', builder: (c, s) => const PestScreen()),
      GoRoute(path: '/schemes', builder: (c, s) => const SchemesScreen()),
      GoRoute(path: '/library', builder: (c, s) => const LibraryScreen()),
      GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
      GoRoute(path: '/news', builder: (c, s) => const NewsScreen()),
      GoRoute(path: '/maps', builder: (c, s) => const MapsScreen()),
      GoRoute(path: '/analytics', builder: (c, s) => const AnalyticsScreen()),
    ],
  );
});

// Simple alerts page placeholder
class _AlertsPage extends StatelessWidget {
  const _AlertsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: const Center(
        child: Text('Alerts will be shown here'),
      ),
    );
  }
}