import 'package:flutter/material.dart';

import '../widgets/group_card.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantmate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 검색창과 그룹 만들기 버튼
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '그룹 검색하기',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // 그룹 만들기 버튼 동작
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[100],
                  ),
                  child: const Text('그룹 만들기'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // "내 그룹" 섹션
            const Text(
              '내 그룹',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GroupCard(
              groupName: '우리집 화분',
              members: 3,
              plants: 5,
              status: '참여중',
              isJoined: true,
            ),
            const SizedBox(height: 8),
            GroupCard(
              groupName: '사무실 정원',
              members: 5,
              plants: 8,
              status: '참여중',
              isJoined: true,
            ),
            const SizedBox(height: 16),

            // "추천 그룹" 섹션
            const Text(
              '추천 그룹',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GroupCard(
              groupName: '식물 초보 모임',
              members: 12,
              plants: 15,
              status: '가입하기',
              isJoined: false,
            ),
            const SizedBox(height: 8),
            GroupCard(
              groupName: '다육이 러버스',
              members: 8,
              plants: 20,
              status: '가입하기',
              isJoined: false,
            ),
          ],
        ),
      ),
    );
  }
}
