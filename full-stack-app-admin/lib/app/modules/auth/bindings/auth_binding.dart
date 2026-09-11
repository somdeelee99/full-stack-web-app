import 'package:get/get.dart';
import 'package:shopadmin/app/data/repositories/auth_repository.dart';
import 'package:shopadmin/app/modules/auth/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository(Get.find()));
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
