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
    print('📱 Loading all user stories...');
    return _firestore
        .collection(AppConstant.storiesCollection)
        .where('expiresAt', isGreaterThan: Timestamp.now())
        .orderBy('expiresAt')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      print('📱 Found ${snapshot.docs.length} stories');
      
      // Group stories by userId
      final Map<String, List<StoryModel>> userStoriesMap = {};
      
      for (var doc in snapshot.docs) {
        try {
          final story = StoryModel.fromFirestore(doc);
          print('📱 Processing story from ${story.userName}: ${story.type}');
          
          if (!story.isExpired) {
            if (userStoriesMap.containsKey(story.userId)) {
              userStoriesMap[story.userId]!.add(story);
            } else {
              userStoriesMap[story.userId] = [story];
            }
          }
        } catch (e) {
          print('❌ Error parsing story: $e');
        }
      }

      // Convert to UserStoryModel list
      final List<UserStoryModel> userStories = [];
      userStoriesMap.forEach((userId, stories) {
        if (stories.isNotEmpty) {
          // Sort stories by creation time
          stories.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          try {
            userStories.add(UserStoryModel.fromStories(stories));
            print('📱 Added user story group for ${stories.first.userName} with ${stories.length} stories');
          } catch (e) {
            print('❌ Error creating user story model: $e');
          }
        }
      });

      // Sort by latest story time
      userStories.sort((a, b) {
        final aLatest = a.latestStory?.createdAt ?? DateTime(0);
        final bLatest = b.latestStory?.createdAt ?? DateTime(0);
        return bLatest.compareTo(aLatest);
      });

      print('📱 Returning ${userStories.length} user story groups');
      return userStories;
    }).handleError((error) {
      print('❌ Error in getAllUserStories: $error');
      return <UserStoryModel>[];
    });
  }

  @override
  Future<String> uploadMedia(File file, String fileName) async {
    try {
      print('📤 Uploading media: $fileName');
      
      if (!file.existsSync()) {
        throw Exception('File does not exist');
      }
      
      final ref = _storage.ref().child('stories').child(fileName);
      final uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: fileName.toLowerCase().contains('.mp4') ? 'video/mp4' : 'image/jpeg',
        ),
      );
      
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      print('✅ Media uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('❌ Failed to upload media: $e');
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
      print('📝 Creating story: ${type.name}');
      
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 24)); // Stories expire after 24 hours

      // Get current user data
      String userName = 'Unknown User';
      try {
        final userData = await _firestore
            .collection(AppConstant.usersCollection)
            .doc(AppConstant.userId)
            .get();
        
        userName = userData.data()?['name'] ?? 'Me';
      } catch (e) {
        print('⚠️ Could not fetch user data, using default name: $e');
        userName = 'Me'; // Default name if user data is not found
      }

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

      final docRef = await _firestore.collection(AppConstant.storiesCollection).add(storyData);
      print('✅ Story created successfully with ID: ${docRef.id}');
    } catch (e) {
      print('❌ Failed to create story: $e');
      throw Exception('Failed to create story: $e');
    }
  }

  @override
  Future<void> markStoryAsViewed(String storyId) async {
    try {
      print('👁️ Marking story as viewed: $storyId');
      await _firestore
          .collection(AppConstant.storiesCollection)
          .doc(storyId)
          .update({'isViewed': true});
      print('✅ Story marked as viewed');
    } catch (e) {
      print('❌ Failed to mark story as viewed: $e');
      // Don't throw here to avoid interrupting the viewing experience
    }
  }

  @override
  Future<void> deleteStory(String storyId) async {
    try {
      print('🗑️ Deleting story: $storyId');
      
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
            print('✅ Media deleted from storage');
          } catch (e) {
            print('⚠️ Failed to delete media from storage: $e');
          }
        }
        
        // Delete from firestore
        await _firestore
            .collection(AppConstant.storiesCollection)
            .doc(storyId)
            .delete();
        print('✅ Story deleted from Firestore');
      }
    } catch (e) {
      print('❌ Failed to delete story: $e');
      throw Exception('Failed to delete story: $e');
    }
  }

  @override
  Stream<List<StoryModel>> getUserStories(String userId) {
    print('📱 Loading stories for user: $userId');
    return _firestore
        .collection(AppConstant.storiesCollection)
        .where('userId', isEqualTo: userId)
        .where('expiresAt', isGreaterThan: Timestamp.now())
        .orderBy('expiresAt')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      final stories = snapshot.docs
          .map((doc) => StoryModel.fromFirestore(doc))
          .where((story) => !story.isExpired)
          .toList();
      
      print('📱 Found ${stories.length} stories for user $userId');
      return stories;
    }).handleError((error) {
      print('❌ Error in getUserStories: $error');
      return <StoryModel>[];
    });
  }
}