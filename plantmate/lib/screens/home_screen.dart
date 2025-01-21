import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/group_controller.dart';
import '../widgets/plant_card.dart';
import '../widgets/stat_card.dart';

class HomeScreen extends StatelessWidget {
  final GroupController groupController = Get.put(GroupController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantmate'),
        actions: [
          Obx(() {
            return DropdownButton(
              value: groupController.selectedGroup.value.isNotEmpty
                  ? groupController.selectedGroup.value
                  : (groupController.myGroups.isNotEmpty
                      ? groupController.myGroups[0]['name']
                      : null),
              onChanged: (value) {
                groupController.selectedGroup.value = value.toString();
              },
              items: groupController.myGroups.map((group) {
                return DropdownMenuItem(
                  value: group['name'],
                  child: Text(group['name']),
                );
              }).toList(),
            );
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "식물 목록",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 360,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  PlantCard(
                    name: '몬스테라',
                    lastWateredDate: '2024.01.12',
                    nextWatering: 'D-2',
                  ),
                  SizedBox(width: 16),
                  PlantCard(
                    name: '스투키',
                    lastWateredDate: '2024.01.10',
                    nextWatering: 'D-5',
                  ),
                  const SizedBox(width: 16),
                  PlantCard(
                      name: '스투키',
                      lastWateredDate: '2024.01.10',
                      nextWatering: 'D-20'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: const [
                Expanded(
                  child: StatCard(label: '오늘 물 줄 식물', value: '2'),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(label: '총 식물 수', value: '5'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
