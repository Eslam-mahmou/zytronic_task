import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zytronic_task/domain/entity/message_entity.dart';


class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.senderId,
    required super.text,
    required super.timestamp,
  });


  factory MessageModel.fromFireStore(String id, Map<String, dynamic> json) {
    return MessageModel(
      id: id,
      senderId: (json['senderId'] ?? '') ,
      text: (json['text'] ?? '') ,
      timestamp: (json['timesTamp'] )?.toDate() ?? DateTime(2000),
    );
  }


  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'text': text,
    'timestamp': FieldValue.serverTimestamp(),
  };
}