abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiExceptionMessage extends ApiException {
  ApiExceptionMessage(super.message, {super.statusCode});
}

class NoInternetConnection extends ApiException {
  NoInternetConnection([String? message])
      : super(message ?? 'No internet connection detected');
}

class InternalServerError extends ApiException {
  InternalServerError([String? message])
      : super(
          message ?? 'Internal server error. Please try again later.',
          statusCode: 500,
        );
}

class UnAuthorized extends ApiException {
  final dynamic response;

  UnAuthorized([this.response])
      : super(
          'Unauthorized access. Please sign in again.',
          statusCode: 401,
        );
}
