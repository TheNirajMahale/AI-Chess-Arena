import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';

/// Centralized HTTP client configured with interceptors, timeouts, and configurable host URL.
class ApiClient {
  final Dio _dio;
  String _baseUrl;

  ApiClient({String? baseUrl})
      : _baseUrl = baseUrl ?? ApiEndpoints.defaultBaseUrl,
        _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? ApiEndpoints.defaultBaseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Dio get dio => _dio;
  String get baseUrl => _baseUrl;

  void updateBaseUrl(String newBaseUrl) {
    _baseUrl = newBaseUrl;
    _dio.options.baseUrl = newBaseUrl;
  }
}
