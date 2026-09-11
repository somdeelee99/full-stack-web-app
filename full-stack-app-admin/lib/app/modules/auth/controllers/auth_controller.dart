import 'package:get/get.dart';

/// Authentication Controller
/// Handles login, logout, and authentication state management
class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString token = ''.obs;
  // final RxnMap user = RxnMap();
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    initAuth();
  }

  /// Initialize authentication from local storage
  void initAuth() {
    // TODO: Implement local storage retrieval
    // token.value = localStorage.getItem('admin_token') ?? '';
    // updateAuthState();
  }

  /// Login with email and password
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      // TODO: Call repository to login
      // final result = await Get.find<AuthRepository>().login(email, password);
      // token.value = result['token'];
      // user.value = result['user'];
      // updateAuthState();
      Get.offAllNamed('/dashboard');
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout and clear authentication
  void logout() {
    token.value = '';
    // user.value = null;
    isLoggedIn.value = false;
    // TODO: Clear local storage
    Get.offAllNamed('/login');
  }

  void updateAuthState() {
    isLoggedIn.value = token.value.isNotEmpty;
  }
}
