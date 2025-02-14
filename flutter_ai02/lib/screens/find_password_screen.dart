import 'package:flutter/material.dart';

class FindPasswordScreen extends StatelessWidget {
  const FindPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀번호 찾기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('아이디를 입력하세요:'),
            const SizedBox(height: 8),
            const TextField(
              autofocus: true,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '아이디',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 비밀번호 찾기 로직 추가
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('비밀번호 재설정 링크가 전송되었습니다.')),
                );
              },
              child: const Text('비밀번호 찾기'),
            ),
            const SizedBox(height: 16),
            const Text(
              '등록된 이메일로 비밀번호 재설정 링크가 전송됩니다.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
} 