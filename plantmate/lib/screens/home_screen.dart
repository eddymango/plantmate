import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../widgets/plant_card.dart';
import '../widgets/stat_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantmate'),
        actions: [
          DropdownButton(
            value: '우리집 화분',
            onChanged: (value) {
              print(value);
            },
            items: const [
              DropdownMenuItem(value: '우리집 화분', child: Text("우리집 화분")),
              DropdownMenuItem(value: '사무실 정원', child: Text("사무실 정원")),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "식물 목록",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 280,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  PlantCard(name: '아레카야자', nextWatering: '2021-09-01'),
                  const SizedBox(width: 16),
                  PlantCard(name: '고무나무', nextWatering: '2021-09-01'),
                  const SizedBox(width: 16),
                  PlantCard(name: '스투키', nextWatering: '2021-09-01'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: const [
                Expanded(
                  child: StatCard(label: '오늘 물 줄 식물', value: '2'),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(label: '총 식물 수', value: '5'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
