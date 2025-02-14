import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'home.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // 로그인되지 않은 상태라면 로그인 화면으로 이동
    if (!authState.isAuthenticated) {
      return const LoginScreen();
    }

    // 로그인된 상태라면 Home 화면으로 이동
    return const Home();
  }
} 