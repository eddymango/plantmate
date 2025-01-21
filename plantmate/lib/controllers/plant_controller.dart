import 'package:get/get.dart';
import 'package:plantmate/services/plant_service.dart';
import 'package:plantmate/controllers/auth_controller.dart';
import 'package:plantmate/models/plant_model.dart';

class PlantController extends GetxController {
  var plants = <Plant>[].obs; // 선택된 그룹의 식물 목록

  final PlantService plantService = Get.put(PlantService());
  final AuthController authController = Get.find<AuthController>();

  // 그룹의 식물 목록 가져오기
  void fetchPlantsForGroup(int groupId) async {
    try {
      final response = await plantService.getPlantsForGroup(groupId);
      if (response.statusCode == 200 && response.body['result'] == 'ok') {
        plants.value = (response.body['data'] as List)
            .map((plant) => Plant.fromJson(plant))
            .toList();
      } else {
        Get.snackbar('Error', '식물 데이터를 가져오는데 실패했습니다.');
      }
    } catch (e) {
      Get.snackbar('Error', '서버 오류: $e');
    }
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
  void waterPlant(int plantId, int groupId) async {
    try {
      final userId = authController.currentUser!.id;
      final response = await plantService.waterPlant(plantId, userId);
      if (response.statusCode == 200 && response.body['result'] == 'ok') {
        Get.snackbar('Success', '식물에 물을 주었습니다.');
        fetchPlantsForGroup(groupId);
      } else {
        Get.snackbar('Error', response.body['message'] ?? '물주기 실패');
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
