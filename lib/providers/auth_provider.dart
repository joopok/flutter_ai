import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/api_service.dart';
import '../models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    User? user,
    String? errorMessage,
    @Default(true) bool isAmountVisible,
    UserData? userData,
  }) = _AuthState;
}

// StateNotifierProvider로 변경하고 이름 변경
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> checkLoginStatus() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // 로그인 상태 체크 로직
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final result = await ApiService.login(
        username: username,
        password: password,
      );
      
      final user = User(
        id: 1,
        email: result['email'] ?? '',
        name: result['name'] ?? '',
        username: result['username'] ?? '',
        role: result['role'] ?? 'user',
        updatedAt: DateTime.now().toIso8601String(),
        profileImage: result['profileImage'],
      );
      
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        userData: UserData(
          id: user.id.toString(),
          name: user.name,
          username: user.username,
          email: user.email,
          role: user.role,
          updatedAt: DateTime.now().toIso8601String(),
          profileImage: user.profileImage,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> setLoggedIn(String token, UserData userData) async {
    state = state.copyWith(
      isAuthenticated: true,
      userData: userData,
      isLoading: false,
    );
  }

  void logout() {
    state = const AuthState();
  }

  void toggleAmountVisibility() {
    state = state.copyWith(isAmountVisible: !state.isAmountVisible);
  }
}

// Provider 이름 변경
final currentUserProvider = Provider<UserData?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.userData;
});

// Provider 이름 변경
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});

@riverpod
class Auth extends _$Auth {
  @override
  AsyncValue<User?> build() => const AsyncValue.data(null);

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      final result = await ApiService.login(
        username: username,
        password: password,
      );
      
      final user = User(
        id: 1,
        email: result['email'] ?? '',
        name: result['name'] ?? '',
        username: result['username'] ?? '',
        role: result['role'] ?? 'user',
        updatedAt: DateTime.now().toIso8601String(),
        profileImage: result['profileImage'],
      );
      
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void logout() {
    state = const AsyncValue.data(null);
  }
} 