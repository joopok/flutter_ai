import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'screens/home.dart';
import 'screens/asset.dart';
import 'screens/product.dart';
import 'screens/consume.dart';
import 'screens/favor.dart';
import 'screens/notice.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'components/loading_overlay.dart';
import 'theme/app_theme.dart' as app_theme;
import 'screens/product.dart';
import 'screens/asset.dart';
import 'screens/consume.dart';
import 'screens/consume_detail.dart';
import 'screens/favor.dart';
import 'screens/splash_screen.dart';
import 'screens/notice.dart';
import 'screens/notice_list_screen.dart';
import 'screens/event_screen.dart';
import 'screens/workplace_screen.dart';
import 'screens/esports_screen.dart';
import 'screens/teen_screen.dart';
import 'screens/login_screen.dart';
import 'providers/auth_provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // 앱 시작 시 인증 상태 초기화
  final isAuthenticated = sharedPreferences.getBool('isAuthenticated') ?? false;
  final userId = sharedPreferences.getString('userId');
  final userName = sharedPreferences.getString('userName');

  // 필수 인증 데이터가 하나라도 없으면 모든 데이터 초기화
  if (!isAuthenticated || userId == null || userName == null) {
    await sharedPreferences.clear();
  }
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  debugPrint('routerProvider.....aSSSSSS');
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
        redirect: (context, state) {
          final isAuthenticated = ref.read(authNotifierProvider).isAuthenticated;
          if (!isAuthenticated) {
            return '/login';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/asset',
        builder: (context, state) => const AssetScreen(),
      ),
      GoRoute(
        path: '/product',
        builder: (context, state) => const ProductScreen(),
      ),
      GoRoute(
        path: '/consume',
        builder: (context, state) => const ConsumeScreen(),
      ),
      GoRoute(
        path: '/favor',
        builder: (context, state) => const FavorScreen(),
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
    redirect: (context, state) {
      final isAuthenticated = ref.read(authNotifierProvider).isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';
      final isSplash = state.matchedLocation == '/splash';

      // 스플래시 화면에서는 리다이렉트하지 않음
      if (isSplash) return null;

      if (!isAuthenticated && !isLoggingIn) {
        debugPrint('22222routerProvider.....DDDDD');
        return '/login';
      }

      if (isAuthenticated && isLoggingIn) {
        return '/';
      }

      return null;
    },
  );

  return router;
});

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(authNotifierProvider.notifier).checkLoginStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final isDarkMode = ref.watch(themeNotifierProvider);
    
    return MaterialApp.router(
      title: 'WON Banking',
      theme: app_theme.AppTheme.lightTheme,
      darkTheme: app_theme.AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return LoadingOverlay(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: child ?? const SizedBox(),
          ),
        );
      },
    );
  }
}
