import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zytronic_task/domain/entity/stories_entity.dart';

class StoryModel extends StoryEntity {
  const StoryModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.mediaUrl,
    required super.type,
    required super.createdAt,
    required super.expiresAt,
    super.isViewed = false,
    super.caption,
  });

  factory StoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return StoryModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      mediaUrl: data['mediaUrl'] ?? '',
      type: data['type'] == 'video' ? StoryType.video : StoryType.image,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      isViewed: data['isViewed'] ?? false,
      caption: data['caption'],
    );
  }

  factory StoryModel.fromEntity(StoryEntity entity) {
    return StoryModel(
      id: entity.id,
      userId: entity.userId,
      userName: entity.userName,
      mediaUrl: entity.mediaUrl,
      type: entity.type,
      createdAt: entity.createdAt,
      expiresAt: entity.expiresAt,
      isViewed: entity.isViewed,
      caption: entity.caption,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'mediaUrl': mediaUrl,
      'type': type == StoryType.video ? 'video' : 'image',
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'isViewed': isViewed,
      'caption': caption,
    };
  }
}

class UserStoryModel extends UserStoryEntity {
  const UserStoryModel({
    required super.userId,
    required super.userName,
    super.userAvatar,
    required super.stories,
    required super.hasUnviewedStories,
  });

  factory UserStoryModel.fromStories(List<StoryModel> stories) {
    if (stories.isEmpty) {
      throw ArgumentError('Stories list cannot be empty');
    }

    final firstStory = stories.first;
    final hasUnviewed = stories.any((story) => !story.isViewed);

    return UserStoryModel(
      userId: firstStory.userId,
      userName: firstStory.userName,
      userAvatar: null, // Will be fetched separately if needed
      stories: stories,
      hasUnviewedStories: hasUnviewed,
    );
  }
}