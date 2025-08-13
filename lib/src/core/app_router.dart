import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/chat/chat_screen.dart';
import '../features/weather/weather_screen.dart';
import '../features/market/market_screen.dart';
import '../features/pest/pest_screen.dart';
import '../features/schemes/scheme_screen.dart';
import '../features/library/library_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/news/news_screen.dart';
import '../features/maps/maps_screen.dart';
import '../features/analytics/analytics_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (c, s) => const DashboardScreen()),
      GoRoute(path: '/chat', builder: (c, s) => const ChatScreen()),
      GoRoute(path: '/weather', builder: (c, s) => const WeatherScreen()),
      GoRoute(path: '/market', builder: (c, s) => const MarketScreen()),
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
