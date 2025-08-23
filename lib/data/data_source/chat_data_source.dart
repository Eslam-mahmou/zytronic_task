import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:zytronic_task/core/utils/constant_manager.dart';
import 'package:zytronic_task/data/model/chat_model.dart';
import 'package:zytronic_task/data/model/message_model.dart';
import 'package:zytronic_task/domain/entity/chat_entity.dart';
import 'package:zytronic_task/domain/entity/message_entity.dart';
import 'package:zytronic_task/domain/entity/user_entity.dart';

abstract class ChatDataSource {
  Stream<List<ChatUserEntity>> streamChat(String currentUserId);
  Stream<List<MessageEntity>> streamMessages(String chatId);
  Future<void> sendMessage(String chatId, String senderId, String text);
  Future<void> ensureChat(String chatId, List<String> members);
  Stream<List<UserDataEntity>> getAllUsers();
  Future<UserDataEntity?> getUserData(String userId);
}

@Injectable(as: ChatDataSource)
class ChatDataSourceImpl implements ChatDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Stream<List<ChatUserEntity>> streamChat(String currentUserId) {
    return _db
        .collection(AppConstant.chatCollection)
        .where(AppConstant.membersField, arrayContains: currentUserId)
        .snapshots()
        .asyncMap((snapshot) async {
      List<ChatUserEntity> chats = [];
      for (var doc in snapshot.docs) {
        try {
          final basicChat = ChatUserModel.fromSnapshot(
            doc,
            currentUserId: currentUserId,
          );

          final otherUserId = basicChat.anotherPerson.id;
          if (otherUserId != 'unknown_user') {
            final userData = await getUserData(otherUserId);
            if (userData != null) {
              final chatWithUserData = ChatUserModel(
                chatId: basicChat.chatId,
                anotherPerson: userData,
                lastMessage: basicChat.lastMessage,
                updatedAt: basicChat.updatedAt,
              );
              chats.add(chatWithUserData);
            } else {
              chats.add(basicChat);
            }
          } else {
            chats.add(basicChat);
          }
        } catch (e) {
          chats.add(
            ChatUserModel(
              chatId: doc.id,
              anotherPerson: UserDataEntity(
                id: 'debug_user',
                name: 'Debug User',
                avatarUrl: '',
                lastSeen: DateTime.now(),
              ),
              lastMessage: 'Debug message',
              updatedAt: DateTime.now(),
            ),
          );
        }
      }
      return chats;
    });
  }

  @override
  Stream<List<MessageEntity>> streamMessages(String chatId) {
    return _db
        .collection(AppConstant.chatCollection)
        .doc(chatId)
        .collection(AppConstant.messagesCollection)
        .orderBy('timesTamp',descending:true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((d) {
        final data = d.data();
        try {
          return MessageModel.fromFireStore(d.id, data);
        } catch (e) {
          return MessageModel(
            id: d.id,
            senderId: 'debug_sender',
            text: 'Debug message',
            timestamp: (data['timesTamp'] as Timestamp).toDate(),
          );
        }
      }).toList();
    });
  }


  @override
  Future<void> sendMessage(String chatId, String senderId, String text) async {
    final msgRef = _db
        .collection(AppConstant.chatCollection)
        .doc(chatId)
        .collection(AppConstant.messagesCollection)
        .doc();

    final chatRef = _db.collection(AppConstant.chatCollection).doc(chatId);

    await _db.runTransaction((txn) async {
      final chatSnap = await txn.get(chatRef);
      if (!chatSnap.exists) {
        throw Exception('Chat doc missing members. Create it first.');
      }

      // هنا نخزن الرسالة بالـ serverTimestamp
      txn.set(msgRef, {
        'id': msgRef.id,
        'senderId': senderId,
        'text': text,
        'timesTamp': FieldValue.serverTimestamp(),
      });

      // نحدّث آخر رسالة وتوقيت الشات
      txn.update(chatRef, {
        'lastMessage': text,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  @override
  Future<void> ensureChat(String chatId, List<String> members) async {
    final chatRef = _db.collection('chats').doc(chatId);
    final snap = await chatRef.get();

    if (!snap.exists) {
      await chatRef.set({
        'members': members,
        'lastMessage': '',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Stream<List<UserDataEntity>> getAllUsers() {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return UserDataEntity(
          id: doc.id,
          name: data['name'] ?? 'Unknown User',
          avatarUrl: data['avatarUrl'] ?? '',
          lastSeen: data['lastSeen']?.toDate() ?? DateTime.now(),
        );
      }).toList();
    });
  }

  @override
  Future<UserDataEntity?> getUserData(String userId) async {
    try {
      final userDoc = await _db.collection('users').doc(userId).get();
      if (!userDoc.exists) return null;
      final data = userDoc.data()!;
      return UserDataEntity(
        id: userId,
        name: data['name'] ?? 'Unknown User',
        avatarUrl: data['avatarUrl'] ?? '',
        lastSeen: data['lastSeen']?.toDate() ?? DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }
}
