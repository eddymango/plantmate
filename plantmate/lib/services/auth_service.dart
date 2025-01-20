import 'package:get/get.dart';

class AuthService extends GetConnect {
  //api baseurl 수정필요
  final String baseUrl = 'http://localhost:3000';
  var isLoggined = false.obs;

  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    httpClient.timeout = const Duration(seconds: 30); // 타임아웃 설정
    super.onInit();
  }

  // 로그인 API 호출  api url 수정필요
  // 로그인 요청
  Future<Response> login(String email, String password) async {
    final response =
        await post('/user/login', {'email': email, 'password': password});
    return response;
  }

  // 회원가입 요청
  Future<Response> register(String name, String email, String password) async {
    return await post(
      '/user/register',
      {'name': name, 'email': email, 'password': password},
    );
  }

  Future<Response> updateProfile(Map<String, dynamic> data) async {
    final response = await put(
      '/user/profile', // 실제 API 엔드포인트로 변경
      data,
    );
    return response;
  }

  Future<Response> deleteUser() async {
    final response = await delete('/user/delete'); // 실제 API 엔드포인트로 변경
    return response;
  }
}

// 회원 정보 가져오기

void logout() {
  Get.snackbar('Success', '로그아웃 되었습니다.');
  Get.offAllNamed('/login');
}
