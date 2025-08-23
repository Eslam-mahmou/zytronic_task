import 'package:equatable/equatable.dart';
import 'package:zytronic_task/domain/entity/message_entity.dart';

sealed class ChatState {

}

 class ChatLoadingState extends ChatState {}

 class MessagesLoadedState extends ChatState {
  final List<MessageEntity> messages;
  MessagesLoadedState(this.messages);

}

 class ChatErrorState extends ChatState {
  final String message;
  ChatErrorState(this.message);

}

final class MessageSending extends ChatState {}

final class MessageSent extends ChatState {}

final class MessageErrorState extends ChatState {
  final String message;
  MessageErrorState(this.message);

}
