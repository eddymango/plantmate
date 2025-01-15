import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantmate/controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantmate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용자 프로필 섹션
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage('assets/images/default_profile_image.jpg'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '홍길동',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'honggildong@example.com',
                    style: TextStyle(
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
              onTap: () {},
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
