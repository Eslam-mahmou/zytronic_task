import 'package:zytronic_task/domain/entity/user_entity.dart';



class UserDataModel extends UserDataEntity {
  const UserDataModel({
    required super.id,
    required super.name,
    required super.avatarUrl,
    required super.lastSeen,
  });


  factory UserDataModel.fromFireStore(String id, Map<String, dynamic> json) {
    return UserDataModel(
      id: id,
      name: (json['name'] ?? '') ,
      avatarUrl: (json['avatarUrl'] ?? '') ,
      lastSeen: (json['lastSeen'])?.toDate() ?? DateTime(2000),
    );
  }
}