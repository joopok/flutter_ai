import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import 'home.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final TextEditingController idController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    // 로그인 성공시 홈 화면으로 이동
    ref.listen(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        if (context.mounted) {
          context.go('/home');
        } else {
          print('context is not mounted');
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(  // 키보드가 올라올 때 화면 스크롤 가능하도록
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                // 로고 영역
                Center(
                  child: Text(
                    '우리',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                // 입력 폼
                TextField(
                  controller: idController,
                  enabled: !authState.isLoading,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: '사용자 ID',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  enabled: !authState.isLoading,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '비밀번호',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (authState.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      authState.errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                // 로그인 버튼
                ElevatedButton(
                  onPressed: authState.isLoading
                      ? null
                      : () {
                          if (idController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('사용자 ID를 입력하세요.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          if (passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('비밀번호를 입력하세요.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          if (passwordController.text.length < 4) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('비밀번호는 최소 4자 이상입니다.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          ref.read(authProvider.notifier).login(
                                idController.text,
                                passwordController.text,
                              );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          '로그인',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                // 추가 옵션들
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: authState.isLoading
                          ? null
                          : () {
                              // TODO: ID 찾기 구현
                            },
                      child: Text(
                        'ID 찾기',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    Text(
                      '|',
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                    TextButton(
                      onPressed: authState.isLoading
                          ? null
                          : () {
                              // TODO: 비밀번호 찾기 구현
                            },
                      child: Text(
                        '비밀번호 찾기',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    Text(
                      '|',
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                    TextButton(
                      onPressed: authState.isLoading
                          ? null
                          : () {
                              // TODO: 회원가입 구현
                            },
                      child: Text(
                        '회원가입',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
