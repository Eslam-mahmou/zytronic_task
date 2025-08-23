import 'package:injectable/injectable.dart';
import 'package:zytronic_task/domain/entity/chat_entity.dart';
import 'package:zytronic_task/domain/entity/message_entity.dart';
import 'package:zytronic_task/domain/entity/user_entity.dart';
import 'package:zytronic_task/domain/reposiatory/chat_repo.dart';

@injectable
class ChatUseCase {
  final ChatRepository _chatRepository;

  ChatUseCase(this._chatRepository);

  Stream<List<ChatUserEntity>> getChats(String currentUserId) {
    return _chatRepository.streamChat(currentUserId);
  }

  Stream<List<MessageEntity>> getMessages(String chatId) {
    return _chatRepository.streamMessages(chatId);
  }

  Future<void> sendMessage(String chatId, String senderId, String text) {
    return _chatRepository.sendMessage(chatId, senderId, text);
  }

  Future<void> createChat(String chatId, List<String> members) {
    return _chatRepository.ensureChat(chatId, members);
  }

  Stream<List<UserDataEntity>> getAllUsers() {
    return _chatRepository.getAllUsers();
  }

  Future<UserDataEntity?> getUserData(String userId) {
    return _chatRepository.getUserData(userId);
  }
}
