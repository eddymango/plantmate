import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final String groupName;
  final int members;
  final int plants;
  final String status;
  final bool isJoined;
  final VoidCallback onJoinOrLeave;

  const GroupCard({
    super.key,
    required this.groupName,
    required this.members,
    required this.plants,
    required this.status,
    required this.isJoined,
    required this.onJoinOrLeave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 그룹 정보
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '멤버 $members명 · 식물 $plants개',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            // 상태 표시 (참여중/가입하기)
            isJoined
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: onJoinOrLeave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[100],
                    ),
                    child: Text(status),
                  ),
          ],
        ),
      ),
    );
  }
}
