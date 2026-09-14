/// Base exception class for the whole app.
///
/// Every error thrown by the data layer should be an [AppException] subclass so
/// that controllers can:
///  - show a user-friendly message via [userMessage]
///  - log/troubleshoot via [toLogString] (code, status, endpoint, timestamp...)
///  - branch on error kind via [isNetworkError] / [isAuthError] / ... or by
///    catching a specific subclass.
class AppException implements Exception {
  /// User-facing message (already localized).
  final String message;

  /// Machine-readable error code, e.g. 'NETWORK_ERROR', 'AUTH_ERROR'.
  final String code;

  /// HTTP status code when the error came from an API response.
  final int? statusCode;

  /// HTTP method + endpoint that caused the error, e.g. 'GET /products'.
  final String? endpoint;

  /// The underlying error (DioException, FormatException, ...) if any.
  final dynamic originalError;

  /// Stack trace captured when the exception was created.
  final StackTrace? stackTrace;

  /// When the error occurred (local time) — useful when reading logs.
  final DateTime timestamp;

  /// Extra key/value pairs for troubleshooting (e.g. {'orderId': 42}).
  final Map<String, dynamic>? context;

  AppException(
    this.message, {
    required this.code,
    this.statusCode,
    this.endpoint,
    this.originalError,
    StackTrace? stackTrace,
    this.context,
  }) : stackTrace = stackTrace ?? StackTrace.current,
       timestamp = DateTime.now();

  // ---------------------------------------------------------------------------
  // Convenience getters for quick checks in controllers/UI
  // ---------------------------------------------------------------------------

  bool get isNetworkError =>
      this is NetworkException || this is TimeoutException;

  bool get isAuthError => this is AuthException;

  bool get isServerError => this is ServerException;

  bool get isValidationError => this is ValidationException;

  bool get isNotFoundError => this is NotFoundException;

  /// Whether the user session expired and should be redirected to login.
  bool get isSessionExpired =>
      this is AuthException && (statusCode == 401 || code == 'SESSION_EXPIRED');

  /// True when retrying the same request might succeed.
  bool get isRetryable => isNetworkError || isServerError || statusCode == 429;

  /// Message safe to show to the user (same as [message] by default).
  String get userMessage => message;

  /// Compact single-line description: `AppException[CODE]: message (500 · GET /products)`.
  @override
  String toString() {
    final buffer = StringBuffer('AppException[$code]: $message');
    if (statusCode != null || endpoint != null) {
      final parts = <String>[
        if (statusCode != null) '$statusCode',
        if (endpoint != null) endpoint!,
      ];
      buffer.write(' (${parts.join(' · ')})');
    }
    return buffer.toString();
  }

  /// Multi-line detail string for logs/crash reporting.
  String toLogString() {
    final buffer = StringBuffer()
      ..write('[$timestamp] $runtimeType')
      ..write('\n  code      : $code')
      ..write('\n  message   : $message');
    if (statusCode != null) buffer.write('\n  status    : $statusCode');
    if (endpoint != null) buffer.write('\n  endpoint  : $endpoint');
    if (context != null && context!.isNotEmpty) {
      buffer.write('\n  context   : $context');
    }
    if (originalError != null) {
      buffer.write('\n  original  : $originalError');
    }
    if (stackTrace != null) {
      buffer.write('\n  stackTrace:\n$stackTrace');
    }
    return buffer.toString();
  }
}

// =============================================================================
// Concrete exception types
// =============================================================================

/// No/lost internet connection, DNS failure, socket error.
class NetworkException extends AppException {
  NetworkException([
    String message = 'ບໍ່ມີການເຊື່ອມຕໍ່ອິນເຕີເນັດ',
  ]) : super(message, code: 'NETWORK_ERROR');

  NetworkException.withDetails(
    String message, {
    dynamic originalError,
    String? endpoint,
    StackTrace? stackTrace,
  }) : super(
          message,
          code: 'NETWORK_ERROR',
          originalError: originalError,
          endpoint: endpoint,
          stackTrace: stackTrace,
        );
}

/// Request timed out (connect/send/receive/transform).
class TimeoutException extends AppException {
  TimeoutException([
    String message = 'ການເຊື່ອມຕໍ່ໝົດອາຍຸ',
  ]) : super(message, code: 'TIMEOUT_ERROR');

  TimeoutException.withDetails(
    String message, {
    dynamic originalError,
    String? endpoint,
    StackTrace? stackTrace,
  }) : super(
          message,
          code: 'TIMEOUT_ERROR',
          originalError: originalError,
          endpoint: endpoint,
          stackTrace: stackTrace,
        );
}

/// Request was cancelled before completing.
class CancelException extends AppException {
  CancelException([
    String message = 'ການໂຫຼດຖືກຍົກເລີກ',
  ]) : super(message, code: 'REQUEST_CANCELLED');

  CancelException.withDetails(
    String message, {
    dynamic originalError,
    String? endpoint,
    StackTrace? stackTrace,
  }) : super(
          message,
          code: 'REQUEST_CANCELLED',
          originalError: originalError,
          endpoint: endpoint,
          stackTrace: stackTrace,
        );
}

/// Authentication failed: bad credentials (401), expired token, no permission.
class AuthException extends AppException {
  AuthException([
    String message = 'ການຢືນຢັນຕົວຕົນລົ້ມເຫລວ',
  ]) : super(message, code: 'AUTH_ERROR');

  AuthException.withDetails(
    String message, {
    int? statusCode,
    dynamic originalError,
    String? endpoint,
    StackTrace? stackTrace,
  }) : super(
          message,
          code: 'AUTH_ERROR',
          statusCode: statusCode,
          originalError: originalError,
          endpoint: endpoint,
          stackTrace: stackTrace,
        );
}

/// 4xx client errors that don't fit a more specific type.
class BadRequestException extends AppException {
  BadRequestException([
    String message = 'ຂໍ້ມູນບໍ່ຖືກຕ້ອງ',
  ]) : super(message, code: 'BAD_REQUEST');

  BadRequestException.withDetails(
    String message, {
    int? statusCode,
    dynamic originalError,
    String? endpoint,
    StackTrace? stackTrace,
  }) : super(
          message,
          code: 'BAD_REQUEST',
          statusCode: statusCode,
          originalError: originalError,
          endpoint: endpoint,
          stackTrace: stackTrace,
        );
}

/// 403 - authenticated but not allowed.
class ForbiddenException extends AppException {
  ForbiddenException([
    String message = 'ບໍ່ມີສິດເຂົ້າເຖິງ',
  ]) : super(message, code: 'FORBIDDEN', statusCode: 403);

  ForbiddenException.withDetails(
    String message, {
    dynamic originalError,
    String? endpoint,
    StackTrace? stackTrace,
  }) : super(
          message,
          code: 'FORBIDDEN',
          statusCode: 403,
          originalError: originalError,
          endpoint: endpoint,
          stackTrace: stackTrace,
        );
}

/// Resource not found (404 or empty result).
class NotFoundException extends AppException {
  NotFoundException([
    String message = 'ບໍ່ພົບຂໍ້ມູນ',
  ]) : super(message, code: 'NOT_FOUND', statusCode: 404);

  NotFoundException.withDetails(
    String message, {
    dynamic originalError,
    String? endpoint,
    StackTrace? stackTrace,
  }) : super(
          message,
          code: 'NOT_FOUND',
          statusCode: 404,
          originalError: originalError,
          endpoint: endpoint,
          stackTrace: stackTrace,
        );
}

/// Request body failed server-side validation — carries per-field errors.
class ValidationException extends AppException {
  /// Field-level errors from the API, e.g. {'email': ['already taken']}.
  final Map<String, dynamic>? errors;

  ValidationException([
    String message = 'ຂໍ້ມູນບໍ່ຜ່ານການກວດສອບ',
    this.errors,
  ]) : super(message, code: 'VALIDATION_ERROR', statusCode: 422);

  ValidationException.withDetails(
    String message, {
    this.errors,
    dynamic originalError,
    String? endpoint,
    StackTrace? stackTrace,
  }) : super(
          message,
          code: 'VALIDATION_ERROR',
          statusCode: 422,
          originalError: originalError,
          endpoint: endpoint,
          stackTrace: stackTrace,
        );

  /// Joined message for all field errors, handy for snackbars.
  String? get errorsSummary {
    if (errors == null || errors!.isEmpty) return null;
    return errors!.values
        .expand((value) => value is List ? value : [value])
        .join('\n');
  }
}

/// 5xx — server-side failure.
class ServerException extends AppException {
  ServerException([
    String message = 'ເຊີບເວີມີບັນຫາ',
  ]) : super(message, code: 'SERVER_ERROR');

  ServerException.withDetails(
    String message, {
    int? statusCode,
    dynamic originalError,
    String? endpoint,
    StackTrace? stackTrace,
  }) : super(
          message,
          code: 'SERVER_ERROR',
          statusCode: statusCode,
          originalError: originalError,
          endpoint: endpoint,
          stackTrace: stackTrace,
        );
}

/// Response was received but couldn't be parsed/validated by the repository.
class ParseException extends AppException {
  ParseException([
    String message = 'ຂໍ້ມູນຈາກເຊີບເວີບໍ່ຖືກຕ້ອງຮູບແບບ',
  ]) : super(message, code: 'PARSE_ERROR');

  ParseException.withDetails(
    String message, {
    dynamic originalError,
    String? endpoint,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) : super(
          message,
          code: 'PARSE_ERROR',
          originalError: originalError,
          endpoint: endpoint,
          stackTrace: stackTrace,
          context: context,
        );
}

/// Fallback for anything not covered above.
class UnknownException extends AppException {
  UnknownException([
    String message = 'ເກີດຂໍ້ຜິດພາດທີ່ບໍ່ຮູ້ຈັກ',
  ]) : super(message, code: 'UNKNOWN_ERROR');

  UnknownException.withDetails(
    String message, {
    dynamic originalError,
    String? endpoint,
    StackTrace? stackTrace,
  }) : super(
          message,
          code: 'UNKNOWN_ERROR',
          originalError: originalError,
          endpoint: endpoint,
          stackTrace: stackTrace,
        );
}
