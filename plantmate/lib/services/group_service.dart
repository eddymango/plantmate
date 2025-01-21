import 'package:get/get.dart';

class GroupService extends GetConnect {
  final String _baseUrl = 'http://10.0.2.2:3000';

  @override
  void onInit() {
    httpClient.baseUrl = _baseUrl;
    httpClient.timeout = const Duration(seconds: 30); // 타임아웃 설정
    super.onInit();
  }

  // 전체 그룹 조회
  Future<Response> getAllGroups(int userId) async {
    return await get('/groups', query: {'userId': userId.toString()});
  }

  // 그룹 가입
  Future<Response> joinGroup(int groupId, String password, int userId) async {
    return await post('/groups/join', {
      'groupId': groupId,
      'password': password,
      'userId': userId,
    });
  }

  // 그룹 탈퇴
  Future<Response> leaveGroup(int groupId, int userId) async {
    return await delete('/groups/leave/$groupId',
        query: {'userId': userId.toString()});
  }

  // 그룹 생성
  Future<Response> createGroup(
      String name, String description, String password, int userId) async {
    return await post('/groups', {
      'name': name,
      'description': description,
      'password': password,
      'userId': userId,
    });
  }

  Future<Response> deleteGroup(int groupId, int userId) async {
    return await delete('/groups',
        query: {'groupId': groupId.toString(), 'userId': userId.toString()});
  }

  //그룹 식물 목록 조회
  Future<Response> getPlantsForGroup(int groupId) async {
    return await get('/groups/$groupId/plants');
  }
}
