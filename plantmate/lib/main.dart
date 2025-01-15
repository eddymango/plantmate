import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'controllers/planmate_controller.dart';
import 'plantmate.dart';
import 'screens/login/login_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  Get.put(PlantMateController());
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plantmate',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()), // 초기 화면
        GetPage(name: '/login', page: () => LoginScreen()), // 로그인 화면
        GetPage(name: '/home', page: () => PlantMateApp()), // 메인 화면
      ],

      // home: SplashScreen(), // 초기 화면을 SplashScreen으로 설정
    );
  }
}
