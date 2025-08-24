import 'dart:io';
import 'package:zytronic_task/domain/entity/stories_entity.dart';

abstract class StoriesRepository {
  Stream<List<UserStoryEntity>> getAllUserStories();
  Future<void> uploadStory({
    required File mediaFile,
    required StoryType type,
    String? caption,
  });
  Future<void> markStoryAsViewed(String storyId);
  Future<void> deleteStory(String storyId);
  Stream<List<StoryEntity>> getUserStories(String userId);
}