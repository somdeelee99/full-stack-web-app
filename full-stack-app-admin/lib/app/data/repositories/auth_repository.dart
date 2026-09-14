import '../../core/errors/app_exception.dart';
import '../api/api_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  // ລົງທະບຽນເຂົ້າໃຊ້ (Login)
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiService.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    if (response.statusCode == 200 && response.data != null) {
      final token = response.data['token'];
      final user = UserModel.fromJson(response.data['user']);

      // ບັນທຶກ Token
      await _apiService.setToken(token);

      return {'token': token, 'user': user};
    }

    throw AuthException.withDetails(
      'ການລົງທະບຽນເຂົ້າໃຊ້ລົ້ມເຫລວ',
      statusCode: response.statusCode,
      originalError: response.data,
      endpoint: 'POST /auth/login',
    );
  }

  // ອອກຈາກລະບົບ (Logout)
  Future<void> logout() async {
    try {
      await _apiService.post('/auth/logout');
    } finally {
      // ລຶບ Token ທຸກກໍລະນີ
      await _apiService.clearToken();
    }
  }

  // ດຶງຂໍ້ມູນຜູ້ໃຊ້ປັດຈຸບັນ
  Future<UserModel> getCurrentUser() async {
    final response = await _apiService.get('/auth/me');

    if (response.statusCode == 200 && response.data != null) {
      return UserModel.fromJson(response.data);
    }

    throw ParseException.withDetails(
      'ບໍ່ສາມາດດຶງຂໍ້ມູນຜູ້ໃຊ້ໄດ້',
      originalError: response.data,
      endpoint: 'GET /auth/me',
      context: {'statusCode': response.statusCode},
    );
  }

  // ກວດສອບການເຂົ້າໃຊ້
  Future<bool> isAuthenticated() async {
    return await _apiService.hasToken();
  }

  // ເປີຍນ Token
  Future<void> updateToken(String newToken) async {
    await _apiService.setToken(newToken);
  }
}
