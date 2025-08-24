
import '../../../../domain/entity/stories_entity.dart';

abstract class StoryState {}

class StoryInitial extends StoryState {}

class StoryUploading extends StoryState {}

class StoryUploaded extends StoryState {}

class StoryError extends StoryState {
  final String message;
  StoryError(this.message);
}
class StoryLoading extends StoryState {}
class StoriesLoaded extends StoryState {
  final List<StoryEntity> stories;
  StoriesLoaded(this.stories);
}
class GetStoriesError extends StoryState {
  final String message;
  GetStoriesError(this.message);
}