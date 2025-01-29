import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_provider.freezed.dart';

// 로그인 상태 저장을 위한 SharedPreferences 프로바이더
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// 현재 로그인한 사용자 정보를 위한 프로바이더
final currentUserProvider = Provider<UserData?>((ref) {
  final authState = ref.watch(authProvider);
  if (!authState.isAuthenticated) return null;
  return authState.userData;
});

// 로그인 상태 확인을 위한 프로바이더
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

@freezed
class UserData with _$UserData {
  const factory UserData({
    required String id,
    required String name,
    String? email,
    String? profileImage,
  }) = _UserData;
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    @Default(true) bool isAmountVisible,
    UserData? userData,
    String? errorMessage,
  }) = _AuthState;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.ref) : super(const AuthState()) {
    _loadAuthState();
  }

  final Ref ref;

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    final userId = prefs.getString('userId');
    final userName = prefs.getString('userName');

    if (isAuthenticated && userId != null && userName != null) {
      state = state.copyWith(
        isAuthenticated: true,
        userData: UserData(
          id: userId,
          name: userName,
          email: prefs.getString('userEmail'),
          profileImage: prefs.getString('userProfileImage'),
        ),
      );
    }
  }

  Future<void> login(String id, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      // TODO: 실제 로그인 API 호출 구현
      await Future.delayed(const Duration(seconds: 2));
      
      if (id == 'test' && password == 'test123') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAuthenticated', true);
        await prefs.setString('userId', id);
        await prefs.setString('userName', '도승현');

        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userData: UserData(
            id: id,
            name: '도승현',
            email: 'test@example.com',
            profileImage: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
          ),
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

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
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

  void signOut() {
    state = state.copyWith(isAuthenticated: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
}); 