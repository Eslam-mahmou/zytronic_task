import 'package:injectable/injectable.dart';
import 'package:zytronic_task/core/service/shared_pref_helper.dart';
import 'package:zytronic_task/data/data_source/chat_data_source.dart';
import 'package:zytronic_task/domain/entity/chat_entity.dart';
import 'package:zytronic_task/domain/entity/message_entity.dart';
import 'package:zytronic_task/domain/reposiatory/chat_repo.dart';
import '../../domain/entity/user_entity.dart';

@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _dataSource;

  ChatRepositoryImpl(this._dataSource);

  @override
  Stream<List<ChatUserEntity>> streamChat(String currentUserId) {
    return _dataSource.streamChat(currentUserId);
  }

  @override
  Stream<List<MessageEntity>> streamMessages(String chatId) {
    return _dataSource.streamMessages(chatId);
  }

  @override
  Future<void> sendMessage(String chatId, String senderId, String text) {
    return _dataSource.sendMessage(chatId, senderId, text);
  }

  @override
  Future<void> ensureChat(
     String chatId,
     List<String> members,
  ) {
    return _dataSource.ensureChat(chatId, members);
  }

  @override
  Stream<List<UserDataEntity>> getAllUsers() {
    return _dataSource.getAllUsers();
  }

  @override
  Future<UserDataEntity?> getUserData(String userId) {
    return _dataSource.getUserData(userId);
  }


}
