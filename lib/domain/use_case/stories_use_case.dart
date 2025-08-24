import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:zytronic_task/domain/entity/stories_entity.dart';
import 'package:zytronic_task/domain/reposiatory/stories_repo.dart';

@injectable
class StoriesUseCase {
  final StoriesRepository _repository;

  StoriesUseCase(this._repository);

  Stream<List<UserStoryEntity>> getAllUserStories() {
    return _repository.getAllUserStories();
  }

  Future<void> uploadStory({
    required File mediaFile,
    required StoryType type,
    String? caption,
  }) async {
    return _repository.uploadStory(
      mediaFile: mediaFile,
      type: type,
      caption: caption,
    );
  }

  Future<void> markStoryAsViewed(String storyId) async {
    return _repository.markStoryAsViewed(storyId);
  }

  Future<void> deleteStory(String storyId) async {
    return _repository.deleteStory(storyId);
  }

  Stream<List<StoryEntity>> getUserStories(String userId) {
    return _repository.getUserStories(userId);
  }
}