class Plant {
  final int id; // 식물 고유 ID
  final String name; // 식물 이름
  final String imageUrl; // 식물 이미지 URL (nullable)
  final int waterCycle; // 물주기 주기 (일 단위)
  final String lastWatered; // 마지막 물 준 날짜 (yyyy-MM-dd)
  final int groupId; // 속한 그룹 ID

  Plant({
    required this.id,
    required this.name,
    this.imageUrl = '',
    required this.waterCycle,
    required this.lastWatered,
    required this.groupId,
  });

  // JSON 데이터를 Dart 객체로 변환
  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'] ?? '',
      waterCycle: json['waterCycle'],
      lastWatered: json['lastWatered'],
      groupId: json['groupId'],
    );
  }

  // Dart 객체를 JSON 데이터로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'waterCycle': waterCycle,
      'lastWatered': lastWatered,
      'groupId': groupId,
    };
  }
}
