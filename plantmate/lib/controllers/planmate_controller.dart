import 'dart:developer';
import 'package:get/get.dart';

//bottom navigation bar controller - GetX
class PlantMateController extends GetxController {
  var selectedIndex = 0.obs;

  void onItemTapped(int index) {
    log("index: $index");
    selectedIndex.value = index;
  }

  void resetToHome() {
    selectedIndex.value = 0; // Home 탭으로 초기화
  }
}
