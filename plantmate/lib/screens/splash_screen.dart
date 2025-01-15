import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class SplashScreen extends StatelessWidget {
  final AuthController authController = Get.find(); // AuthController 가져오기
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _navigateBasedOnAuth(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return Container(); // 실제 화면으로 이동하므로 빈 화면
            }
          },
        ),
      ),
    );
  }

  Future<void> _navigateBasedOnAuth() async {
    await Future.delayed(const Duration(seconds: 2)); // 로딩 시간
    if (authController.isLoggedIn.value) {
      Get.offAllNamed('/home'); // 메인 화면으로 이동
    } else {
      Get.offAllNamed('/login'); // 로그인 화면으로 이동
    }
  }
}
