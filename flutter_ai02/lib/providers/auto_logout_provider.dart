import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_provider.dart';
import '../api/api_service.dart';
import '../api/api_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../main.dart';  // routerProvider를 import

class AutoLogoutState {
  final bool isWarningVisible;
  final int remainingSeconds;
  final Timer? timer;

  AutoLogoutState({
    this.isWarningVisible = false,
    this.remainingSeconds = 60,
    this.timer,
  });

  AutoLogoutState copyWith({
    bool? isWarningVisible,
    int? remainingSeconds,
    Timer? timer,
  }) {
    return AutoLogoutState(
      isWarningVisible: isWarningVisible ?? this.isWarningVisible,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      timer: timer ?? this.timer,
    );
  }
}

class AutoLogoutNotifier extends StateNotifier<AutoLogoutState> {
  final Ref ref;
  Timer? _inactivityTimer;
  BuildContext? _context;
  
  AutoLogoutNotifier(this.ref) : super(AutoLogoutState()) {
    // 인증 상태 변경 감지
    ref.listen(authStateProvider, (previous, next) {
      if (next.isAuthenticated) {
        if (!kIsWeb) {
          SystemChannels.lifecycle.setMessageHandler((msg) async {
            if (msg == AppLifecycleState.resumed.toString()) {
              resetTimer();
            }
            return null;
          });
        }
        _startInactivityTimer();
      } else {
        // 로그아웃 상태일 때 타이머 취소
        _inactivityTimer?.cancel();
        state.timer?.cancel();
        state = AutoLogoutState();
      }
    });
  }

  void setContext(BuildContext context) {
    _context = context;
    // context가 설정될 때 인증 상태 확인
    if (ref.read(authStateProvider).isAuthenticated) {
      resetTimer();
    } else {
      _inactivityTimer?.cancel();
      state.timer?.cancel();
    }
  }

  void _startInactivityTimer() {
    // 로그인 상태일 때만 타이머 시작
    if (ref.read(authStateProvider).isAuthenticated) {
      _inactivityTimer?.cancel();
      _inactivityTimer = Timer(const Duration(minutes: 1), _showWarning);
    }
  }

  void resetTimer() {
    state.timer?.cancel();
    _startInactivityTimer();
    if (state.isWarningVisible) {
      state = AutoLogoutState();
    }
  }

  void _showWarning() {
    final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds <= 1) {
        _performLogout();
      } else {
        state = state.copyWith(
          remainingSeconds: state.remainingSeconds - 1,
        );
      }
    });

    state = AutoLogoutState(
      isWarningVisible: true,
      remainingSeconds: 60,
      timer: timer,
    );
  }

  void _performLogout() async {
    state.timer?.cancel();
    _inactivityTimer?.cancel();
    
    try {
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.request<Map<String, dynamic>>(
        method: 'POST',
        path: ApiConfig.logout,
        fromJson: (json) => json as Map<String, dynamic>,
      );
      
      if (response.data?['success'] == true) {
        debugPrint('로그아웃 API 성공');
      }
    } catch (e) {
      debugPrint('로그아웃 API 호출 실패: $e');
    } finally {
      // API 성공 여부와 관계없이 로그아웃 처리
      ref.read(routerProvider).go('/login');  // GoRouter.of() 대신 routerProvider 사용
      ref.read(authStateProvider.notifier).logout();
      state = AutoLogoutState();
    }
  }

  void extendSession() {
    resetTimer();
  }

  // 사용자 활동을 감지하는 메서드 추가
  void onUserActivity() {
    if (!state.isWarningVisible) {
      resetTimer();
    }
  }

  @override
  void dispose() {
    state.timer?.cancel();
    _inactivityTimer?.cancel();
    super.dispose();
  }
}

final autoLogoutProvider =
    StateNotifierProvider<AutoLogoutNotifier, AutoLogoutState>((ref) {
  return AutoLogoutNotifier(ref);
}); 