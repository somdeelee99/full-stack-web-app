import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/constants/api_constants.dart';
import '../../core/errors/app_exception.dart';

class ApiService extends GetxService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ApiService() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.read(key: 'admin_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            Get.offAllNamed('/login');
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e, s) {
      throw _mapDioError(e, 'GET $path', s);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e, s) {
      throw _mapDioError(e, 'POST $path', s);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e, s) {
      throw _mapDioError(e, 'PUT $path', s);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e, s) {
      throw _mapDioError(e, 'DELETE $path', s);
    }
  }

  Future<Response<T>> upload<T>(
    String path,
    FormData formData, {
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e, s) {
      throw _mapDioError(e, 'UPLOAD $path', s);
    }
  }

  // ===========================================================================
  // Error mapping
  // ===========================================================================

  /// Never returns a raw [Exception] — always a typed [AppException] subclass
  /// carrying statusCode / endpoint / originalError so upstream layers can log
  /// and display meaningful information.
  AppException _mapDioError(DioException e, String endpoint, StackTrace stack) {
    final response = e.response;

    switch (e.type) {
      // ---------------------------------------------------------------------
      // Connectivity problems
      // ---------------------------------------------------------------------
      case DioExceptionType.connectionError:
        return NetworkException.withDetails(
          'ບໍ່ມີການເຊື່ອມຕໍ່ອິນເຕີເນັດ',
          originalError: e,
          endpoint: endpoint,
          stackTrace: stack,
        );

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return TimeoutException.withDetails(
          'ການເຊື່ອມຕໍ່ໝົດອາຍຸ',
          originalError: e,
          endpoint: endpoint,
          stackTrace: stack,
        );

      case DioExceptionType.cancel:
        return CancelException.withDetails(
          'ການໂຫຼດຖືກຍົກເລີກ',
          originalError: e,
          endpoint: endpoint,
          stackTrace: stack,
        );

      // ---------------------------------------------------------------------
      // Server responded with an error status
      // ---------------------------------------------------------------------
      case DioExceptionType.badResponse:
        final statusCode = response?.statusCode;
        final serverMessage = _extractServerMessage(response);

        switch (statusCode) {
          case 400:
            return BadRequestException.withDetails(
              serverMessage ?? 'ຂໍ້ມູນບໍ່ຖືກຕ້ອງ',
              statusCode: statusCode,
              originalError: e,
              endpoint: endpoint,
              stackTrace: stack,
            );
          case 401:
            return AuthException.withDetails(
              serverMessage ?? 'ບໍ່ມີສິດເຂົ້າໃຊ້',
              statusCode: statusCode,
              originalError: e,
              endpoint: endpoint,
              stackTrace: stack,
            );
          case 403:
            return ForbiddenException.withDetails(
              serverMessage ?? 'ບໍ່ມີສິດເຂົ້າເຖິງ',
              originalError: e,
              endpoint: endpoint,
              stackTrace: stack,
            );
          case 404:
            return NotFoundException.withDetails(
              serverMessage ?? 'ບໍ່ພົບຂໍ້ມູນ',
              originalError: e,
              endpoint: endpoint,
              stackTrace: stack,
            );
          case 422:
            return ValidationException.withDetails(
              serverMessage ?? 'ຂໍ້ມູນບໍ່ຜ່ານການກວດສອບ',
              errors: _extractValidationErrors(response),
              originalError: e,
              endpoint: endpoint,
              stackTrace: stack,
            );
          default:
            if (statusCode != null && statusCode >= 500) {
              return ServerException.withDetails(
                serverMessage ?? 'ເຊີບເວີມີບັນຫາ',
                statusCode: statusCode,
                originalError: e,
                endpoint: endpoint,
                stackTrace: stack,
              );
            }
            return BadRequestException.withDetails(
              serverMessage ?? 'ເກີດຂໍ້ຜິດພາດ (HTTP $statusCode)',
              statusCode: statusCode,
              originalError: e,
              endpoint: endpoint,
              stackTrace: stack,
            );
        }

      // ---------------------------------------------------------------------
      // Anything else (badCertificate, unknown, ...)
      // ---------------------------------------------------------------------
      case DioExceptionType.badCertificate:
        return UnknownException.withDetails(
          'ໃບຮັບຮອງຄວາມປອດໄພຂອງເຊີບເວີບໍ່ຖືກຕ້ອງ',
          originalError: e,
          endpoint: endpoint,
          stackTrace: stack,
        );

      case DioExceptionType.unknown:
        // Often wraps another error (e.g. SocketException).
        if (e.error != null) {
          return NetworkException.withDetails(
            'ບໍ່ມີການເຊື່ອມຕໍ່ອິນເຕີເນັດ',
            originalError: e,
            endpoint: endpoint,
            stackTrace: stack,
          );
        }
        return UnknownException.withDetails(
          'ເກີດຂໍ້ຜິດພາດທີ່ບໍ່ຮູ້ຈັກ',
          originalError: e,
          endpoint: endpoint,
          stackTrace: stack,
        );
    }
  }

  /// Try to pull a human-readable message out of common API error shapes:
  /// `{'message': '...'}`, `{'error': '...'}` or a plain string body.
  String? _extractServerMessage(Response? response) {
    final data = response?.data;
    if (data == null) return null;
    if (data is String && data.trim().isNotEmpty && data.length < 200) {
      return data;
    }
    if (data is Map) {
      final message = data['message'] ?? data['error'];
      if (message is String && message.trim().isNotEmpty) return message;
    }
    return null;
  }

  /// Extract field-level errors commonly returned with 422:
  /// `{'errors': {'email': ['taken'], 'name': ['required']}}`.
  Map<String, dynamic>? _extractValidationErrors(Response? response) {
    final data = response?.data;
    if (data is Map) {
      final errors = data['errors'];
      if (errors is Map) {
        return errors.map((k, v) => MapEntry(k.toString(), v));
      }
    }
    return null;
  }

  Future<void> setToken(String token) async =>
      await _secureStorage.write(key: 'admin_token', value: token);
  Future<void> clearToken() async =>
      await _secureStorage.delete(key: 'admin_token');
  Future<bool> hasToken() async {
    final token = await _secureStorage.read(key: 'admin_token');
    return token != null && token.isNotEmpty;
  }
}
