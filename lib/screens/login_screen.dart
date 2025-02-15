import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../components/loading_overlay.dart';
import '../api/api_config.dart';
import 'package:dio/dio.dart';
import '../utils/format_utils.dart';
//import 'package:json_pretty/json_pretty.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  
  final _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: ApiConfig.timeout,
    receiveTimeout: ApiConfig.timeout,
    headers: ApiConfig.headers,
  ));

  @override
  void initState() {
    super.initState();
    Future(() {
      _checkLoginStatus(ref);
    });
  }

  void _handleLogin(BuildContext context, WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    try {
      ref.read(loadingProvider.notifier).show(LoadingType.initializing);

      final response = await _dio.post<Map<String, dynamic>>(
        ApiConfig.login,
        data: {
          'username': _idController.text,
          'password': _passwordController.text,
        },
      );
      //debugPrint('로그인 응답 데이터: ${prettyJson(response.data ?? {})}');
      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        //debugPrint('로그인 응답 데이터====: ${prettyJson(responseData)}');
        //debugPrint('로그인 응답 데이터====: ${prettyPrintJson(responseData.toString())}');

        // data 내부의 데이터에 접근
        final data = responseData['data'] as Map<String, dynamic>;
        //debugPrint('1111로그인 응답 데이터====: ${data['name']?.toString()}');
        //debugPrint('1111로그인 응답 데이터====: ${data['name']}');
        final userData = UserData(
          id: data['id']?.toString() ?? '',
          name: data['name']?.toString() ?? _idController.text,
          username: data['username']?.toString() ?? _idController.text,
          email: data['email']?.toString() ?? '',
          role: responseData['role']?.toString() ?? 'user',
          updatedAt: data['updated_at']?.toString() ??
              DateTime.now().toIso8601String(),
          profileImage: data['profile_image']?.toString(),
        );
        //debugPrint('로그인 응답 데이터: $userData');

        await ref.read(authStateProvider.notifier).setLoggedIn(
              data['access_token']?.toString() ?? '',
              userData,
            );

        if (context.mounted) {
          final authState = ref.read(authStateProvider);
          if (authState.isAuthenticated) {
            context.go('/');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '로그인 실패: ${authState.errorMessage}',
                  style: TextStyle(
                    color: isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
                backgroundColor: isDarkMode ? Colors.white : Colors.red,
              ),
            );
          }
        }
      } else {
        throw Exception('로그인 응답이 올바르지 않습니다.');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '로그인 오류: ${e is DioException ? e.message : e}',
              style: TextStyle(
                color: isDarkMode ? Colors.black : Colors.white,
              ),
            ),
            backgroundColor: isDarkMode ? Colors.white : Colors.red,
          ),
        );
      }
    } finally {
      if (context.mounted) {
        ref.read(loadingProvider.notifier).hide();
      }
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 로딩 중일 때 로딩 인디케이터 표시
    if (ref.watch(authStateProvider).isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 이미 로그인된 상태라면 홈 화면으로 이동
    if (context.mounted) {
      final authState = ref.read(authStateProvider);
      if (authState.isAuthenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/home');
        });
      }
    }

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDarkMode
                            ? AppColors.darkGradient
                            : AppColors.lightGradient,
                      ),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/login_pattern.jpeg'),
                        fit: BoxFit.cover,
                        opacity: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(26),
                          ),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://cdn-icons-png.flaticon.com/512/2830/2830284.png',
                            height: 120,
                            width: 120,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => const SizedBox(
                              height: 60,
                              width: 60,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              size: 60,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '상상은행',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '상상은행과 함께하는 스마트한 금융생활',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withAlpha(204),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkMode
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _idController,
                          style: TextStyle(
                            color:
                                isDarkMode ? Colors.white : AppColors.darkText,
                          ),
                          decoration: InputDecoration(
                            labelText: '아이디',
                            labelStyle: TextStyle(
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.grey[600],
                            ),
                            hintText: '아이디를 입력하세요',
                            hintStyle: TextStyle(
                              color: isDarkMode
                                  ? Colors.white30
                                  : Colors.grey[400],
                            ),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? AppColors.primary
                                    : AppColors.secondary,
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '아이디를 입력해주세요';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          style: TextStyle(
                            color:
                                isDarkMode ? Colors.white : AppColors.darkText,
                          ),
                          decoration: InputDecoration(
                            labelText: '비밀번호',
                            labelStyle: TextStyle(
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.grey[600],
                            ),
                            hintText: '비밀번호를 입력하세요',
                            hintStyle: TextStyle(
                              color: isDarkMode
                                  ? Colors.white30
                                  : Colors.grey[400],
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.grey[600],
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.grey[600],
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? AppColors.primary
                                    : AppColors.secondary,
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '비밀번호를 입력해주세요';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: ref.watch(authStateProvider).isLoading ? null : () => _handleLogin(context, ref),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkMode
                                ? AppColors.primary
                                : AppColors.secondary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            '로그인',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTextButton('아이디 찾기', isDarkMode, onPressed: () {
                        context.push('/find-id');
                      }),
                      _buildDivider(isDarkMode),
                      _buildTextButton('비밀번호 찾기', isDarkMode, onPressed: () {
                        context.push('/find-password');
                      }),
                      _buildDivider(isDarkMode),
                      _buildTextButton('회원가입', isDarkMode, onPressed: () {
                        context.push('/signup');
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextButton(String text, bool isDarkMode,
      {VoidCallback? onPressed}) {
    return TextButton(
      onPressed: onPressed ?? () {},
      style: TextButton.styleFrom(
        foregroundColor: isDarkMode ? Colors.white70 : Colors.grey[600],
      ),
      child: Text(text),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '|',
        style: TextStyle(
          color: isDarkMode ? Colors.white24 : Colors.grey[300],
        ),
      ),
    );
  }

  Future<void> _checkLoginStatus(WidgetRef ref) async {
    await ref.read(authStateProvider.notifier).checkLoginStatus();
  }
}
