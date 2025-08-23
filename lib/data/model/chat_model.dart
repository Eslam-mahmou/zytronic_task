import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zytronic_task/domain/entity/chat_entity.dart';
import 'package:zytronic_task/domain/entity/user_entity.dart';

class ChatUserModel extends ChatUserEntity {
  const ChatUserModel({
    required super.chatId,
    required super.anotherPerson,
    required super.lastMessage,
    required super.updatedAt,
  });

  factory ChatUserModel.fromSnapshot(
    DocumentSnapshot doc, {
    String? currentUserId,
  }) {
    final data = doc.data() as Map<String, dynamic>;

    // Get members list and find the other user
    final List<dynamic> members = data['members'] ?? [];
    String? otherUserId;

    for (String memberId in members.cast<String>()) {
      if (memberId != currentUserId) {
        otherUserId = memberId;
        break;
      }
    }

    return ChatUserModel(
      chatId: doc.id,
      anotherPerson: UserDataEntity(
        id: otherUserId ?? 'unknown_user',
        name:
            otherUserId ??
            'Unknown User', // Will be updated from users collection
        avatarUrl: '',
        lastSeen: DateTime.now(),
      ),
      lastMessage: data['lastMessage'] ?? '',
      updatedAt: data['updatedAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'peer': {
        'id': anotherPerson.id,
        'name': anotherPerson.name,
        'avatarUrl': anotherPerson.avatarUrl,
      },
      'lastMessage': lastMessage,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
