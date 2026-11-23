import 'dart:convert';
import 'package:dio/dio.dart';

class ApiLoggerInterceptor extends Interceptor {
  static const String _tag = '[API]';
  static const String _divider = '═══════════════════════════════════════════════════════════════';

  void _log([String line = '']) {
    // ignore: avoid_print
    print('$_tag $line');
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log();
    _log('╔╣ Request ║ ${options.method.toUpperCase()}');
    _log('║  ${options.uri}');
    _log('╚$_divider');

    // Headers block
    _log('╔  Headers');
    options.headers.forEach((key, value) {
      if (key.toLowerCase() == 'authorization' && value is String && value.length > 40) {
        _log('╠  $key:');
        _log('║  $value');
      } else {
        _log('╠  $key: $value');
      }
    });
    _log('╠  contentType: ${options.contentType}');
    _log('╠  responseType: ${options.responseType}');
    _log('╠  followRedirects: ${options.followRedirects}');
    _log('╠  connectTimeout: ${options.connectTimeout}');
    _log('╠  receiveTimeout: ${options.receiveTimeout}');
    _log('╚$_divider');

    // Body block if present
    if (options.data != null) {
      _log('╔  Body');
      _formatBody(options.data);
      _log('╚$_divider');
    }

    _log();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log();
    final statusMsg = response.statusMessage ?? (response.statusCode == 200 ? 'OK' : '');
    _log('╔╣ Response ║ ${response.requestOptions.method.toUpperCase()} ║ Status: ${response.statusCode} $statusMsg');
    _log('║  ${response.requestOptions.uri}');
    _log('╚$_divider');

    if (response.data != null) {
      _log('╔  Body');
      _formatBody(response.data);
      _log('╚$_divider');
    }

    _log();
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log();
    final method = err.requestOptions.method.toUpperCase();
    final status = err.response?.statusCode ?? 'ERROR';
    _log('╔╣ Error ║ $method ║ Status: $status');
    _log('║  ${err.requestOptions.uri}');
    _log('╚$_divider');

    _log('╔  Error Details');
    _log('║  Type: ${err.type}');
    _log('║  Message: ${err.message}');
    if (err.response?.data != null) {
      _log('╠  Response Body:');
      _formatBody(err.response?.data);
    }
    _log('╚$_divider');
    _log();

    super.onError(err, handler);
  }

  void _formatBody(dynamic data) {
    if (data is Map || data is List) {
      try {
        const encoder = JsonEncoder.withIndent('    ');
        final pretty = encoder.convert(data);
        for (final line in pretty.split('\n')) {
          _log('║  $line');
        }
      } catch (_) {
        _log('║  $data');
      }
    } else {
      _log('║  $data');
    }
  }
}
