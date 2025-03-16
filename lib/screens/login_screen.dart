import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../components/loading_overlay.dart';
import '../components/custom_app_bar.dart';
import '../api/api_config.dart';
import 'package:dio/dio.dart';
import '../utils/format_utils.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;
//import 'package:json_pretty/json_pretty.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoggingIn = false;
  bool _idHasFocus = false;
  bool _passwordHasFocus = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  
  final _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: ApiConfig.timeout,
    receiveTimeout: ApiConfig.timeout,
    headers: ApiConfig.headers,
  ));

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    
    Future(() {
      _checkLoginStatus(ref);
    });
    
    // 애니메이션 시작
    _animationController.forward();
    
    // 영문 키보드 활성화
    SystemChannels.textInput.invokeMethod('TextInput.setLocale', 'en-US');
  }

  void _handleLogin(BuildContext context, WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    setState(() {
      _isLoggingIn = true;
    });

    try {
      ref.read(loadingProvider.notifier).show(LoadingType.initializing);

      final response = await _dio.post<Map<String, dynamic>>(
        ApiConfig.login,
        data: {
          'username1': _idController.text,
          'password': _passwordController.text,
        },
      );
      
      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        // data 내부의 데이터에 접근
        final data = responseData['data'] as Map<String, dynamic>;
        final userData = UserData(
          id: data['id']?.toString() ?? '',
          name: data['name']?.toString() ?? _idController.text,
          username1: data['username1']?.toString() ?? _idController.text,
          email: data['email']?.toString() ?? '',
          role: responseData['role']?.toString() ?? 'user',
          updatedAt: data['updated_at']?.toString() ??
              DateTime.now().toIso8601String(),
          profileImage: data['profile_image']?.toString(),
        );

        await ref.read(authStateProvider.notifier).setLoggedIn(
              data['access_token']?.toString() ?? '',
              userData,
            );

        if (context.mounted) {
          final authState = ref.read(authStateProvider);
          if (authState.isAuthenticated) {
            _showLoginSuccess(context);
            Future.delayed(const Duration(milliseconds: 600), () {
              if (context.mounted) {
                context.go('/');
              }
            });
          } else {
            _showErrorToast(context, authState.errorMessage ?? '로그인 실패');
          }
        }
      } else {
        throw Exception('로그인 응답이 올바르지 않습니다.');
      }
    } catch (e) {
      if (context.mounted) {
        String errorMessage = '로그인 오류';
        
        if (e is DioException) {
          switch (e.type) {
            case DioExceptionType.connectionTimeout:
              errorMessage = '연결 시간 초과: 서버에 연결할 수 없습니다.';
              break;
            case DioExceptionType.sendTimeout:
              errorMessage = '요청 시간 초과: 서버에 데이터를 보낼 수 없습니다.';
              break;
            case DioExceptionType.receiveTimeout:
              errorMessage = '응답 시간 초과: 서버로부터 응답을 받을 수 없습니다.';
              break;
            case DioExceptionType.badResponse:
              errorMessage = '잘못된 응답: ${e.response?.statusCode} - ${e.response?.statusMessage}';
              break;
            case DioExceptionType.connectionError:
              errorMessage = '연결 오류: 서버 주소를 확인해주세요.';
              break;
            default:
              errorMessage = '네트워크 오류: ${e.message}';
          }
        } else {
          errorMessage = '오류: $e';
        }
        
        _showErrorToast(context, errorMessage);
      }
    } finally {
      setState(() {
        _isLoggingIn = false;
      });
      if (context.mounted) {
        ref.read(loadingProvider.notifier).hide();
      }
    }
  }
  
  void _showLoginSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('로그인 성공! 홈 화면으로 이동합니다.'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }
  
  void _showErrorToast(BuildContext context, String message) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

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
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 배경 그라데이션
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDarkMode
                    ? [
                        const Color(0xFF1A1A2E),
                        const Color(0xFF16213E),
                        const Color(0xFF0F3460),
                      ]
                    : [
                        const Color(0xFFF8F9FA),
                        const Color(0xFFE9ECEF),
                        const Color(0xFFDEE2E6),
                      ],
              ),
            ),
          ),
          
          // 장식 요소들
          Positioned(
            top: -size.width * 0.3,
            right: -size.width * 0.3,
            child: Container(
              width: size.width * 0.7,
              height: size.width * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDarkMode ? AppColors.primary : AppColors.secondary).withOpacity(0.2),
              ),
            ),
          ),
          
          Positioned(
            bottom: -size.width * 0.4,
            left: -size.width * 0.2,
            child: Container(
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDarkMode ? AppColors.primary : AppColors.secondary).withOpacity(0.15),
              ),
            ),
          ),
          
          // 메인 콘텐츠
          SafeArea(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: child,
                  ),
                );
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        _buildLogoSection(context, isDarkMode),
                        const SizedBox(height: 40),
                        _buildLoginForm(context, isDarkMode),
                        const SizedBox(height: 30),
                        _buildBottomLinks(context, isDarkMode),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLogoSection(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xFF0A2463).withOpacity(0.9),
                  const Color(0xFF3E92CC).withOpacity(0.8),
                ]
              : [
                  const Color(0xFF1E88E5).withOpacity(0.9),
                  const Color(0xFF64B5F6).withOpacity(0.8),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLogo(),
          const SizedBox(height: 20),
          Text(
            '상상은행',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(1, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '당신의 금융 파트너',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(seconds: 1),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: CachedNetworkImage(
          imageUrl: 'https://cdn-icons-png.flaticon.com/512/2830/2830284.png',
          height: 100,
          width: 100,
          fit: BoxFit.contain,
          placeholder: (context, url) => const SizedBox(
            height: 60,
            width: 60,
            child: Center(
              child: CircularProgressIndicator(color: Colors.white70),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.error,
            size: 60,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
  
  Widget _buildLoginForm(BuildContext context, bool isDarkMode) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.black.withOpacity(0.4)
                : Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '안녕하세요!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '계정 정보를 입력해주세요.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 30),
              _buildAnimatedTextField(
                controller: _idController,
                label: '아이디',
                hint: '아이디를 입력하세요',
                icon: Icons.person_outline,
                isDarkMode: isDarkMode,
                hasFocus: _idHasFocus,
                onFocusChange: (hasFocus) {
                  setState(() {
                    _idHasFocus = hasFocus;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '아이디를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildAnimatedTextField(
                controller: _passwordController,
                label: '비밀번호',
                hint: '비밀번호를 입력하세요',
                icon: Icons.lock_outline,
                isDarkMode: isDarkMode,
                hasFocus: _passwordHasFocus,
                onFocusChange: (hasFocus) {
                  setState(() {
                    _passwordHasFocus = hasFocus;
                  });
                },
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onTogglePasswordVisibility: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              _buildLoginButton(isDarkMode),
              const SizedBox(height: 20),
              _buildSocialLoginButtons(isDarkMode),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDarkMode,
    required bool hasFocus,
    required Function(bool) onFocusChange,
    required String? Function(String?) validator,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePasswordVisibility,
  }) {
    final Color focusedColor = isDarkMode 
        ? AppColors.primary 
        : AppColors.secondary;
    final Color unfocusedColor = isDarkMode 
        ? Colors.white70 
        : Colors.black54;
        
    return Focus(
      onFocusChange: onFocusChange,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: hasFocus 
              ? (isDarkMode ? Colors.black12 : Colors.white)
              : (isDarkMode ? Colors.black12 : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasFocus ? focusedColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: hasFocus
              ? [
                  BoxShadow(
                    color: focusedColor.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: TextFormField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: hasFocus ? focusedColor : unfocusedColor,
              fontSize: hasFocus ? 16 : 14,
            ),
            hintText: hint,
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.white38 : Colors.black38,
              fontSize: 14,
            ),
            prefixIcon: Icon(
              icon,
              color: hasFocus ? focusedColor : unfocusedColor,
              size: 22,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: hasFocus ? focusedColor : unfocusedColor,
                      size: 22,
                    ),
                    onPressed: onTogglePasswordVisibility,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16, 
              horizontal: 16,
            ),
          ),
          validator: validator,
          onTapOutside: (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          focusNode: FocusNode()..addListener(() {
            // 포커스를 얻을 때마다 영문 키보드로 설정
            SystemChannels.textInput.invokeMethod('TextInput.setLocale', 'en-US');
          }),
        ),
      ),
    );
  }
  
  Widget _buildLoginButton(bool isDarkMode) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: _isLoggingIn ? 0.95 : value,
          child: child,
        );
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [AppColors.primary, AppColors.primary.withBlue(220)]
                : [AppColors.secondary, AppColors.secondary.withRed(100)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (isDarkMode ? AppColors.primary : AppColors.secondary).withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            splashColor: Colors.white24,
            highlightColor: Colors.white10,
            onTap: _isLoggingIn 
                ? null 
                : () => _handleLogin(context, ref),
            child: Center(
              child: _isLoggingIn
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : const Text(
                      '로그인',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSocialLoginButtons(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: isDarkMode ? Colors.white38 : Colors.black38,
                thickness: 0.5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '또는',
                style: TextStyle(
                  color: isDarkMode ? Colors.white60 : Colors.black54,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: isDarkMode ? Colors.white38 : Colors.black38,
                thickness: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              icon: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/2048px-Google_%22G%22_Logo.svg.png',
              isDarkMode: isDarkMode,
              onTap: () => _showComingSoonToast(context, '구글 로그인'),
            ),
            const SizedBox(width: 20),
            _buildSocialButton(
              icon: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/KakaoTalk_logo.svg/2048px-KakaoTalk_logo.svg.png',
              isDarkMode: isDarkMode,
              onTap: () => _showComingSoonToast(context, '카카오 로그인'),
            ),
            const SizedBox(width: 20),
            _buildSocialButton(
              icon: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Naver_Line_Corporation_logo.svg/1200px-Naver_Line_Corporation_logo.svg.png',
              isDarkMode: isDarkMode,
              onTap: () => _showComingSoonToast(context, '네이버 로그인'),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildSocialButton({
    required String icon,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.white10 : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: CachedNetworkImage(
              imageUrl: icon,
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(
                child: SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                size: 20,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  void _showComingSoonToast(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature 기능은 준비 중입니다.'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }
  
  Widget _buildBottomLinks(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
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
        const SizedBox(height: 20),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 13,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
            children: [
              const TextSpan(
                text: '로그인하면 ',
              ),
              TextSpan(
                text: '이용약관',
                style: TextStyle(
                  color: isDarkMode ? AppColors.primary : AppColors.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const TextSpan(
                text: ' 및 ',
              ),
              TextSpan(
                text: '개인정보 처리방침',
                style: TextStyle(
                  color: isDarkMode ? AppColors.primary : AppColors.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const TextSpan(
                text: '에 동의하게 됩니다.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextButton(String text, bool isDarkMode,
      {VoidCallback? onPressed}) {
    return TextButton(
      onPressed: onPressed ?? () {},
      style: TextButton.styleFrom(
        foregroundColor: isDarkMode ? Colors.white70 : Colors.black54,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        '|',
        style: TextStyle(
          color: isDarkMode ? Colors.white24 : Colors.grey[300],
          fontSize: 14,
        ),
      ),
    );
  }

  Future<void> _checkLoginStatus(WidgetRef ref) async {
    await ref.read(authStateProvider.notifier).checkLoginStatus();
  }
}
