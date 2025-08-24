class StoryEntity {
  final String id;
  final String userId;
  final String mediaUrl;
  final DateTime createdAt;

  const StoryEntity({
    required this.id,
    required this.userId,
    required this.mediaUrl,
    required this.createdAt,
  });
}
