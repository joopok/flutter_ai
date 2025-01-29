import 'package:go_router/go_router.dart';
import '../screens/home.dart';
import '../screens/product.dart';
import '../screens/asset.dart';
import '../screens/consume.dart';
import '../screens/consume_detail.dart';
import '../screens/favor.dart';
import '../screens/splash_screen.dart';
import '../screens/notice.dart';
import '../screens/noticeList.dart';
import '../screens/event_screen.dart';
import '../screens/workplace_screen.dart';
import '../screens/esports_screen.dart';
import '../screens/teen_screen.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/product',
      builder: (context, state) => const ProductScreen(),
    ),
    GoRoute(
      path: '/asset',
      builder: (context, state) => const AssetScreen(),
    ),
    GoRoute(
      path: '/consume',
      builder: (context, state) => const ConsumeScreen(),
    ),
    GoRoute(
      path: '/consume/detail',
      builder: (context, state) => const ConsumeDetailScreen(),
    ),
    GoRoute(
      path: '/favor',
      builder: (context, state) => const FavorScreen(),
    ),
    GoRoute(
      path: '/notice',
      builder: (context, state) => const NoticeScreen(),
    ),
    GoRoute(
      path: '/notice-list',
      builder: (context, state) => const NoticeListScreen(),
    ),
    GoRoute(
      path: '/event',
      builder: (context, state) => const EventScreen(),
    ),
    GoRoute(
      path: '/workplace',
      builder: (context, state) => const WorkplaceScreen(),
    ),
    GoRoute(
      path: '/esports',
      builder: (context, state) => const EsportsScreen(),
    ),
    GoRoute(
      path: '/teen',
      builder: (context, state) => const TeenScreen(),
    ),
  ],
);