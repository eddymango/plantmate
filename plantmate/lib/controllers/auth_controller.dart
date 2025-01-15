import 'package:get/get.dart';

import 'planmate_controller.dart';

class AuthController extends GetxController {
  RxBool isLoggedIn = false.obs;

  // 로그인 함수
  void login() {
    isLoggedIn.value = true;
    Get.find<PlantMateController>().resetToHome(); // Home 탭으로 초기화
  }

  // 로그아웃 함수
  void logout() {
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }
}
