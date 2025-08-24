import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zytronic_task/core/utils/app_colors.dart';
import 'package:zytronic_task/core/utils/constant_manager.dart';
import 'package:zytronic_task/core/widget/custom_dialog.dart';
import 'package:zytronic_task/di/injectable_initializer.dart';
import 'package:zytronic_task/domain/entity/stories_entity.dart';
import 'package:zytronic_task/presentaion/layout/manager/stoy_tab_cubit/story_tab_cubit.dart';
import 'package:zytronic_task/presentaion/layout/manager/stoy_tab_cubit/story_tab_state.dart';
import 'package:zytronic_task/presentaion/layout/tabs/widgets/story_viewer_screen.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final storyTabCubit = getIt.get<StoryTabCubit>();

    return BlocProvider.value(
      value: storyTabCubit..loadStories(),
      child: BlocConsumer<StoryTabCubit, StoryTabState>(
        listener: (context, state) {
          if (state is StoryTabError) {
            DialogUtils.showMessage(
              context: context,
              message: state.message,
              title: "Error",
              postActionName: "Retry",
              postAction: () {
                storyTabCubit.loadStories();
              },
            );
          }
          
          if (state is StoryUploadError) {
            DialogUtils.showMessage(
              context: context,
              message: state.message,
              title: "Upload Error",
              postActionName: "OK",
            );
          }

          if (state is StoryUploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Story uploaded successfully!'),
                backgroundColor: AppColors.primaryColor,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                // My Status Section
                _buildMyStatusSection(context, storyTabCubit, state),
                
                const Divider(height: 1),
                
                // Recent Updates
                Expanded(
                  child: _buildRecentUpdates(context, storyTabCubit, state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMyStatusSection(BuildContext context, StoryTabCubit cubit, StoryTabState state) {
    // Check if current user has stories
    final myStories = cubit.userStories
        .where((userStory) => userStory.userId == AppConstant.userId)
        .toList();
    final hasMyStory = myStories.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Profile picture with add button
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: const Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showAddStoryOptions(context, cubit),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          
          // Text content
          Expanded(
            child: GestureDetector(
              onTap: hasMyStory 
                  ? () => _openMyStories(context, myStories.first, cubit)
                  : () => _showAddStoryOptions(context, cubit),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My status',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasMyStory ? 'Tap to view your status' : 'Tap to add status update',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Camera button
          GestureDetector(
            onTap: () => _showAddStoryOptions(context, cubit),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.camera_alt,
                color: AppColors.primaryColor,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentUpdates(BuildContext context, StoryTabCubit cubit, StoryTabState state) {
    if (state is StoryTabLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    final otherUserStories = cubit.userStories
        .where((userStory) => userStory.userId != AppConstant.userId)
        .toList();

    if (otherUserStories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No recent updates',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Stories from your contacts will appear here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Recent updates',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: otherUserStories.length,
            itemBuilder: (context, index) {
              final userStory = otherUserStories[index];
              return _buildStoryListItem(context, userStory, cubit);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStoryListItem(BuildContext context, UserStoryEntity userStory, StoryTabCubit cubit) {
    final latestStory = userStory.latestStory;
    if (latestStory == null) return const SizedBox.shrink();

    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: userStory.hasUnviewedStories 
                ? AppColors.primaryColor 
                : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: ClipOval(
          child: Container(
            color: AppColors.primaryColor.withOpacity(0.1),
            child: Center(
              child: Text(
                userStory.userName.isNotEmpty 
                    ? userStory.userName[0].toUpperCase() 
                    : '?',
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
      title: Text(
        userStory.userName,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        _formatTime(latestStory.createdAt),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 13,
        ),
      ),
      onTap: () => _openStoryViewer(context, userStory, cubit),
    );
  }

  void _showAddStoryOptions(BuildContext context, StoryTabCubit cubit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Add to your status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            
            // Photo option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.photo_library,
                  color: AppColors.primaryColor,
                ),
              ),
              title: const Text('Photo'),
              subtitle: const Text('Share a photo from your gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, cubit);
              },
            ),
            
            // Video option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.videocam,
                  color: AppColors.primaryColor,
                ),
              ),
              title: const Text('Video'),
              subtitle: const Text('Share a video from your gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickVideo(context, cubit);
              },
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _pickImage(BuildContext context, StoryTabCubit cubit) {
    final TextEditingController captionController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Photo Status'),
        content: TextField(
          controller: captionController,
          decoration: const InputDecoration(
            hintText: 'Add a caption (optional)...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final caption = captionController.text.trim();
              cubit.pickAndUploadImage(
                caption: caption.isEmpty ? null : caption,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: const Text(
              'Select Photo',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _pickVideo(BuildContext context, StoryTabCubit cubit) {
    final TextEditingController captionController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Video Status'),
        content: TextField(
          controller: captionController,
          decoration: const InputDecoration(
            hintText: 'Add a caption (optional)...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final caption = captionController.text.trim();
              cubit.pickAndUploadVideo(
                caption: caption.isEmpty ? null : caption,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: const Text(
              'Select Video',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _openMyStories(BuildContext context, UserStoryEntity userStory, StoryTabCubit cubit) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StoryViewerScreen(
          stories: userStory.stories,
          onStoryViewed: (storyId) {
            cubit.markStoryAsViewed(storyId);
          },
          onComplete: () {
            // Story viewing completed
          },
        ),
      ),
    );
  }

  void _openStoryViewer(BuildContext context, UserStoryEntity userStory, StoryTabCubit cubit) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StoryViewerScreen(
          stories: userStory.stories,
          onStoryViewed: (storyId) {
            cubit.markStoryAsViewed(storyId);
          },
          onComplete: () {
            // Story viewing completed
          },
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
