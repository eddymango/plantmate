class Plant {
  final int id; // 식물 고유 ID
  final int groupId; // 속한 그룹 ID
  final String name; // 식물 이름
  final String description; // 식물 설명 (nullable)
  final int wateringInterval; // 물주기 주기 (일 단위)
  String lastWateredAt; // 마지막 물 준 날짜와 시간 (nullable)
  final String createdAt; // 식물 생성 날짜와 시간
  final String photoUrl; // 식물 사진 URL (nullable)

  Plant({
    required this.id,
    required this.groupId,
    required this.name,
    this.description = '',
    required this.wateringInterval,
    this.lastWateredAt = '',
    required this.createdAt,
    this.photoUrl = '',
  });

  // JSON 데이터를 Dart 객체로 변환
  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      groupId: json['group_id'],
      name: json['name'],
      description: json['description'] ?? '',
      wateringInterval: json['watering_interval'],
      lastWateredAt: json['last_watered_at'] ?? '',
      createdAt: json['created_at'],
      photoUrl: json['photo_url'] ?? '',
    );
  }

  // Dart 객체를 JSON 데이터로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'name': name,
      'description': description,
      'watering_interval': wateringInterval,
      'last_watered_at': lastWateredAt,
      'created_at': createdAt,
      'photo_url': photoUrl,
    };
  }
}
