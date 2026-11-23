import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/api_logger_interceptor.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/constants/constants.dart';
import 'package:syncup/app/services/storage_service.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return DioClient(storageService);
});

class DioClient {
  final StorageService storageService;
  late final Dio dio;

  DioClient(this.storageService) {
    // Purge any legacy local IP overrides (e.g. 192.168.x.x) from simulator storage
    final legacyUrl = storageService.getServerUrl();
    if (legacyUrl != null && (legacyUrl.contains('192.168.') || legacyUrl.contains('localhost'))) {
      storageService.setServerUrl(Constants.baseUrl);
    }

    final effectiveBaseUrl = Constants.baseUrl;

    dio = Dio(
      BaseOptions(
        baseUrl: effectiveBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.baseUrl = effectiveBaseUrl;

          final token = await storageService.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );

    dio.interceptors.add(ApiLoggerInterceptor());
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.get(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.post(path, data: body, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> patch(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.patch(path, data: body, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.delete(path, data: body, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiException _handleDioError(DioException error) {
    if (error.error is SocketException ||
        error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
      return NoInternetConnection(
        'Unable to connect to backend server at:\n${Constants.baseUrl}\n\nPlease check your internet connection or server status.',
      );
    }

    final response = error.response;
    final statusCode = response?.statusCode;

    if (statusCode == 401) {
      return UnAuthorized(response?.data);
    }

    if (statusCode != null && statusCode >= 500) {
      return InternalServerError();
    }

    String message = 'An unexpected error occurred';
    if (response?.data != null) {
      final data = response!.data;
      if (data is Map) {
        if (data['message'] != null) {
          if (data['message'] is List) {
            message = (data['message'] as List).join(', ');
          } else {
            message = data['message'].toString();
          }
        } else if (data['error'] != null) {
          message = data['error'].toString();
        }
      }
    } else if (error.message != null) {
      message = error.message!;
    }

    return ApiExceptionMessage(message, statusCode: statusCode);
  }
}
