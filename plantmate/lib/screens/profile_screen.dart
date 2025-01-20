import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plantmate/controllers/auth_controller.dart';

import '../models/user_model.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find();
  final GetStorage storage = GetStorage();

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantmate'),
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
              // 사용자 프로필 섹션
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: user.profileImage.isNotEmpty
                          ? NetworkImage(user.profileImage)
                          : const AssetImage(
                                  'assets/images/default_profile_image.jpg')
                              as ImageProvider,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name, // 사용자 이름 표시
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email, // 사용자 이메일 표시
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 설정 메뉴 리스트
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('내 정보 수정'),
                onTap: () {
                  // 내 정보 수정 화면으로 이동
                  Get.to(() => EditProfileScreen());
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('로그아웃'),
                onTap: () {
                  // 로그아웃 처리
                  authController.logout();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('회원 탈퇴'),
                onTap: () {
                  // 회원 탈퇴 처리
                  authController.deleteUser();
                },
              ),
              const Divider(),
            ],
          );
        }),
      ),
    );
  }
}
