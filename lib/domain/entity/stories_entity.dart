import 'package:equatable/equatable.dart';

enum StoryType { image, video }

class StoryEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String mediaUrl;
  final StoryType type;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool isViewed;
  final String? caption;

  const StoryEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.mediaUrl,
    required this.type,
    required this.createdAt,
    required this.expiresAt,
    this.isViewed = false,
    this.caption,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        mediaUrl,
        type,
        createdAt,
        expiresAt,
        isViewed,
        caption,
      ];
}

class UserStoryEntity extends Equatable {
  final String userId;
  final String userName;
  final String? userAvatar;
  final List<StoryEntity> stories;
  final bool hasUnviewedStories;

  const UserStoryEntity({
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.stories,
    required this.hasUnviewedStories,
  });

  StoryEntity? get latestStory => stories.isNotEmpty ? stories.last : null;

  @override
  List<Object?> get props => [
        userId,
        userName,
        userAvatar,
        stories,
        hasUnviewedStories,
      ];
}