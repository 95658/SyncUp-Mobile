import 'package:dio/dio.dart';

class ResponseClient<T> {
  final bool isSuccess;
  final bool isError;
  final String message;
  final T? data;
  final int? statusCode;

  ResponseClient(Response? response)
      : statusCode = response?.statusCode,
        isSuccess = response != null &&
            (response.statusCode ?? 0) >= 200 &&
            (response.statusCode ?? 0) < 300,
        isError = response == null ||
            (response.statusCode ?? 0) < 200 ||
            (response.statusCode ?? 0) >= 300,
        message = _extractMessage(response),
        data = _extractData<T>(response);

  static String _extractMessage(Response? res) {
    if (res == null) return 'Something went wrong';
    final data = res.data;
    if (data is Map) {
      if (data['message'] != null) {
        if (data['message'] is List) {
          return (data['message'] as List).join(', ');
        }
        return data['message'].toString();
      }
      if (data['error'] != null) return data['error'].toString();
    }
    return res.statusMessage ?? 'Something went wrong';
  }

  static T? _extractData<T>(Response? res) {
    if (res == null) return null;
    final body = res.data;
    if (body is Map && body.containsKey('data')) {
      return body['data'] as T?;
    }
    return body as T?;
  }
}
