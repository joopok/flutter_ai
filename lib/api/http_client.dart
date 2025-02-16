import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_config.dart';
import '../models/api_response.dart';
import 'package:flutter/foundation.dart';
import '../providers/auto_logout_provider.dart';

final httpClientProvider = Provider((ref) => HttpClient(ref));

class HttpClient {
  final Ref ref;
  final client = http.Client();

  HttpClient(this.ref);

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse(ApiConfig.baseUrl + path).replace(
        queryParameters: queryParameters,
      );

      // 요청 로깅
      _logRequest('GET', uri, headers: headers);

      final response = await client.get(
        uri,
        headers: {...ApiConfig.headers, ...?headers},
      ).timeout(ApiConfig.timeout);

      // 응답 로깅
      _logResponse(response);

      return _handleResponse(response, fromJson);
    } catch (e) {
      // 에러 로깅
      _logError(e);
      return ApiResponse(
        success: false,
        message: '네트워크 오류: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse(ApiConfig.baseUrl + path);
      final jsonBody = jsonEncode(body);

      // 요청 로깅
      _logRequest('POST', uri, headers: headers, body: body);

      final response = await client.post(
        uri,
        headers: {...ApiConfig.headers, ...?headers},
        body: jsonBody,
      ).timeout(ApiConfig.timeout);

      // 응답 로깅
      _logResponse(response);

      return _handleResponse(response, fromJson);
    } catch (e) {
      // 에러 로깅
      _logError(e);
      return ApiResponse(
        success: false,
        message: '네트워크 오류: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<T>> request<T>({
    required String method,
    required String path,
    Map<String, dynamic>? data,
  }) async {
    try {
      // API 호출 시 자동 로그아웃 타이머 리셋
      ref.read(autoLogoutProvider.notifier).resetTimer();
      
      final uri = Uri.parse('${ApiConfig.baseUrl}$path');
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
      };

      final response = await (method == 'GET' 
        ? http.get(uri, headers: headers)
        : http.post(
            uri,
            headers: headers,
            body: utf8.encode(json.encode(data)),
          ));
      
      // UTF-8로 응답 디코딩
      final responseBody = utf8.decode(response.bodyBytes);
      //debugPrint('Response body :::: $responseBody');
      
      if (response.statusCode != 200) {
        return ApiResponse<T>(
          success: false,
          message: '서버 오류: ${response.statusCode}',
        );
      }

      final responseData = json.decode(responseBody) as Map<String, dynamic>? 
          ?? {'data': null, 'message': '응답 데이터가 없습니다.'};
      //debugPrint('Response responseData :::: $responseData');    
      return ApiResponse<T>(
        success: true,
        data: responseData['data'] as T?,
        message: responseData['message'] as String?,
      );
    } catch (e) {
      //debugPrint('Error in request: $e');
      return ApiResponse<T>(
        success: false,
        message: '오류가 발생했습니다: $e',
      );
    }
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    try {
      // PHP 응답에서 'data = ' 부분 제거
      String responseText = response.body;
      if (responseText.startsWith('data = ')) {
        responseText = responseText.substring(7);  // 'data = ' 제거
      }
      
      final body = jsonDecode(responseText);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          success: true,
          data: fromJson != null ? fromJson(body) : body as T,
          message: '성공적으로 조회 하였습니다.',
        );
      } else {
        return ApiResponse(
          success: false,
          message: body['message'] ?? '서버 오류가 발생했습니다.',
          errors: List<String>.from(body['errors'] ?? []),
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: '응답 처리 중 오류 : ${e.toString()}',
        data: response.body as T,
      );
    }
  }

  // 요청 로깅
  void _logRequest(String method, Uri uri, {Map<String, String>? headers, dynamic body, }) {
    final requestLog = {
      'method': method,
      'url': uri.toString(),
      'headers': headers ?? {},
      if (body != null) 'body': body,
    };
    debugPrint('\n📤 요청:\n${_prettyJson(requestLog)}\n');
  }

  // 응답 로깅
  void _logResponse(http.Response response) {
    final responseBody = _tryParseJson(response.body);
    final responseLog = {
      'statusCode': response.statusCode,
      'headers': response.headers,
      'body': responseBody,
    };
    debugPrint('\n📥 응답:\n${_prettyJson(responseLog)}\n');
  }

  // 에러 로깅
  void _logError(dynamic error) {
    final errorLog = {
      'error': error.toString(),
      'stackTrace': StackTrace.current.toString(),
    };
    debugPrint('\n❌ 에러:\n${_prettyJson(errorLog)}\n');
  }

  // JSON을 보기 좋게 포맷팅
  String _prettyJson(dynamic json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  // JSON 파싱 시도
  dynamic _tryParseJson(String text) {
    try {
      return jsonDecode(text);
    } catch (e) {
      return text;
    }
  }
}
