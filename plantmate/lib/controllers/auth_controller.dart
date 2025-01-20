import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plantmate/models/user_model.dart';
import 'package:plantmate/services/auth_service.dart';

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
    print('로그인 시도: $email');

    try {
      final response = await authService.login(email, password);
      print('로그인 응답: ${response.body}');

      if (response.body == null) {
        Get.snackbar('Error', '서버 응답이 없습니다.');
        return;
      }

      if (response.statusCode == 200 && response.body['result'] == 'ok') {
        final accessToken = response.body['access_token'];
        final userData = response.body['user']; // 사용자 정보가 포함된다고 가정

        // 로컬 저장소에 액세스 토큰 저장
        storage.write('access_token', accessToken);
        storage.write('user', userData);
        user.value = User.fromJson(userData);

        isLoggedIn.value = true;

        Get.offAllNamed('/home'); // 홈 화면으로 이동
      } else {
        Get.snackbar('Error', response.body['message'] ?? '로그인 실패');
      }
    } catch (e) {
      print('로그인 오류: $e');
      Get.snackbar('Error', '서버 오류: $e');
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      final response = await authService.register(name, email, password);

      if (response.statusCode == 201 && response.body['result'] == 'ok') {
        Get.snackbar('Success', '회원가입 성공! 로그인 해주세요.');
        Get.offAllNamed('/login'); // 로그인 화면으로 이동
      } else {
        Get.snackbar('Error', response.body['message'] ?? '회원가입 실패');
      }
    } catch (e) {
      Get.snackbar('Error', '서버 오류: $e');
    }
  }

  Future<bool> updateProfile({required int id, required String name}) async {
    final response = await authService.updateProfile({
      'id': id,
      'name': name,
    });

    if (response.body['result'] == 'ok') {
      // 로컬 사용자 정보 업데이트
      user.value = User(
        id: id,
        name: name,
        email: user.value!.email,
        profileImage: user.value!.profileImage,
      );
      storage.write('user', user.value!.toJson());
      update(); // 상태 변경 알림

      return true;
    } else {
      return false;
    }
  }

  //회원 탈퇴
  Future<void> deleteUser() async {
    try {
      print('회원 탈퇴 시도: ${user.value!.id}');
      final response = await authService.deleteUser(user.value!.id);
      print('회원 탈퇴 응답 상태 코드: ${response.statusCode}');
      print('회원 탈퇴 응답 바디: ${response.body}');

      if (response.statusCode == 200 && response.body['result'] == 'ok') {
        // 로컬 사용자 정보 삭제
        storage.remove('user');
        user.value = null;
        Get.snackbar('Success', '회원 탈퇴가 완료되었습니다.');
        Get.offAllNamed('/login'); // 로그인 화면으로 이동
      } else {
        Get.snackbar('Error', response.body['message'] ?? '회원 탈퇴 실패');
      }
    } catch (e) {
      print('회원 탈퇴 오류: $e');
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
