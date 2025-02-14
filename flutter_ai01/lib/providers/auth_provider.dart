import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_provider.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    @Default(true) bool isAmountVisible,
    String? errorMessage,
  }) = _AuthState;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> login(String id, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      // TODO: 실제 로그인 API 호출 구현
      await Future.delayed(const Duration(seconds: 2)); // 임시 딜레이
      
      // 임시 검증 로직 (실제 구현시 서버 검증으로 대체)
      if (id == 'test' && password == 'test123') {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
        );
      } else {
        throw Exception('아이디 또는 비밀번호가 올바르지 않습니다.');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void logout() {
    state = const AuthState();
  }

  // 금액 표시 여부 토글
  void toggleAmountVisibility() {
    state = state.copyWith(
      isAmountVisible: !state.isAmountVisible,
    );
  }

  // 데이터 새로고침
  Future<void> refreshData() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: 실제 데이터 새로고침 API 호출 구현
      await Future.delayed(const Duration(seconds: 2)); // 임시 딜레이
      
      state = state.copyWith(
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  // 계좌 목록 표시
  Future<void> showAccountList() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: 실제 계좌 목록 조회 API 호출 구현
      await Future.delayed(const Duration(seconds: 1)); // 임시 딜레이
      
      state = state.copyWith(
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
}); 