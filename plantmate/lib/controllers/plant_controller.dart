import 'package:get/get.dart';
import 'package:plantmate/controllers/auth_controller.dart';
import 'package:plantmate/models/plant_model.dart';
import '../services/plant_service.dart';
import 'dart:convert';

class PlantController extends GetxController {
  var plants = <Plant>[].obs; // 선택된 그룹의 식물 목록

  final PlantService plantService = Get.put(PlantService());
  final AuthController authController = Get.find<AuthController>();

  // 오늘 물 줄 식물의 수 계산 (D-0부터 D+1까지 포함)
  int getTodayWateringCount() {
    final today = DateTime.now();
    return plants.where((plant) {
      if (plant.lastWateredAt.isEmpty) return false;
      final lastWateredDate = DateTime.parse(plant.lastWateredAt);
      final nextWateringDate =
          lastWateredDate.add(Duration(days: plant.wateringInterval));
      final daysDifference = nextWateringDate.difference(today).inDays;
      return daysDifference >= -100 && daysDifference <= 0;
    }).length;
  }

  // 총 식물의 수 계산
  int getTotalPlantCount() {
    return plants.length;
  }

  // 그룹의 식물 목록 가져오기
  void fetchPlantsForGroup(int groupId) async {
    try {
      final response = await plantService.getPlantsForGroup(groupId);
      if (response.statusCode == 200 && response.body['result'] == 'ok') {
        plants.value = (response.body['data'] as List)
            .map((plant) => Plant.fromJson(plant))
            .toList();
        sortPlantsByWateringDate();
      } else {
        plants.value = [];
        Get.snackbar('Error', '식물 데이터를 가져오는데 실패했습니다.');
      }
    } catch (e) {
      Get.snackbar('Error', '서버 오류: $e');
    }
  }

  // 식물 목록을 물 주기 순서대로 정렬
  void sortPlantsByWateringDate() {
    plants.sort((a, b) {
      final aNextWateringDate = DateTime.parse(a.lastWateredAt)
          .add(Duration(days: a.wateringInterval));
      final bNextWateringDate = DateTime.parse(b.lastWateredAt)
          .add(Duration(days: b.wateringInterval));
      return aNextWateringDate.compareTo(bNextWateringDate);
    });
  }

  // 식물 추가
  void addPlant(Plant plant) async {
    try {
      final response = await plantService.addPlant(plant);
      if (response.statusCode == 200 && response.body['result'] == 'ok') {
        Get.snackbar('Success', '식물이 추가되었습니다.');
        fetchPlantsForGroup(plant.groupId); // 그룹의 식물 목록 다시 가져오기
      } else {
        Get.snackbar('Error', response.body['message'] ?? '식물 추가 실패');
      }
    } catch (e) {
      Get.snackbar('Error', '서버 오류: $e');
    }
  }

  // 식물 수정
  void updatePlant(int plantId, Plant plant) async {
    try {
      final response = await plantService.updatePlant(plantId, plant);
      if (response.statusCode == 200 && response.body['result'] == 'ok') {
        Get.snackbar('Success', '식물이 수정되었습니다.');
        fetchPlantsForGroup(plant.groupId);
      } else {
        Get.snackbar('Error', response.body['message'] ?? '식물 수정 실패');
      }
    } catch (e) {
      Get.snackbar('Error', '서버 오류: $e');
    }
  }

  // 식물 삭제
  void deletePlant(int plantId, int groupId) async {
    try {
      final response = await plantService.deletePlant(plantId);
      if (response.statusCode == 200 && response.body['result'] == 'ok') {
        Get.snackbar('Success', '식물이 삭제되었습니다.');
        fetchPlantsForGroup(groupId);
      } else {
        Get.snackbar('Error', response.body['message'] ?? '식물 삭제 실패');
      }
    } catch (e) {
      Get.snackbar('Error', '서버 오류: $e');
    }
  }

  // 식물 조회
  Future<Plant?> getPlant(int plantId) async {
    try {
      final response = await plantService.getPlant(plantId);
      if (response.statusCode == 200 && response.body['result'] == 'ok') {
        return Plant.fromJson(response.body['data']);
      } else {
        Get.snackbar('Error', response.body['message'] ?? '식물 조회 실패');
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', '서버 오류: $e');
      return null;
    }
  }

  // 식물 물주기
  Future<void> waterPlant(int plantId, int groupId) async {
    try {
      final userId = authController.currentUser!.id;
      final response = await plantService.waterPlant(plantId, userId);
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        // final responseBody = jsonDecode(response.body);
        if (response.body['result'] == 'ok') {
          Get.snackbar('Success', '식물에 물을 주었습니다.');
          fetchPlantsForGroup(groupId); // 물주기 후 그룹의 식물 목록 다시 가져오기
        } else {
          Get.snackbar('Error', response.body['message'] ?? '물주기 실패');
        }
      } else {
        Get.snackbar('Error', '물주기 실패: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', '서버 오류: $e');
    }
  }

  // 물주기 주기 계산
  Future<Map<String, dynamic>?> getWateringSchedule(int plantId) async {
    try {
      final response = await plantService.getWateringSchedule(plantId);
      if (response.statusCode == 200 && response.body['result'] == 'ok') {
        return response.body['data'];
      } else {
        Get.snackbar('Error', response.body['message'] ?? '물주기 주기 계산 실패');
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', '서버 오류: $e');
      return null;
    }
  }
}
