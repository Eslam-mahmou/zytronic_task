
import 'dart:io';

import '../entity/stories_entity.dart';

abstract class StoryRepository {
  Stream<List<StoryEntity>> streamActiveStories();
  Future<void> addStory(String userId,  File mediaUrl);
}
