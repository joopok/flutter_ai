import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await ref.read(authNotifierProvider.notifier).checkLoginStatus();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(authNotifierProvider.notifier).login(
              _idController.text,
              _passwordController.text,
            );

        final authState = ref.read(authNotifierProvider);
        if (authState.errorMessage != null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authState.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('로그인 중 오류가 발생했습니다: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
    final authState = ref.watch(authNotifierProvider);

    // 로딩 중일 때 로딩 인디케이터 표시
    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 이미 로그인된 상태라면 홈 화면으로 이동
    if (authState.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/');
      });
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
                            imageUrl: 'https://cdn-icons-png.flaticon.com/512/2830/2830284.png',
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
                          onPressed: authState.isLoading ? null : _handleLogin,
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

  Widget _buildTextButton(String text, bool isDarkMode, {VoidCallback? onPressed}) {
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
}
