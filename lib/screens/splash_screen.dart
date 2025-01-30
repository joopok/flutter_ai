import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // 스플래시 화면 표시 시간
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;

    // 로그인 상태 확인
    await ref.read(authNotifierProvider.notifier).checkLoginStatus();
    
    if (!mounted) return;

    // 인증 상태에 따라 적절한 화면으로 이동
    final isAuthenticated = ref.read(authNotifierProvider).isAuthenticated;
    if (isAuthenticated) {
      context.go('/');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance,
                size: 72,
                color: isDarkMode ? AppColors.primary : AppColors.secondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'WON Banking',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : AppColors.darkText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '생생은행과 함께하는 금융생활',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode 
                  ? Colors.white.withAlpha(204)
                  : AppColors.darkText.withAlpha(204),
              ),
            ),
            const SizedBox(height: 48),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                isDarkMode ? AppColors.primary : AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 