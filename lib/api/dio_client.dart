import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/api_response.dart';
import 'api_config.dart';

final dioClientProvider = Provider((ref) => DioClient());

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.timeout,
        receiveTimeout: ApiConfig.timeout,
        headers: ApiConfig.headers,
      ),
    );

    _dio.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ),
    ]);
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );

      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  ApiResponse<T> _handleResponse<T>(
    Response<Map<String, dynamic>> response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    final data = response.data!;
    
    return ApiResponse(
      success: true,
      data: fromJson != null ? fromJson(data) : data as T,
    );
  }

  ApiResponse<T> _handleDioError<T>(DioException error) {
    return ApiResponse(
      success: false,
      message: _getErrorMessage(error),
      errors: [error.toString()],
    );
  }

  String _getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return '서버 연결 시간이 초과되었습니다.';
      case DioExceptionType.badResponse:
        return _getStatusCodeMessage(error.response?.statusCode);
      case DioExceptionType.cancel:
        return '요청이 취소되었습니다.';
      default:
        return '네트워크 오류가 발생했습니다.';
    }
  }

  String _getStatusCodeMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return '잘못된 요청입니다.';
      case 401:
        return '인증이 필요합니다.';
      case 403:
        return '접근이 거부되었습니다.';
      case 404:
        return '요청한 리소스를 찾을 수 없습니다.';
      case 500:
        return '서버 오류가 발생했습니다.';
      default:
        return '알 수 없는 오류가 발생했습니다.';
    }
  }
 
}
