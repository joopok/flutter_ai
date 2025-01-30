import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/router.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'screens/home.dart';
import 'screens/asset.dart';
import 'screens/product.dart';
import 'screens/consume.dart';
import 'screens/favor.dart';
import 'screens/notice.dart';
import 'components/loading_overlay.dart';
import 'config/theme.dart';

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
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp.router(
      title: 'WON Banking',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
          surface: Colors.white,
          background: Colors.grey[50]!,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black87,
          onBackground: Colors.black87,
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50],
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: Colors.blue[700]!,
          secondary: Colors.blueAccent[700]!,
          surface: Colors.grey[900]!,
          background: Colors.black,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onBackground: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: Colors.grey[900],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      themeMode: themeMode,
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const MyHomePage(),
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
            path: '/notice',
            builder: (context, state) => const NoticeScreen(),
          ),
        ],
      ),
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
