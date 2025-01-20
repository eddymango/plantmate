import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

class SignupScreen extends StatelessWidget {
  final AuthController authController = Get.find();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('이름', style: TextStyle(fontSize: 16)),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: '이름름 입력'),
              ),
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
              const Text('비밀번호 확인', style: TextStyle(fontSize: 16)),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: '비밀번호 확인 입력'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // 회원가입 처리 로직 추가
                  // 예: 이메일과 비밀번호 저장 후 로그인 화면으로 이동
                  final name = nameController.text.trim();
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();

                  if (name.isNotEmpty &&
                      email.isNotEmpty &&
                      password.isNotEmpty) {
                    authController.register(name, email, password);
                  } else {
                    Get.snackbar('Error', '모든 필드를 입력해주세요.');
                  }

                  Navigator.pop(context); // 로그인 화면으로 돌아가기
                },
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
