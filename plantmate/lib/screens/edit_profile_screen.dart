import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthController authController = Get.find();
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    // 기존 사용자 정보 초기화
    nameController = TextEditingController(
      text: authController.user.value?.name ?? '',
    );
    emailController = TextEditingController(
      text: authController.user.value?.email ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원정보 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final user = authController.user.value;
          if (user == null) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
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
              // const Text('이메일', style: TextStyle(fontSize: 16)),
              // TextField(
              //   controller: emailController,
              //   decoration: const InputDecoration(
              //     hintText: '이메일을 입력하세요',
              //   ),
              // ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // 수정된 정보
                    final updatedName = nameController.text;
                    // final updatedEmail = emailController.text;

                    // 서버 요청
                    bool success = await authController.updateProfile(
                      id: user.id,
                      name: updatedName,
                      // email: updatedEmail,
                    );

                    if (success) {
                      Get.back();
                      Get.snackbar('성공', '회원정보가 수정되었습니다.',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(seconds: 1));
                    } else {
                      // Get.snackbar(
                      //   '실패',
                      //   '회원정보 수정에 실패했습니다.',
                      //   snackPosition: SnackPosition.BOTTOM,
                      // );
                    }
                  },
                  child: const Text('저장'),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
