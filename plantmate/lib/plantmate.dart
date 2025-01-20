import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantmate/controllers/plantmate_controller.dart';
import 'package:plantmate/screens/group_screen.dart';
import 'package:plantmate/screens/home_screen.dart';
import 'package:plantmate/screens/profile_screen.dart';

final List<BottomNavigationBarItem> tabs = <BottomNavigationBarItem>[
  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
  BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
  BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
];

final List<Widget> myTabItems = [
  HomeScreen(),
  GroupScreen(),
  ProfileScreen(),
];

class PlantMateApp extends StatefulWidget {
  const PlantMateApp({super.key});

  @override
  State<PlantMateApp> createState() => _PlantMateAppState();
}

class _PlantMateAppState extends State<PlantMateApp> {
  @override
  Widget build(BuildContext context) {
    final PlantMateController controller = Get.find();
    return Obx(() => Scaffold(
          body: myTabItems[controller.selectedIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            items: tabs,
            currentIndex: controller.selectedIndex.value,
            onTap: controller.onItemTapped,
          ),
        ));
  }
}
