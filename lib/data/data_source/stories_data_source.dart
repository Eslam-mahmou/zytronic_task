import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:zytronic_task/core/utils/constant_manager.dart';

import '../../domain/entity/stories_entity.dart';
import '../model/stories_model.dart';

abstract class StoryDataSource {
  Stream<List<StoryEntity>> streamActiveStories();

  Future<void> addStory({required String userId, required File mediaUrl});
}

@Injectable(as: StoryDataSource)
class StoryDataSourceImpl implements StoryDataSource {
  final _db = FirebaseFirestore.instance;

  @override
  Stream<List<StoryEntity>> streamActiveStories() {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    return _db
        .collection(AppConstant.storiesCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
          final list = snap.docs
              .map((d) {
                final data = d.data();
                try {
                  return StoryModel.fromFireStore(d.id, data);
                } catch (_) {
                  return null;
                }
              })
              .whereType<StoryEntity>()
              .toList();
          return list.where((s) => s.createdAt.isAfter(cutoff)).toList();
        });
  }

  @override
  Future<void> addStory({
    required String userId,
    required File mediaUrl,
  }) async {
    try {
      log("🚀 Start uploading story for user $userId from file: ${mediaUrl.path}");

      final storageRef = FirebaseStorage.instance
          .ref()
          .child(AppConstant.storiesCollection)
          .child(userId)
          .child("${DateTime.now().millisecondsSinceEpoch}.jpg");

      log("📂 Storage path: ${storageRef.fullPath}");

      final uploadTask = storageRef.putFile(mediaUrl);

      // نسمع للـ events
      uploadTask.snapshotEvents.listen((event) {
        log("⬆️ Upload state: ${event.state}, transferred: ${event.bytesTransferred}/${event.totalBytes}");
      });

      final snapshot = await uploadTask;
      log("✅ Upload completed");

      final downloadUrl = await snapshot.ref.getDownloadURL();
      log("🌍 File URL: $downloadUrl");

      final doc = _db.collection(AppConstant.storiesCollection).doc();
      await doc.set({
        'userId': userId,
        'mediaUrl': downloadUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      log("🔥 Story saved in Firestore");
    } catch (e, st) {
      log("❌ Failed to upload story: $e");
      log("Stacktrace: $st");
      throw Exception("Failed to upload story: $e");
    }
  }

}
