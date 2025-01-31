import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_service.dart';
import '../api/api_config.dart';

class ApiTestScreen extends ConsumerStatefulWidget {
  const ApiTestScreen({super.key});

  @override
  ConsumerState<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends ConsumerState<ApiTestScreen> {
  String _result = '';

  // JSON을 보기 좋게 포맷팅하는 함수
  String _prettyJson(Map<String, dynamic> json) {
    const encoder = JsonEncoder.withIndent('  ');
    try {
      return encoder.convert(json)
          .replaceAll('{', '{\n')
          .replaceAll('}', '\n}')
          .replaceAll('": ', '": ');  // JSON 키-값 구분을 더 명확하게
    } catch (e) {
      return json.toString();
    }
  }

  Future<void> _testDioGet() async {
    try {
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.getProductsWithDio();
      setState(() {
        _result = '요청: GET /products\n\n'
            '응답:\n${_prettyJson({
          'success': response.success,
          'data': response.data,
          'message': response.message,
          'errors': response.errors,
        })}';
      });
    } catch (e) {
      setState(() {
        _result = '에러 발생:\n${_prettyJson({
          'error': e.toString(),
        })}';
      });
    }
  }

  Future<void> _testHttpGet() async {
    try {
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.getProductsWithHttp();
      setState(() {
        _result = '요청: GET /products\n\n'
            '응답:\n${_prettyJson({
          'success': response.success,
          'data': response.data,
          'message': response.message,
          'errors': response.errors,
        })}';
      });
    } catch (e) {
      setState(() {
        _result = '에러 발생:\n${_prettyJson({
          'error': e.toString(),
        })}';
      });
    }
  }

  Future<void> _testTest() async {
    final testData = {
      'id' : '1',
      'email': 'test@example.com',
      'name': 'John Doe',
      'message': 'Test message',
    };

    try {
      final apiService = ref.read(apiServiceProvider);
      setState(() {
        _result = '요청 URL: ${ApiConfig.baseUrl}${ApiConfig.test}\n'
            '요청 메서드: POST\n'
            '요청 데이터:\n${_prettyJson(testData)}\n\n'
            '응답 대기 중...';
      });

      final response = await apiService.testWithHttp(
        id: testData['id']!,
        email: testData['email']!,
        name: testData['name']!,
        message: testData['message'],
      );

      setState(() {
        _result = '요청 URL: ${ApiConfig.baseUrl}${ApiConfig.test}\n'
            '요청 메서드: POST\n'
            '요청 데이터:\n${_prettyJson(testData)}\n\n'
            '응답:\n${_prettyJson({
              'success': response.success,
              'data': response.data,
              'message': response.message,
              'errors': response.errors,
            })}';
      });
    } catch (e) {
      setState(() {
        _result = '요청 URL: ${ApiConfig.baseUrl}${ApiConfig.test}\n'
            '요청 메서드: POST\n'
            '요청 데이터:\n${_prettyJson(testData)}\n\n'
            '에러 발생:\n${_prettyJson({
              'error': e.toString(),
            })}';
      });
    }
  }

  Future<void> _testLogin() async {
    final loginData = {
      'email': 'test@example.com',
      'password': 'password123',
    };

    try {
      final apiService = ref.read(apiServiceProvider);
      setState(() {
        _result = '요청: POST /auth/login\n'
            '요청 데이터:\n${_prettyJson(loginData)}\n\n'
            '응답 대기 중...';
      });

      final response = await apiService.loginWithDio(
        email: loginData['email']!,
        password: loginData['password']!,
      );

      setState(() {
        _result = '요청: POST /auth/login\n'
            '요청 데이터:\n${_prettyJson(loginData)}\n\n'
            '응답:\n${_prettyJson({
          'success': response.success,
          'data': response.data,
          'message': response.message,
          'errors': response.errors,
        })}';
      });
    } catch (e) {
      setState(() {
        _result = '요청: POST /auth/login\n'
            '요청 데이터:\n${_prettyJson(loginData)}\n\n'
            '에러 발생:\n${_prettyJson({
          'error': e.toString(),
        })}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API 테스트'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _testDioGet,
              child: const Text('Dio GET 테스트'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _testHttpGet,
              child: const Text('HTTP GET 테스트'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _testLogin,
              child: const Text('로그인 테스트'),
            ),
            ElevatedButton(
              onPressed: _testTest,
              child: const Text('TEst 테스트'),
            ),
            const SizedBox(height: 16),
            const Text('결과:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),  // VS Code 스타일 다크 테마
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    _result,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      color: Colors.white,  // 텍스트 색상을 흰색으로
                      height: 1.5,  // 줄 간격 조정
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
