import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
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

void _logApiCall(String method, String endpoint,
    {dynamic request, dynamic response}) {
  if (kDebugMode) {
    const encoder = JsonEncoder.withIndent('  ');
    print('\n🌐 API 호출 [$method] $endpoint');
    if (request != null) {
      print('\n📤 요청:\n${encoder.convert(request)}');
    }
    if (response != null) {
      print('\n📥 응답:\n${encoder.convert(response)}');
    }
    print('\n${'-' * 50}\n');
  }
}

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
    final requestData = {
      'username': username,
      'password': password,
      'name': name,
      'email': email,
    };

    _logApiCall('POST', ApiConfig.register, request: requestData);

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestData),
    );

    final responseData = json.decode(response.body);
    _logApiCall('POST', ApiConfig.register, response: responseData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return responseData;
    } else {
      final errorMessage = '회원가입 실패: ${response.body}';
      _logApiCall('POST', ApiConfig.register,
          response: {'error': errorMessage});
      throw Exception(errorMessage);
    }
  }

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return {
          'accessToken': responseData['accessToken']?.toString() ?? '',
          'username': responseData['username']?.toString() ?? username,
          'email': responseData['email']?.toString() ?? '',
          'name': responseData['name']?.toString() ?? '',
          'role': responseData['role']?.toString() ?? 'user',
          'message': responseData['message']?.toString(),
        };
      } else {
        throw Exception('로그인에 실패했습니다.');
      }
    } catch (e) {
      throw Exception('네트워크 오류: $e');
    }
  }

  Future<ApiResponse<T>> request<T>({
    required String method,
    required String path,
    required T Function(dynamic) fromJson,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await httpClient.request(
        method: method,
        path: path,
        data: data,
      );
      return ApiResponse<T>(
        success: true,
        data: fromJson(response.data),
        message: response.message,
      );
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: e.toString(),
      );
    }
  }
}
