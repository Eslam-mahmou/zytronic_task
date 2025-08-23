import 'package:zytronic_task/domain/entity/user_entity.dart';

import '../../../../domain/entity/chat_entity.dart';

sealed class HomeState {}

final class HomeLoadingState extends HomeState {}

final class HomeUsersLoaded extends HomeState {
  final List<UserDataEntity> users;

  HomeUsersLoaded(this.users);
}

 class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
 class HomeChatLoading extends HomeState {}

 class HomeChatLoaded extends HomeState {
  final List<ChatUserEntity> chats;

  HomeChatLoaded(this.chats);
}

 class HomeChatError extends HomeState {
  final String message;

  HomeChatError(this.message);
}