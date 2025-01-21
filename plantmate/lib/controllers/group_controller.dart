import 'package:get/get.dart';
import 'package:plantmate/services/group_service.dart';
import 'package:plantmate/controllers/auth_controller.dart';

import 'plant_controller.dart';

class GroupController extends GetxController {
  // 그룹 데이터 (Observable)
  var myGroups = <Map<String, dynamic>>[].obs; // 사용자가 가입한 그룹
  var recommendedGroups = <Map<String, dynamic>>[].obs; // 추천 그룹
  var filteredRecommendedGroups = <Map<String, dynamic>>[].obs; // 필터링된 추천 그룹
  var selectedGroup = ''.obs; // 선택된 그룹
  var plants = <Map<String, dynamic>>[].obs; // 선택된 그룹의 식물 목록

  final GroupService groupService = Get.put(GroupService());
  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    fetchGroups();
  }

  // 그룹 검색
  void searchGroup(String query) {
    // 검색 로직 구현 (필터링)
    if (query.isEmpty) {
      filteredRecommendedGroups.value = recommendedGroups;
    } else {
      filteredRecommendedGroups.value = recommendedGroups
          .where((group) =>
              group['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // 그룹 데이터 가져오기
  void fetchGroups() async {
    final userId = authController.currentUser!.id;

    try {
      final response = await groupService.getAllGroups(userId);
      if (response.statusCode == 200 && response.body['result'] == 'ok') {
        final groups = List<Map<String, dynamic>>.from(response.body['data']);

        myGroups.value =
            groups.where((group) => group['isJoined'] == true).toList();
        recommendedGroups.value =
            groups.where((group) => group['isJoined'] == false).toList();

        if (myGroups.isNotEmpty) {
          selectedGroup.value = myGroups[0]['name'];
          Get.find<PlantController>().fetchPlantsForGroup(myGroups[0]['id']);
        }

        filteredRecommendedGroups.value = recommendedGroups; // 초기화
      } else {
        Get.snackbar('Error', '그룹 데이터를 가져오는데 실패했습니다.');
      }
    } catch (e) {
      Get.snackbar('Error', '서버 오류: $e');
    }
  }

  // 그룹 가입
  void joinGroup(int groupId, String password) async {
    try {
      final userId = authController.currentUser?.id;
      if (userId == null) {
        Get.snackbar('Error', '로그인 정보가 없습니다.');
        return;
      }

      final response = await groupService.joinGroup(groupId, password, userId);
      if (response.statusCode == 200 && response.body['result'] == 'ok') {
        Get.snackbar('Success', '그룹에 가입되었습니다.');
        fetchGroups(); // 데이터 새로고침
      } else {
        Get.snackbar('Error', response.body['message'] ?? '그룹 가입 실패');
      }
    } catch (e) {
      Get.snackbar('Error', '서버 오류: $e');
    }
  }

  // 그룹 탈퇴
  void leaveGroup(int groupId) async {
    try {
      final userId = authController.currentUser?.id;
      if (userId == null) {
        Get.snackbar('Error', '로그인 정보가 없습니다.');
        return;
      }

      final response = await groupService.leaveGroup(groupId, userId);
      if (response.statusCode == 200 && response.body['result'] == 'ok') {
        Get.snackbar('Success', '그룹에서 탈퇴하였습니다.');
        fetchGroups(); // 데이터 새로고침
      } else {
        Get.snackbar('Error', response.body['message'] ?? '그룹 탈퇴 실패');
      }
    } catch (e) {
      Get.snackbar('Error', '서버 오류: $e');
    }
  }

  // 그룹 생성
  void createGroup(String name, String description, String password) async {
    try {
      final userId = authController.currentUser?.id;
      if (userId == null) {
        Get.snackbar('Error', '로그인 정보가 없습니다.');
        return;
      }

      final response =
          await groupService.createGroup(name, description, password, userId);
      if (response.statusCode == 201 && response.body['result'] == 'ok') {
        Get.snackbar('Success', '그룹이 생성되었습니다.');
        fetchGroups(); // 데이터 새로고침
      } else {
        Get.snackbar('Error', response.body['message'] ?? '그룹 생성 실패');
      }
    } catch (e) {
      Get.snackbar('Error', '서버 오류: $e');
    }
  }

  void deleteGroup(int groupId) async {
    try {
      final userId = authController.currentUser?.id;
      if (userId == null) {
        Get.snackbar('Error', '로그인 정보가 없습니다.');
        return;
      }

      final response = await groupService.deleteGroup(groupId, userId);
      if (response.statusCode == 200 && response.body['result'] == 'ok') {
        Get.snackbar('Success', '그룹이 삭제되었습니다.');
        fetchGroups(); // 데이터 새로고침
      } else {
        Get.snackbar('Error', response.body['message'] ?? '그룹 삭제 실패');
      }
    } catch (e) {
      Get.snackbar('Error', '서버 오류: $e');
    }
  }
}
