import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entity/message_entity.dart';
import '../../../domain/use_case/chat_use_case.dart';
import 'chat_screen_state.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  final ChatUseCase _chatUseCase;

  ChatCubit(this._chatUseCase) : super(ChatLoadingState());
  final TextEditingController messageController = TextEditingController();
List<MessageEntity> messages = [];
  void loadMessages(String chatId) {

    emit(ChatLoadingState());
    _chatUseCase.getMessages(chatId).listen((messages) {
      this.messages = messages;
      emit(MessagesLoadedState(messages));
    }, onError: (e) => emit(ChatErrorState(e.toString())));
  }

  Future<void> sendMessage(String chatId, String senderId) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    try {
      await _chatUseCase.sendMessage(chatId, senderId,text);
      messageController.clear();
     loadMessages(chatId);
    } catch (e) {
      emit(MessageErrorState(e.toString()));
    }
  }
}
