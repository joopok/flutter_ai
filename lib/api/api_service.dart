import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'dio_client.dart';
import 'http_client.dart';
import '../models/api_response.dart';
import 'api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/notice.dart';

/// ApiService 인스턴스를 제공하는 Provider
final apiServiceProvider = Provider((ref) => ApiService(
      dioClient: ref.watch(dioClientProvider),
      httpClient: ref.watch(httpClientProvider),
    ));

/// API 호출 로깅을 위한 유틸리티 함수
/// [method] HTTP 메서드 (GET, POST 등)
/// [endpoint] API 엔드포인트 경로
/// [request] 요청 데이터 (선택사항)
/// [response] 응답 데이터 (선택사항)
void _logApiCall(String method, String endpoint, {dynamic request, dynamic response}) {
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

/// API 통신을 담당하는 서비스 클래스
class ApiService {
  final DioClient dioClient;
  final HttpClient httpClient;

  ApiService({
    required this.dioClient,
    required this.httpClient,
  });

  /// Dio를 사용한 로그인 API 호출
  /// [username1] 사용자 아이디
  /// [password] 사용자 비밀번호
  /// Returns: 로그인 응답 데이터
  Future<ApiResponse<Map<String, dynamic>>> loginWithDio({required String username1, required String password,}) async {
    return await dioClient.post(
      ApiConfig.login,
      data: {
        'username1': username1,
        'password': password,
      },
    );
  }

  /// HTTP를 사용한 로그인 API 호출
  /// [username1] 사용자 아이디
  /// [password] 사용자 비밀번호
  /// Returns: 로그인 응답 데이터
  Future<ApiResponse<Map<String, dynamic>>> loginWithHttp({
    required String username1,
    required String password,
  }) async {
    return await httpClient.post(
      ApiConfig.login,
      body: {
        'username1': username1,
        'password': password,
      },
    );
  }

  /// Dio를 사용한 제품 목록 조회 API
  /// Returns: 제품 목록 데이터
  Future<ApiResponse<List<Map<String, dynamic>>>> getProductsWithDio() async {
    return await dioClient.get('/products');
  }

  /// HTTP를 사용한 제품 목록 조회 API
  /// Returns: 제품 목록 데이터
  Future<ApiResponse<List<Map<String, dynamic>>>> getProductsWithHttp() async {
    return await httpClient.get('/products');
  }

  /// HTTP를 사용한 테스트 API 호출
  /// Returns: 테스트 응답 데이터
  Future<ApiResponse<List<Map<String, dynamic>>>> getTestWithHttp() async {
    return await httpClient.get('/test');
  }
  
  /// 회원가입 API 호출
  /// [username1] 사용자 아이디
  /// [password] 사용자 비밀번호
  /// [name] 사용자 이름
  /// [email] 사용자 이메일
  /// Returns: 회원가입 응답 데이터
  static Future<Map<String, dynamic>> register({
    required String username1,
    required String password,
    required String name,
    required String email,
  }) async {
    final requestData = {
      'username1': username1,
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

  /// 로그인 API 호출
  /// [username1] 사용자 아이디
  /// [password] 사용자 비밀번호
  /// Returns: 로그인 응답 데이터 (토큰, 사용자 정보 등)
  static Future<Map<String, dynamic>> login({
    required String username1,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username1': username1,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return {
          'accessToken': responseData['accessToken']?.toString() ?? '',
          'username1': responseData['username1']?.toString() ?? username1,
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

  /// 일반적인 API 요청 처리
  /// [method] HTTP 메서드 (GET, POST 등)
  /// [path] API 엔드포인트 경로
  /// [fromJson] JSON 응답을 객체로 변환하는 함수
  /// [data] 요청 데이터 (선택사항)
  /// Returns: API 응답 데이터
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

  /// 공지사항 목록 조회
  /// Returns: 공지사항 목록 데이터
  Future<List<Notice>> getNotices() async {
    try {
      
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.noticeList}');
      print('Request URL: $uri');
      
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final dynamic jsonData = json.decode(response.body);
          List<Notice> notices = [];

          if (jsonData is List) {
            notices = jsonData
                .map((item) => Notice.fromJson(item as Map<String, dynamic>))
                .take(5)
                .toList();
          } else if (jsonData is Map<String, dynamic>) {
            final items = jsonData['data'] ?? 
                         jsonData['items'] ?? 
                         jsonData['notices'] ?? 
                         [];
            if (items is List) {
              notices = items
                  .map((item) => Notice.fromJson(item as Map<String, dynamic>))
                  .take(5)
                  .toList();
            }
          }

          if (notices.isNotEmpty) {
            print('Successfully fetched ${notices.length} notices');
            return notices;
          }
        } catch (e) {
          print('Error parsing notices: $e');
        }
      } else {
        print('Server returned status code: ${response.statusCode}');
      }
      return [];
    } catch (e) {
      print('Network error: $e');
      return [];
    }
  }


  Future<List<Notice>> getNoticeMainList() async {
    try {
      print('공지사항 데이터를 가져오는 중...');
      final response = await dioClient.post(ApiConfig.noticeMainList,
          data: {'page': 1, 'size': 5, 'sort': '-createdAt'});

      if (response.success && response.data != null) {
        final List<dynamic> noticesData = response.data['data'] ?? [];
        return noticesData.map((json) => Notice.fromJson(json)).toList();
      } else {
        print('서버 응답 오류: ${response.message}');
        return [];
      }
    } catch (e) {
      print('공지사항 조회 중 오류 발생: $e');
      return [];
    }
  }

}