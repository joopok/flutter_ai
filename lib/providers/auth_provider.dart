import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../constants/app_constants.dart';

part 'auth_provider.freezed.dart';
part 'auth_provider.g.dart';

// 로그인 상태 저장을 위한 SharedPreferences 프로바이더
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

@freezed
class UserData with _$UserData {
  const factory UserData({
    required String id,
    required String name,
    required String username,
    required String email,
    required String role,
    required String updatedAt,
    String? profileImage,
  }) = _UserData;
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isAuthenticated,
    @Default(false) bool isLoading,
    @Default(true) bool isAmountVisible,
    UserData? userData,
    String? errorMessage,
  }) = _AuthState;
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> checkLoginStatus() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      // TODO: 실제 로컬 스토리지나 secure storage에서 토큰 확인 로직 구현
      final hasToken = await _checkStoredToken();
      
      if (hasToken) {
        // TODO: 토큰 유효성 검증 로직 구현
        final userData = await _fetchUserData();
        state = state.copyWith(
          isAuthenticated: true,
          userData: userData,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          userData: null,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '로그인 상태 확인 중 오류가 발생했습니다: $e',
      );
    }
  }

  Future<void> login(String userId, String password) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      if (userId == 'test' && password == 'test123') {
        final userData = const UserData(
          id: 'test', 
          name: '도승현',
          username: 'test',
          email: 'test@example.com',
          role: 'user',
          updatedAt: '2024-01-01',
          profileImage: 'https://ui-avatars.com/api/?name=도승현&background=random',
        );
        
        await _saveToken('dummy_token');
        
        state = state.copyWith(
          isAuthenticated: true,
          userData: userData,
          isLoading: false,
        );
      } else {
        throw Exception('아이디 또는 비밀번호가 올바르지 않습니다.');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '로그인 중 오류가 발생했습니다: $e',
      );
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      // TODO: 실제 로그아웃 API 호출 및 토큰 삭제 로직 구현
      await _clearToken();
      
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '로그아웃 중 오류가 발생했습니다: $e',
      );
    }
  }

  void toggleAmountVisibility() {
    state = state.copyWith(isAmountVisible: !state.isAmountVisible);
  }

  Future<bool> _checkStoredToken() async {
    // TODO: 실제 토큰 확인 로직 구현
    return false;
  }

  Future<void> _saveToken(String token) async {
    // TODO: 실제 토큰 저장 로직 구현
  }

  Future<void> _clearToken() async {
    // TODO: 실제 토큰 삭제 로직 구현
  }

  Future<UserData> _fetchUserData() async {
    return const UserData(
      id: 'test',
      name: '도승현',
      username: 'test',
      email: 'test@example.com',
      role: 'user',
      updatedAt: '2024-01-01',
      profileImage: AppConstants.defaultProfileImage,
    );
  }

  Future<void> setLoggedIn(String token, UserData userData) async {
    state = state.copyWith(
      isAuthenticated: true,
      userData: userData,
      isLoading: false,
    );
    // TODO: 토큰 저장 로직 구현
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
}

// 현재 로그인한 사용자 정보를 위한 프로바이더
final currentUserProvider = Provider<UserData?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  if (!authState.isAuthenticated) return null;
  return authState.userData;
});

// 로그인 상태 확인을 위한 프로바이더
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isAuthenticated;
});

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    return const AuthState();
  }

  void toggleAmountVisibility() {
    state = state.copyWith(isAmountVisible: !state.isAmountVisible);
  }
} 