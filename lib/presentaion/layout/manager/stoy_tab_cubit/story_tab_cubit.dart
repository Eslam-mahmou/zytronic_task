import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:zytronic_task/presentaion/layout/manager/stoy_tab_cubit/story_tab_state.dart';

import '../../../../domain/entity/stories_entity.dart';
import '../../../../domain/use_case/stories_use_case.dart';

@injectable
class StoryCubit extends Cubit<StoryState> {
  final StoryUseCase useCase;

  StoryCubit(this.useCase) : super(StoryInitial());

  Future<void> pickAndUploadStory(String userId) async {
    try {
      emit(StoryUploading());
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked == null) {
        emit(StoryInitial());
        return;
      }
      final file = File(picked.path);

      await useCase.addStory(userId, file);
      emit(StoryUploaded());
      loadStories();
    } catch (e) {
      emit(StoryError(e.toString()));
    }
  }

  void loadStories() {
    emit(StoryLoading());
    useCase.getStories().listen(
      (stories) => emit(StoriesLoaded(stories)),
      onError: (e) => emit(GetStoriesError(e.toString())),
    );
  }
}
