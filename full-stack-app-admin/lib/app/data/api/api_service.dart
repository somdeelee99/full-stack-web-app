import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// API Service ທີ່ໃຊ້ຮ່ວມກັບ full-stack-website (Nuxt.js)
/// Base URL: http://localhost:3001/api (ຕາມ nuxt.config.ts)
class ApiService extends GetConnect {
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String baseUrl = 'http://localhost:3001/api';

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // Interceptor ເພື່ອເພີ່ມ Token ໃນທຸກ request
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.read(key: 'admin_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Token ຫມົດອາຍຸ, ໃຫ້ logout
            Get.offAllNamed('/login');
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Generic GET method
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
      );
      return Response<T>(
        data: response.data,
        statusCode: response.statusCode,
        headers: Headers.fromMap(response.headers.map),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic POST method
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return Response<T>(
        data: response.data,
        statusCode: response.statusCode,
        headers: Headers.fromMap(response.headers.map),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic PUT method
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return Response<T>(
        data: response.data,
        statusCode: response.statusCode,
        headers: Headers.fromMap(response.headers.map),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic DELETE method
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return Response<T>(
        data: response.data,
        statusCode: response.statusCode,
        headers: Headers.fromMap(response.headers.map),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Upload file
  Future<Response<T>> upload<T>(
    String path,
    FormData formData, {
    void Function(int count, int total)? onSendProgress,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
      );
      return Response<T>(
        data: response.data,
        statusCode: response.statusCode,
        headers: Headers.fromMap(response.headers.map),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Handle error
  Exception _handleError(DioException e) {
    String message = 'ເກີດຂໍ້ຜິດພາດທີ່ບໍ່ຮູ້ສາເຫດ';

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = 'ການເຊື່ອມຕໍ່ຫມົດອາຍຸ';
        break;
      case DioExceptionType.sendTimeout:
        message = 'ການສົ່ງຂໍ້ມູນຫມົດອາຍຸ';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'ການຮັບຂໍ້ມູນຫມົດອາຍຸ';
        break;
      case DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 400:
            message = 'ຂໍ້ມູນບໍ່ຖືກຕ້ອງ';
            break;
          case 401:
            message = 'ບໍ່ມີສິດເຂົ້າໃຊ້';
            break;
          case 403:
            message = 'ບໍ່ມີສິດເຂົ້າເຖິງ';
            break;
          case 404:
            message = 'ບໍ່ພົບຂໍ້ມູນ';
            break;
          case 500:
            message = 'ເຊີບເວີມີບັນຫາ';
            break;
          default:
            message = e.response?.data['message'] ?? message;
        }
        break;
      case DioExceptionType.cancel:
        message = 'ການໂຫຼດຖືກຍົກເລີກ';
        break;
      default:
        message = 'ເກີດຂໍ້ຜິດພາດ: ${e.message}';
    }

    return Exception(message);
  }

  // ຕັ້ງຄ່າ Token
  Future<void> setToken(String token) async {
    await _secureStorage.write(key: 'admin_token', value: token);
  }

  // ລຶບ Token
  Future<void> clearToken() async {
    await _secureStorage.delete(key: 'admin_token');
  }

  // ກວດສອບວ່າມີ Token ຫຼືບໍ່
  Future<bool> hasToken() async {
    final token = await _secureStorage.read(key: 'admin_token');
    return token != null && token.isNotEmpty;
  }
}
