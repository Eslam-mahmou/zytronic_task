import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:zytronic_task/core/utils/constant_manager.dart';
import 'package:zytronic_task/data/model/stories_model.dart';
import 'package:zytronic_task/domain/entity/stories_entity.dart';

abstract class StoriesDataSource {
  Stream<List<UserStoryModel>> getAllUserStories();
  Future<String> uploadMedia(File file, String fileName);
  Future<void> createStory({
    required String mediaUrl,
    required StoryType type,
    String? caption,
  });
  Future<void> markStoryAsViewed(String storyId);
  Future<void> deleteStory(String storyId);
  Stream<List<StoryModel>> getUserStories(String userId);
}

@Injectable(as: StoriesDataSource)
class StoriesDataSourceImpl implements StoriesDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Stream<List<UserStoryModel>> getAllUserStories() {
    return _firestore
        .collection(AppConstant.storiesCollection)
        .where('expiresAt', isGreaterThan: Timestamp.now())
        .orderBy('expiresAt')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      // Group stories by userId
      final Map<String, List<StoryModel>> userStoriesMap = {};
      
      for (var doc in snapshot.docs) {
        try {
          final story = StoryModel.fromFirestore(doc);
          if (!story.isExpired) {
            if (userStoriesMap.containsKey(story.userId)) {
              userStoriesMap[story.userId]!.add(story);
            } else {
              userStoriesMap[story.userId] = [story];
            }
          }
        } catch (e) {
          print('Error parsing story: $e');
        }
      }

      // Convert to UserStoryModel list
      final List<UserStoryModel> userStories = [];
      userStoriesMap.forEach((userId, stories) {
        if (stories.isNotEmpty) {
          // Sort stories by creation time
          stories.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          userStories.add(UserStoryModel.fromStories(stories));
        }
      });

      // Sort by latest story time
      userStories.sort((a, b) {
        final aLatest = a.latestStory?.createdAt ?? DateTime(0);
        final bLatest = b.latestStory?.createdAt ?? DateTime(0);
        return bLatest.compareTo(aLatest);
      });

      return userStories;
    });
  }

  @override
  Future<String> uploadMedia(File file, String fileName) async {
    try {
      final ref = _storage.ref().child('stories').child(fileName);
      final uploadTask = ref.putFile(file);
      
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload media: $e');
    }
  }

  @override
  Future<void> createStory({
    required String mediaUrl,
    required StoryType type,
    String? caption,
  }) async {
    try {
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 24)); // Stories expire after 24 hours

      // Get current user data (you might want to get this from a user service)
      final userData = await _firestore
          .collection(AppConstant.usersCollection)
          .doc(AppConstant.userId)
          .get();
      
      final userName = userData.data()?['name'] ?? 'Unknown User';

      final storyData = {
        'userId': AppConstant.userId,
        'userName': userName,
        'mediaUrl': mediaUrl,
        'type': type == StoryType.video ? 'video' : 'image',
        'createdAt': Timestamp.fromDate(now),
        'expiresAt': Timestamp.fromDate(expiresAt),
        'isViewed': false,
        'caption': caption,
      };

      await _firestore.collection(AppConstant.storiesCollection).add(storyData);
    } catch (e) {
      throw Exception('Failed to create story: $e');
    }
  }

  @override
  Future<void> markStoryAsViewed(String storyId) async {
    try {
      await _firestore
          .collection(AppConstant.storiesCollection)
          .doc(storyId)
          .update({'isViewed': true});
    } catch (e) {
      throw Exception('Failed to mark story as viewed: $e');
    }
  }

  @override
  Future<void> deleteStory(String storyId) async {
    try {
      // Get story data first to delete media from storage
      final storyDoc = await _firestore
          .collection(AppConstant.storiesCollection)
          .doc(storyId)
          .get();
      
      if (storyDoc.exists) {
        final data = storyDoc.data() as Map<String, dynamic>;
        final mediaUrl = data['mediaUrl'] as String?;
        
        // Delete from storage if mediaUrl exists
        if (mediaUrl != null && mediaUrl.isNotEmpty) {
          try {
            final ref = _storage.refFromURL(mediaUrl);
            await ref.delete();
          } catch (e) {
            print('Failed to delete media from storage: $e');
          }
        }
        
        // Delete from firestore
        await _firestore
            .collection(AppConstant.storiesCollection)
            .doc(storyId)
            .delete();
      }
    } catch (e) {
      throw Exception('Failed to delete story: $e');
    }
  }

  @override
  Stream<List<StoryModel>> getUserStories(String userId) {
    return _firestore
        .collection(AppConstant.storiesCollection)
        .where('userId', isEqualTo: userId)
        .where('expiresAt', isGreaterThan: Timestamp.now())
        .orderBy('expiresAt')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => StoryModel.fromFirestore(doc))
          .where((story) => !story.isExpired)
          .toList();
    });
  }
}