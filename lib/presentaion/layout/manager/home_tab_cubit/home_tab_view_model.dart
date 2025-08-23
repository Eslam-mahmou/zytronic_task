import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zytronic_task/domain/entity/user_entity.dart';
import 'package:zytronic_task/domain/use_case/chat_use_case.dart';

import '../../../../domain/entity/chat_entity.dart';
import 'home_tab_state.dart';

@injectable
class HomeChatCubit extends Cubit<HomeState> {
  final ChatUseCase _chatUseCase;
  List<UserDataEntity> users = [];
  List<ChatUserEntity> chats = [];

  HomeChatCubit(this._chatUseCase) : super(HomeLoadingState());

  void loadChats(String currentUserId) {
    emit(HomeChatLoading());

    try {
      _chatUseCase
          .getChats(currentUserId)
          .listen(
            (chats) {
              this.chats = chats;
              emit(HomeChatLoaded(chats));
            },
            onError: (error) {
              emit(HomeChatError(error.toString()));
            },
          );
    } catch (error) {
      emit(HomeChatError(error.toString()));
    }
  }

  void loadUsers() {
    emit(HomeLoadingState());

    try {
      _chatUseCase.getAllUsers().listen(
        (users) {
          this.users = users;
          emit(HomeUsersLoaded(users));
        },
        onError: (error) {
          emit(HomeError(error.toString()));
        },
      );
    } catch (error) {
      emit(HomeError(error.toString()));
    }
  }
}
