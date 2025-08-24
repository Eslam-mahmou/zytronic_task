import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/stories_entity.dart';

class StoryModel extends StoryEntity {
  const StoryModel({
    required super.id,
    required super.userId,
    required super.mediaUrl,
    required super.createdAt,
  });

  factory StoryModel.fromFireStore(String id, Map<String, dynamic> json) {
    return StoryModel(
      id: id,
      userId: json['userId'] ?? '',
      mediaUrl: json['mediaUrl'] ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate()
          ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'mediaUrl': mediaUrl,
    'createdAt': FieldValue.serverTimestamp(),
  };
}
