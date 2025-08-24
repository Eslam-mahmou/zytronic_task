import 'dart:io';

import 'package:injectable/injectable.dart';

import '../entity/stories_entity.dart';
import '../reposiatory/stories_repo.dart';

@injectable
class StoryUseCase {
  final StoryRepository _repo;
  StoryUseCase(this._repo);

  Stream<List<StoryEntity>> getStories() => _repo.streamActiveStories();

  Future<void> addStory(String userId, File mediaUrl) {
    return _repo.addStory( userId,  mediaUrl);
  }
}
