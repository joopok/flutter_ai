import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_client.dart';
import 'http_client.dart';
import '../models/api_response.dart';
import 'api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final apiServiceProvider = Provider((ref) => ApiService(
      dioClient: ref.watch(dioClientProvider),
      httpClient: ref.watch(httpClientProvider),
    ));

class ApiService {
  final DioClient dioClient;
  final HttpClient httpClient;

  ApiService({
    required this.dioClient,
    required this.httpClient,
  });

  // Dio를 사용한 API 호출
  Future<ApiResponse<Map<String, dynamic>>> loginWithDio({
    required String username,
    required String password,
  }) async {
    return await dioClient.post(
      '/api/auth/login',
      data: {
        'username': username,
        'password': password,
      },
    );
  }

  // HTTP를 사용한 API 호출
  Future<ApiResponse<Map<String, dynamic>>> loginWithHttp({
    required String username,
    required String password,
  }) async {
    return await httpClient.post(
      ApiConfig.login,
      body: {
        'username': username,
        'password': password,
      },
    );
  }

  // test.php API 호출
  Future<ApiResponse<Map<String, dynamic>>> testWithHttp({
    required String id,
    required String username,
    required String name,
    String? message,
  }) async {
    return await httpClient.post(
      ApiConfig.login,
      body: {
        'id': id,
        'username': username,
        'name': name,
        if (message != null) 'message': message,
      },
    );
  }

  // 제품 목록 조회 (Dio 사용)
  Future<ApiResponse<List<Map<String, dynamic>>>> getProductsWithDio() async {
    return await dioClient.get('/products');
  }

  // 제품 목록 조회 (HTTP 사용)
  Future<ApiResponse<List<Map<String, dynamic>>>> getProductsWithHttp() async {
    return await httpClient.get('/products');
  }

  // 제품 목록 조회 (HTTP 사용)
  Future<ApiResponse<List<Map<String, dynamic>>>> getTestWithHttp() async {
    return await httpClient.get('/test');
  }

  static Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    required String name,
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
        'name': name,
        'email': email,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('회원가입 실패: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      return {
        'accessToken': responseData['accessToken']?.toString() ?? '',
        'username': responseData['username']?.toString() ?? username,
        'message': responseData['message']?.toString(),
      };
    } else {
      throw Exception(responseData['message'] ?? '로그인에 실패했습니다.');
    }
  }
}
