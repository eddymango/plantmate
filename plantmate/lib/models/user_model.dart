import 'group_model.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String profileImage;
  final List<Group> groups;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage = '', // 기본값 설정
    this.groups = const [], // 기본값 설정
  });

  // JSON 데이터를 Dart 객체로 변환
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'] ?? '',
      groups: (json['groups'] as List<dynamic>?)
              ?.map((group) => Group.fromJson(group))
              .toList() ??
          [],
    );
  }

  // Dart 객체를 JSON 데이터로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'groups': groups.map((group) => group.toJson()).toList(),
    };
  }
}
