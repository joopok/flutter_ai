import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('아이디를 입력하세요:'),
            const SizedBox(height: 8),
            TextField(
              autofocus: true,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '아이디',
              ),
            ),
            const SizedBox(height: 16),
            const Text('비밀번호를 입력하세요:'),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '비밀번호',
              ),
            ),
            const SizedBox(height: 16),
            const Text('이메일을 입력하세요:'),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '이메일',
                hintText: 'example@domain.com',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 회원가입 로직 추가
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('회원가입이 완료되었습니다.')),
                );
              },
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
} 