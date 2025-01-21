import 'package:get/get.dart';

import '../models/plant_model.dart';

class PlantService extends GetConnect {
  final String _baseUrl = 'http://10.0.2.2:3000'; // 실제 서버 URL

  @override
  void onInit() {
    httpClient.baseUrl = _baseUrl;
    httpClient.timeout = const Duration(seconds: 30); // 타임아웃 설정
    super.onInit();
  }

  // 식물 추가
  Future<Response> addPlant(Plant plant) async {
    return await post('/plants', plant.toJson());
  }

  // 식물 수정
  Future<Response> updatePlant(int plantId, Plant plant) async {
    return await put('/plants/$plantId', plant.toJson());
  }

  // 식물 삭제
  Future<Response> deletePlant(int plantId) async {
    return await delete('/plants/$plantId');
  }

  // 식물 조회
  Future<Response> getPlant(int plantId) async {
    return await get('/plants/$plantId');
  }

  // 식물 물주기
  Future<Response> waterPlant(int plantId, int userId) async {
    return await post('/plants/$plantId/water', {'userId': userId});
  }

  // 물주기 주기 계산
  Future<Response> getWateringSchedule(int plantId) async {
    return await get('/plants/$plantId/watering-schedule');
  }

  // 그룹의 식물 목록 조회
  Future<Response> getPlantsForGroup(int groupId) async {
    return await get('/groups/$groupId/plants');
  }
}
