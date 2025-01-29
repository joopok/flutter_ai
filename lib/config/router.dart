import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/login_screen.dart';
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
import '../providers/auth_provider.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final authState = context.read(authProvider);
    final isLoggedIn = authState.isAuthenticated;
    if (!isLoggedIn && state.location != '/login') {
      return '/login';
    }
    if (isLoggedIn && state.location == '/login') {
      return '/home';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
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
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('페이지를 찾을 수 없습니다'),
    ),
  ),
);