import 'plant_model.dart';
import 'user_model.dart';

class Group {
  final int id; // 그룹 고유 ID
  final String name; // 그룹 이름
  final String description; // 그룹 설명
  final List<Plant> plants; // 그룹 내 식물 목록
  final List<User> members; // 그룹 구성원 목록

  Group({
    required this.id,
    required this.name,
    this.description = '',
    this.plants = const [],
    this.members = const [],
  });

  // JSON 데이터를 Dart 객체로 변환
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      plants: (json['plants'] as List<dynamic>?)
              ?.map((plant) => Plant.fromJson(plant))
              .toList() ??
          [],
      members: (json['members'] as List<dynamic>?)
              ?.map((user) => User.fromJson(user))
              .toList() ??
          [],
    );
  }

  // Dart 객체를 JSON 데이터로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'plants': plants.map((plant) => plant.toJson()).toList(),
      'members': members.map((member) => member.toJson()).toList(),
    };
  }
}
