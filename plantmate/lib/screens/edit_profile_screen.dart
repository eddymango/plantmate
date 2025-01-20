import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class EditProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find();

  EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 기존 사용자 정보
    final TextEditingController nameController = TextEditingController(
      text: authController.user.value!.name,
    );
    final TextEditingController emailController = TextEditingController(
      text: authController.user.value!.email,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원정보 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('이름', style: TextStyle(fontSize: 16)),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: '이름을 입력하세요',
              ),
            ),
            const SizedBox(height: 16),
            const Text('이메일', style: TextStyle(fontSize: 16)),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: '이메일을 입력하세요',
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // 수정된 정보
                  final updatedName = nameController.text;
                  final updatedEmail = emailController.text;

                  // 서버 요청
                  bool success = await authController.updateProfile(
                    name: updatedName,
                    email: updatedEmail,
                  );

                  if (success) {
                    Get.back();
                    Get.snackbar(
                      '성공',
                      '회원정보가 수정되었습니다.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    Get.snackbar(
                      '실패',
                      '회원정보 수정에 실패했습니다.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: const Text('저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
