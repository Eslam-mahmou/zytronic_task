import 'package:flutter/material.dart';
import 'package:zytronic_task/core/utils/app_colors.dart';
import 'package:zytronic_task/presentaion/layout/manager/stoy_tab_cubit/story_tab_cubit.dart';

class AddStoryWidget extends StatelessWidget {
  final StoryTabCubit cubit;

  const AddStoryWidget({
    super.key,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Add Story Button
          GestureDetector(
            onTap: () => _showMediaPicker(context),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryColor,
                  width: 3,
                ),
                color: AppColors.primaryColor.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.add,
                color: AppColors.primaryColor,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add Story',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showMediaPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
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
              'Add to Story',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionButton(
                  context: context,
                  icon: Icons.photo_library,
                  label: 'Photo',
                  onTap: () {
                    Navigator.pop(context);
                    _showCaptionDialog(context, isVideo: false);
                  },
                ),
                _buildOptionButton(
                  context: context,
                  icon: Icons.videocam,
                  label: 'Video',
                  onTap: () {
                    Navigator.pop(context);
                    _showCaptionDialog(context, isVideo: true);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCaptionDialog(BuildContext context, {required bool isVideo}) {
    final TextEditingController captionController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isVideo ? 'Add Video Story' : 'Add Photo Story'),
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
              
              if (isVideo) {
                cubit.pickAndUploadVideo(
                  caption: caption.isEmpty ? null : caption,
                );
              } else {
                cubit.pickAndUploadImage(
                  caption: caption.isEmpty ? null : caption,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: const Text(
              'Upload',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}