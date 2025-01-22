import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/plant_controller.dart';
import '../models/plant_model.dart';

class PlantDetailScreen extends StatelessWidget {
  final Plant plant;
  final PlantController plantController = Get.find<PlantController>();

  PlantDetailScreen({required this.plant, super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: plant.name);
    final TextEditingController descriptionController =
        TextEditingController(text: plant.description);
    final TextEditingController wateringIntervalController =
        TextEditingController(text: plant.wateringInterval.toString());

    return Scaffold(
      resizeToAvoidBottomInset: true, // 키보드가 올라올 때 화면이 깨지지 않도록 설정

      appBar: AppBar(
        title: Text(plant.name),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  final updatedPlant = Plant(
                    id: plant.id,
                    groupId: plant.groupId,
                    name: nameController.text,
                    description: descriptionController.text,
                    wateringInterval:
                        int.parse(wateringIntervalController.text),
                    lastWateredAt: plant.lastWateredAt,
                    createdAt: plant.createdAt,
                    photoUrl: plant.photoUrl,
                  );
                  plantController.updatePlant(plant.id, updatedPlant);
                  Get.back();
                },
                child: const Text('수정'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('식물 삭제'),
          content: const Text('정말로 이 식물을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                plantController.deletePlant(plant.id, plant.groupId);
                Get.back();
                Get.back(); // 상세 화면을 닫고 이전 화면으로 돌아갑니다.
              },
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }
}
