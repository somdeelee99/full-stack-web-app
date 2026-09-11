class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AppException(this.message, {this.code, this.originalError});

  @override
  String toString() {
    if (code != null) {
      return 'AppException[$code]: $message';
    }
    return 'AppException: $message';
  }
}

class NetworkException extends AppException {
  NetworkException([String message = 'Network error occurred'])
      : super(message, code: 'NETWORK_ERROR');
}

class AuthException extends AppException {
  AuthException([String message = 'Authentication failed'])
      : super(message, code: 'AUTH_ERROR');
}

class ServerException extends AppException {
  ServerException([String message = 'Server error occurred'])
      : super(message, code: 'SERVER_ERROR');
}

class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  ValidationException([String message = 'Validation failed', this.errors])
      : super(message, code: 'VALIDATION_ERROR');
}

class NotFoundException extends AppException {
  NotFoundException([String message = 'Resource not found'])
      : super(message, code: 'NOT_FOUND');
}
