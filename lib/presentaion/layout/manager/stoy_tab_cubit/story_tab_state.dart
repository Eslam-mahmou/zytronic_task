import 'package:equatable/equatable.dart';
import 'package:zytronic_task/domain/entity/stories_entity.dart';

abstract class StoryTabState extends Equatable {
  const StoryTabState();

  @override
  List<Object?> get props => [];
}

// Initial state
class StoryTabInitial extends StoryTabState {}

// Loading states
class StoryTabLoading extends StoryTabState {}

class StoryUploadLoading extends StoryTabState {}

// Success states
class StoriesLoaded extends StoryTabState {
  final List<UserStoryEntity> userStories;

  const StoriesLoaded(this.userStories);

  @override
  List<Object?> get props => [userStories];
}

class StoryUploadSuccess extends StoryTabState {}

class StoryViewedSuccess extends StoryTabState {}

class StoryDeletedSuccess extends StoryTabState {}

// Error states
class StoryTabError extends StoryTabState {
  final String message;

  const StoryTabError(this.message);

  @override
  List<Object?> get props => [message];
}

class StoryUploadError extends StoryTabState {
  final String message;

  const StoryUploadError(this.message);

  @override
  List<Object?> get props => [message];
}