import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService extends GetxService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final String baseUrl = 'http://localhost:3001/api';

  ApiService() {
    _dio.options.baseUrl = baseUrl;
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
    } on DioException catch (e) {
      throw _handleError(e);
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
    } on DioException catch (e) {
      throw _handleError(e);
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
    } on DioException catch (e) {
      throw _handleError(e);
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
    } on DioException catch (e) {
      throw _handleError(e);
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
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    // ... ໂຄ້ດ _handleError ອັນເກົ່າຂອງເຈົ້າໃຊ້ໄດ້ເລີຍ
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

  Future<void> setToken(String token) async =>
      await _secureStorage.write(key: 'admin_token', value: token);
  Future<void> clearToken() async =>
      await _secureStorage.delete(key: 'admin_token');
  Future<bool> hasToken() async {
    final token = await _secureStorage.read(key: 'admin_token');
    return token != null && token.isNotEmpty;
  }
}
