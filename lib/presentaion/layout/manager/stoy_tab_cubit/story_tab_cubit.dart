import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zytronic_task/domain/entity/stories_entity.dart';
import 'package:zytronic_task/domain/use_case/stories_use_case.dart';
import 'package:zytronic_task/presentaion/layout/manager/stoy_tab_cubit/story_tab_state.dart';
import 'dart:async';

@injectable
class StoryTabCubit extends Cubit<StoryTabState> {
  final StoriesUseCase _storiesUseCase;
  final ImagePicker _imagePicker = ImagePicker();
  StreamSubscription<List<UserStoryEntity>>? _storiesSubscription;
  
  List<UserStoryEntity> _userStories = [];
  List<UserStoryEntity> get userStories => _userStories;

  StoryTabCubit(this._storiesUseCase) : super(StoryTabInitial());

  void loadStories() {
    emit(StoryTabLoading());
    
    _storiesSubscription?.cancel();
    _storiesSubscription = _storiesUseCase.getAllUserStories().listen(
      (stories) {
        _userStories = stories;
        emit(StoriesLoaded(stories));
      },
      onError: (error) {
        emit(StoryTabError(error.toString()));
      },
    );
  }

  Future<void> pickAndUploadImage({String? caption}) async {
    try {
      // Check gallery permission
      final permission = await Permission.photos.request();
      if (!permission.isGranted) {
        emit(const StoryUploadError('Gallery permission is required'));
        return;
      }

      // Pick image
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        await _uploadStory(
          file: File(pickedFile.path),
          type: StoryType.image,
          caption: caption,
        );
      }
    } catch (e) {
      emit(StoryUploadError('Failed to pick image: ${e.toString()}'));
    }
  }

  Future<void> pickAndUploadVideo({String? caption}) async {
    try {
      // Check gallery permission
      final permission = await Permission.photos.request();
      if (!permission.isGranted) {
        emit(const StoryUploadError('Gallery permission is required'));
        return;
      }

      // Pick video
      final XFile? pickedFile = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 30), // Max 30 seconds for stories
      );

      if (pickedFile != null) {
        await _uploadStory(
          file: File(pickedFile.path),
          type: StoryType.video,
          caption: caption,
        );
      }
    } catch (e) {
      emit(StoryUploadError('Failed to pick video: ${e.toString()}'));
    }
  }

  Future<void> _uploadStory({
    required File file,
    required StoryType type,
    String? caption,
  }) async {
    try {
      emit(StoryUploadLoading());
      
      await _storiesUseCase.uploadStory(
        mediaFile: file,
        type: type,
        caption: caption,
      );
      
      emit(StoryUploadSuccess());
      // Reload stories to show the new one
      loadStories();
    } catch (e) {
      emit(StoryUploadError('Failed to upload story: ${e.toString()}'));
    }
  }

  Future<void> markStoryAsViewed(String storyId) async {
    try {
      await _storiesUseCase.markStoryAsViewed(storyId);
      emit(StoryViewedSuccess());
    } catch (e) {
      emit(StoryTabError('Failed to mark story as viewed: ${e.toString()}'));
    }
  }

  Future<void> deleteStory(String storyId) async {
    try {
      await _storiesUseCase.deleteStory(storyId);
      emit(StoryDeletedSuccess());
      // Reload stories after deletion
      loadStories();
    } catch (e) {
      emit(StoryTabError('Failed to delete story: ${e.toString()}'));
    }
  }

  void showMediaPicker() {
    // This method can be used to show a bottom sheet with image/video options
    // Implementation will be in the UI layer
  }

  @override
  Future<void> close() {
    _storiesSubscription?.cancel();
    return super.close();
  }
}