import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/plant_model.dart';
import '../screens/plant_detail_screen.dart';
import '../controllers/plant_controller.dart';

class PlantCard extends StatefulWidget {
  final Plant plant;

  PlantCard({
    required this.plant,
    super.key,
  });

  @override
  State<PlantCard> createState() => _PlantCardState();
}

class _PlantCardState extends State<PlantCard> {
  final PlantController plantController = Get.find<PlantController>();
  late RxString dDayText;

  @override
  void initState() {
    super.initState();
    dDayText = "계산 중...".obs;

    _calculateDDay();
  }

  @override
  void didUpdateWidget(covariant PlantCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // widget.plant 변경 시 D-Day 재계산
    if (widget.plant != oldWidget.plant) {
      _calculateDDay();
    }
  }

  void _calculateDDay() {
    // 오늘 날짜에서 시간 정보를 제거
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    DateTime nextWateringDate = today; // 초기값 설정
    if (widget.plant.lastWateredAt.isNotEmpty) {
      DateTime lastWateredDateParsed =
          DateTime.parse(widget.plant.lastWateredAt);
      nextWateringDate = DateTime(
        lastWateredDateParsed.year,
        lastWateredDateParsed.month,
        lastWateredDateParsed.day,
      ).add(Duration(days: widget.plant.wateringInterval));
    }

    final dDay = nextWateringDate.difference(today).inDays;
    setState(() {
      dDayText.value = dDay > 0
          ? "D-$dDay"
          : dDay == 0
              ? "D-Day"
              : "D+${-dDay}";
    });
  }

  @override
  Widget build(BuildContext context) {
    // 마지막 물 준 날짜를 년, 월, 일 형식으로 변환
    String formattedLastWateredDate = '';
    if (widget.plant.lastWateredAt.isNotEmpty) {
      DateTime lastWateredDateParsed =
          DateTime.parse(widget.plant.lastWateredAt);
      formattedLastWateredDate =
          DateFormat('yyyy-MM-dd').format(lastWateredDateParsed);
    }

    return GestureDetector(
      onTap: () {
        // PlantDetailScreen으로 이동
        Get.to(() => PlantDetailScreen(plant: widget.plant));
      },
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 209, 238, 175),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 영역
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: widget.plant.photoUrl.isNotEmpty
                  ? Image.network(
                      'http://10.0.2.2:3000/${widget.plant.photoUrl}',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/image1.jpg',
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/image1.jpg',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 12),

            // 식물 이름
            Text(
              widget.plant.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),

            // 마지막 물준 날짜
            Text(
              '마지막 물준 날: $formattedLastWateredDate',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),

            // 다음 물주기와 D-Day 표시
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '다음 물주기',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    dDayText.value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 물주기 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // 물주기 기능
                  await plantController.waterPlant(
                      widget.plant.id, widget.plant.groupId);
                  _calculateDDay();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: const Color.fromARGB(255, 114, 180, 235),
                ),
                child: const Text(
                  '물주기',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
