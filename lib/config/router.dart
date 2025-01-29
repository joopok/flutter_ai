import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../screens/login_screen.dart';
import '../providers/auth_provider.dart';

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this.ref) {
    ref.listen(
      authProvider.select((value) => value.isAuthenticated),
      (_, __) => notifyListeners(),
    );
  }

  final Ref ref;
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/login',
    refreshListenable: RouterNotifier(ref),
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isAuthenticated = authState.isAuthenticated;
      final hasUserData = authState.userData != null;
      final isLoginRoute = state.matchedLocation == '/login';

      // 인증되지 않았거나 사용자 데이터가 없으면 로그인 화면으로
      if (!isAuthenticated || !hasUserData) {
        return isLoginRoute ? null : '/login';
      }

      // 인증된 상태에서 로그인 화면으로 가려고 하면 홈으로
      if (isLoginRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MyHomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
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
  return router;
});