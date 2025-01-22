import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find(); // AuthController 가져오기

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('이메일', style: TextStyle(fontSize: 16)),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: '이메일 입력'),
            ),
            const SizedBox(height: 16),
            const Text('비밀번호', style: TextStyle(fontSize: 16)),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: '비밀번호 입력'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 로그인 처리 - 임시로 로그인되게 만들었음음
                authController.login(
                    emailController.text, passwordController.text);
                // Get.offAll(() => const PlantMateApp()); // 메인 화면으로 이동
              },
              child: const Text('로그인'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // 회원가입 화면으로 이동
                Get.to(() => SignupScreen());
              },
              child: const Text('회원가입', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
