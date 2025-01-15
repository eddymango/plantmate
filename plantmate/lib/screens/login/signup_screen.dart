import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
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
                Navigator.pop(context); // 로그인 화면으로 돌아가기
              },
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
