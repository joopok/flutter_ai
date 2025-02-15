import 'package:flutter/material.dart';

class FindIdScreen extends StatelessWidget {
  const FindIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아이디 찾기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('이메일을 입력하세요:'),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '이메일',
                hintText: 'example@domain.com',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 아이디 찾기 로직 추가
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('아이디 찾기 요청이 전송되었습니다.')),
                );
              },
              child: const Text('아이디 찾기'),
            ),
            const SizedBox(height: 16),
            const Text(
              '등록된 이메일 주소로 아이디를 찾을 수 있습니다.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
} 