import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:zytronic_task/data/data_source/stories_data_source.dart';
import 'package:zytronic_task/domain/entity/stories_entity.dart';
import 'package:zytronic_task/domain/reposiatory/stories_repo.dart';

@Injectable(as: StoriesRepository)
class StoriesRepositoryImpl implements StoriesRepository {
  final StoriesDataSource _dataSource;

  StoriesRepositoryImpl(this._dataSource);

  @override
  Stream<List<UserStoryEntity>> getAllUserStories() {
    return _dataSource.getAllUserStories().map((models) => models.cast<UserStoryEntity>());
  }

  @override
  Future<void> uploadStory({
    required File mediaFile,
    required StoryType type,
    String? caption,
  }) async {
    try {
      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(mediaFile.path);
      final fileName = '${timestamp}_story$extension';

      // Upload media file to Firebase Storage
      final mediaUrl = await _dataSource.uploadMedia(mediaFile, fileName);

      // Create story document in Firestore
      await _dataSource.createStory(
        mediaUrl: mediaUrl,
        type: type,
        caption: caption,
      );
    } catch (e) {
      throw Exception('Failed to upload story: $e');
    }
  }

  @override
  Future<void> markStoryAsViewed(String storyId) async {
    return _dataSource.markStoryAsViewed(storyId);
  }

  @override
  Future<void> deleteStory(String storyId) async {
    return _dataSource.deleteStory(storyId);
  }

  @override
  Stream<List<StoryEntity>> getUserStories(String userId) {
    return _dataSource.getUserStories(userId).map((models) => models.cast<StoryEntity>());
  }
}