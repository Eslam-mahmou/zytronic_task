import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zytronic_task/core/utils/app_colors.dart';
import 'package:zytronic_task/domain/entity/stories_entity.dart';

class StoryItemWidget extends StatelessWidget {
  final UserStoryEntity userStory;
  final VoidCallback onTap;

  const StoryItemWidget({
    super.key,
    required this.userStory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final latestStory = userStory.latestStory;
    if (latestStory == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            // Story Circle with Image/Video Thumbnail
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: userStory.hasUnviewedStories
                    ? const LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          Color(0xFF34B7F1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                border: userStory.hasUnviewedStories
                    ? null
                    : Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 2,
                      ),
              ),
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(2),
                child: ClipOval(
                  child: _buildStoryThumbnail(latestStory),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // User Name
            SizedBox(
              width: 70,
              child: Text(
                userStory.userName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryThumbnail(StoryEntity story) {
    if (story.type == StoryType.video) {
      return Stack(
        fit: StackFit.expand,
        children: [
          // Video thumbnail (you can implement actual video thumbnail generation)
          CachedNetworkImage(
            imageUrl: story.mediaUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[300],
              child: const Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 30,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[300],
              child: const Icon(
                Icons.videocam,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          // Video play indicator
          const Center(
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      );
    } else {
      // Image story
      return CachedNetworkImage(
        imageUrl: story.mediaUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 30,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.primaryColor.withOpacity(0.2),
          child: Center(
            child: Text(
              story.userName.isNotEmpty ? story.userName[0].toUpperCase() : '?',
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      );
    }
  }
}