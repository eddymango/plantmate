import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/group_controller.dart';
import '../widgets/group_card.dart';

class GroupScreen extends StatefulWidget {
  GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final GroupController groupController = Get.put(GroupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('그룹 관리'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate:
                    GroupSearchDelegate(groupController, _showJoinGroupDialog),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('내 그룹',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: groupController.myGroups.length,
                  itemBuilder: (context, index) {
                    final group = groupController.myGroups[index];
                    return GroupCard(
                      groupName: group['name'],
                      members: group['members'] ?? 0, // null 값을 0으로 대체
                      plants: group['plants'] ?? 0, // null 값을 0으로 대체
                      status: '참여중',
                      isJoined: true,
                      onJoinOrLeave: () {
                        groupController.leaveGroup(group['id']);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text('추천 그룹',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: groupController.recommendedGroups.length,
                  itemBuilder: (context, index) {
                    final group = groupController.recommendedGroups[index];
                    return GroupCard(
                      groupName: group['name'],
                      members: group['members'] ?? 0, // null 값을 0으로 대체
                      plants: group['plants'] ?? 0, // null 값을 0으로 대체
                      status: '가입하기',
                      isJoined: false,
                      onJoinOrLeave: () {
                        _showJoinGroupDialog(context, group['id']);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateGroupDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('그룹 생성'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: '그룹 이름'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: '그룹 설명'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: '비밀번호'),
                obscureText: true,
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
                groupController.createGroup(
                  nameController.text,
                  descriptionController.text,
                  passwordController.text,
                );
                Get.back();
              },
              child: const Text('생성'),
            ),
          ],
        );
      },
    );
  }

  void _showJoinGroupDialog(BuildContext context, int groupId) {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('그룹 가입'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: '비밀번호'),
                obscureText: true,
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
                groupController.joinGroup(groupId, passwordController.text);
                Get.back();
              },
              child: const Text('가입'),
            ),
          ],
        );
      },
    );
  }
}

class GroupSearchDelegate extends SearchDelegate {
  final GroupController groupController;
  final Function(BuildContext, int) showJoinGroupDialog;

  GroupSearchDelegate(this.groupController, this.showJoinGroupDialog);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    groupController.searchGroup(query);
    return Obx(() {
      return ListView(
        children: [
          ...groupController.myGroups.map((group) => GroupCard(
                groupName: group['name'],
                members: group['members'] ?? 0, // null 값을 0으로 대체
                plants: group['plants'] ?? 0, // null 값을 0으로 대체
                status: '참여중',
                isJoined: true,
                onJoinOrLeave: () {
                  groupController.leaveGroup(group['id']);
                },
              )),
          ...groupController.recommendedGroups.map((group) => GroupCard(
                groupName: group['name'],
                members: group['members'] ?? 0, // null 값을 0으로 대체
                plants: group['plants'] ?? 0, // null 값을 0으로 대체
                status: '가입하기',
                isJoined: false,
                onJoinOrLeave: () {
                  showJoinGroupDialog(context, group['id']);
                },
              )),
        ],
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
