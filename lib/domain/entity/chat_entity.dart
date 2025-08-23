import 'package:zytronic_task/domain/entity/user_entity.dart';



class ChatUserEntity {
  final String chatId;
  final UserDataEntity anotherPerson;
  final String lastMessage;
  final DateTime updatedAt;


  const ChatUserEntity({
    required this.chatId,
    required this.anotherPerson,
    required this.lastMessage,
    required this.updatedAt,
  });
}