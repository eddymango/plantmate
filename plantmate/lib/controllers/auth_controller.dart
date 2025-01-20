import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plantmate/models/user_model.dart';
import 'package:plantmate/services/auth_service.dart';

import 'plantmate_controller.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs; //로그인 상태 관리
  var user = Rxn<User>(); // 사용자 정보 관리
  final GetStorage storage = GetStorage();
  final AuthService authService = Get.put(AuthService());

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  // 로컬 저장소에서 사용자 정보 로드
  void _loadUserFromStorage() {
    final storedUser = storage.read('user');
    if (storedUser != null) {
      user.value = User.fromJson(storedUser);
      isLoggedIn.value = true;
    }
  }

  // 로그인 함수
  Future<void> login(String email, String password) async {
    try {
      final response = await authService.login(email, password);

      if (response.statusCode == 200 && response.body['status'] == 'ok') {
        final userData = response.body['data'];
        final loggedInUser = User.fromJson(userData);

        // 로컬 저장소에 사용자 정보 저장
        storage.write('user', loggedInUser.toJson());
        user.value = loggedInUser;
        isLoggedIn.value = true;

        Get.offAllNamed('/home'); // 홈 화면으로 이동
      } else {
        Get.snackbar('Error', response.body['message'] ?? '로그인 실패');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      final response = await authService.register(name, email, password);

      if (response.statusCode == 201 && response.body['status'] == 'ok') {
        Get.snackbar('Success', '회원가입 성공! 로그인 해주세요.');
        Get.offAllNamed('/login'); // 로그인 화면으로 이동
      } else {
        Get.snackbar('Error', response.body['message'] ?? '회원가입 실패');
      }
    } catch (e) {
      Get.snackbar('Error', '서버 오류: $e');
    }
  }

  // 로그아웃 함수
  void logout() {
    storage.remove('user'); // 로컬 저장소에서 사용자 정보 삭제
    user.value = null;

    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }
}
