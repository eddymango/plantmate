import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../controllers/group_controller.dart';
import '../controllers/plant_controller.dart';
import '../models/plant_model.dart';
import '../widgets/plant_card.dart';
import '../widgets/stat_card.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GroupController groupController = Get.put(GroupController());

  final PlantController plantController = Get.put(PlantController());
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    // 첫 번째 그룹의 식물 목록을 자동으로 받아오기 위해 fetchGroups 호출
    groupController.fetchGroups();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //new line

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
                setState(() {
                  groupController.selectedGroup.value = value.toString();
                  final selectedGroup = groupController.myGroups.firstWhere(
                    (group) => group['name'] == value,
                  );
                  plantController.plants.clear();

                  plantController.fetchPlantsForGroup(selectedGroup['id']);
                });
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
        child: Obx(() {
          if (groupController.myGroups.isEmpty) {
            return Center(
              child: Text(
                '가입된 그룹이 없습니다.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else {
            return SingleChildScrollView(
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
                    child: plantController.plants.isEmpty
                        ? Center(
                            child: Text(
                              '이 그룹에 속한 식물이 없습니다.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: plantController.plants.length,
                            itemBuilder: (context, index) {
                              final plant = plantController.plants[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: PlantCard(
                                  key: ValueKey(plant.id), // 고유한 키 설정  오른른

                                  plant: plant,
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: '오늘 물 줄 식물',
                          value: plantController
                              .getTodayWateringCount()
                              .toString(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatCard(
                          label: '총 식물 수',
                          value:
                              plantController.getTotalPlantCount().toString(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          // 식물 추가 화면으로 이동 또는 다이얼로그 표시
          _showAddPlantDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddPlantDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController wateringIntervalController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('식물 추가'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: '식물 이름'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: '식물 설명'),
                ),
                TextField(
                  controller: wateringIntervalController,
                  decoration: const InputDecoration(labelText: '물주기 주기 (일)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('이미지 선택'),
                ),
                if (_selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    // child: Image.file(
                    //   _selectedImage!,
                    //   height: 100,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  final selectedGroup = groupController.myGroups.firstWhere(
                    (group) =>
                        group['name'] == groupController.selectedGroup.value,
                  );
                  final now = DateTime.now();
                  final formattedLastWateredAt =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                  final plant = Plant(
                    id: 0, // 임시 ID, 실제로는 서버에서 생성됨
                    groupId: selectedGroup['id'],
                    name: nameController.text,
                    description: descriptionController.text,
                    wateringInterval:
                        int.parse(wateringIntervalController.text),
                    lastWateredAt: formattedLastWateredAt, // 현재 시간으로 설정
                    createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
                    photoUrl: _selectedImage?.path ?? '',
                  );
                  plantController.addPlant(plant, _selectedImage).then((_) {
                    Get.back();
                  });
                  Get.back();
                },
                child: const Text('추가'),
              ),
            ],
          );
        });
      },
    );
  }
}
