import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
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
import 'screens/consume_detail.dart';
import 'screens/notice_list_screen.dart';
import 'screens/event_screen.dart';
import 'screens/workplace_screen.dart';
import 'screens/esports_screen.dart';
import 'screens/teen_screen.dart';
import 'screens/benefit.dart';
import 'screens/api_test_screen.dart';
import 'screens/find_id_screen.dart';
import 'screens/find_password_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/app_introduction_screen.dart';
import 'config/theme.dart';
import 'screens/error_screen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:developer' show log;
import 'package:flutter/services.dart';
import 'screens/notice_list.dart';  // NoticeListPage를 포함하는 파일
import 'components/auto_logout_warning.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/find-id',
        name: 'find-id',
        builder: (context, state) => const FindIdScreen(),
      ),
      GoRoute(
        path: '/find-password',
        name: 'find-password',
        builder: (context, state) => const FindPasswordScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),

      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MyHomePage(),
      ),
      GoRoute(
        path: '/consume',
        name: 'consume',
        builder: (context, state) => const ConsumeScreen(),
      ),
      GoRoute(
        path: '/asset',
        name: 'asset',
        builder: (context, state) => const AssetScreen(),
      ),
      GoRoute(
        path: '/product',
        name: 'product',
        builder: (context, state) => const ProductScreen(),
      ),
      GoRoute(
        path: '/favor',
        name: 'favor',
        builder: (context, state) => const FavorScreen(),
      ),
      GoRoute(
        path: '/consume/detail',
        builder: (context, state) => const ConsumeDetailScreen(),
      ),
      GoRoute(
        path: '/notice',
        builder: (context, state) => const NoticeListPage(),
      ),
      GoRoute(
        path: '/notice-list',
        builder: (context, state) => const NoticeListPage(),
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
      GoRoute(
        path: '/benefit',
        builder: (context, state) => const BenefitScreen(),
      ),
      GoRoute(
        path: '/api-test',
        builder: (context, state) => const ApiTestScreen(),
      ),
      GoRoute(
        path: '/app-introduction',
        builder: (context, state) => const AppIntroductionScreen(),
      ),
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
    redirect: (context, state) {
      final isAuthenticated = ref.read(authStateProvider).isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      // 인증이 필요없는 화면들
      final nonAuthPaths = [
        '/login',
        '/find-id',
        '/find-password',
        '/signup',
        '/splash',
        '/app-introduction',
      ];

      // 현재 경로가 인증이 필요없는 경로인지 확인
      final isNonAuthPath = nonAuthPaths.contains(state.matchedLocation);

      // 인증이 필요없는 경로는 리다이렉트하지 않음
      if (isNonAuthPath) return null;

      // 인증이 필요한 경로에 대한 처리
      if (!isAuthenticated) {
        // 로그인이 필요한 페이지 접근 시 로그인 페이지로 리다이렉트
        return '/login';
      }

      // 이미 로그인된 상태에서 로그인 페이지 접근 시 홈으로 리다이렉트
      if (isAuthenticated && isLoggingIn) {
        return '/home';
      }

      return null;
    },
  );

  return router;
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final isDarkMode = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(padding: EdgeInsets.zero),
          child: Stack(
            children: [
              LoadingOverlay(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).padding.top,
                          color: Theme.of(context).appBarTheme.backgroundColor,
                        ),
                        Expanded(
                          child: child ?? const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const AutoLogoutWarning(
                child: SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
      title: 'WON Banking',
      theme: AppTheme.lightTheme,
      darkTheme: app_theme.AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
