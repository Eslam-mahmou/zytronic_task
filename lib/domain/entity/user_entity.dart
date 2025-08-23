class UserDataEntity {
  final String id;
  final String name;
  final String avatarUrl;
  final DateTime lastSeen;


  const UserDataEntity({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.lastSeen,
  });
}