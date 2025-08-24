import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../domain/entity/stories_entity.dart';
import '../../domain/reposiatory/stories_repo.dart';
import '../data_source/stories_data_source.dart';

@Injectable(as: StoryRepository)
class StoryRepositoryImpl implements StoryRepository {
  final StoryDataSource _ds;

  StoryRepositoryImpl(this._ds);

  @override
  Stream<List<StoryEntity>> streamActiveStories() => _ds.streamActiveStories();

  @override
  Future<void> addStory( String userId,  File mediaUrl) {
    return _ds.addStory( userId: userId, mediaUrl: mediaUrl);
  }
}
