import 'package:zytronic_task/domain/entity/chat_entity.dart';
import 'package:zytronic_task/domain/entity/message_entity.dart';
import 'package:zytronic_task/domain/entity/user_entity.dart';

abstract class ChatRepository {
  Stream<List<ChatUserEntity>> streamChat(String currentUserId);

  Stream<List<MessageEntity>> streamMessages(String chatId);

  Future<void> sendMessage(String chatId, String senderId, String text);

  Future<UserDataEntity?> getUserData(String userId);

  Future<void> ensureChat(String chatId, List<String> members);

  Stream<List<UserDataEntity>> getAllUsers();
}
