import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zytronic_task/core/utils/app_colors.dart';
import 'package:zytronic_task/core/utils/constant_manager.dart';
import 'package:zytronic_task/di/injectable_initializer.dart';
import 'package:zytronic_task/domain/entity/stories_entity.dart';
import 'package:zytronic_task/presentaion/layout/manager/stoy_tab_cubit/story_tab_cubit.dart';
import 'package:zytronic_task/presentaion/layout/manager/stoy_tab_cubit/story_tab_state.dart';
import 'package:zytronic_task/presentaion/layout/tabs/widgets/story_viewer_screen.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storyTabCubit = getIt.get<StoryTabCubit>();

    return BlocProvider.value(
      value: storyTabCubit..loadStories(),
      child: BlocConsumer<StoryTabCubit, StoryTabState>(
        listener: (context, state) {
          if (state is StoryTabError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ خطأ: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
          
          if (state is StoryUploadError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ خطأ في الرفع: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is StoryUploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ تم رفع الاستوري بنجاح!'),
                backgroundColor: AppColors.primaryColor,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      '📸 الستوريز',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Upload Section - VERY VISIBLE
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor.withOpacity(0.1),
                            AppColors.primaryColor.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primaryColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          // Big Icon
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add_circle_outline,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15),
                          
                          // Title
                          const Text(
                            'إضافة استوري جديد',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          const Text(
                            'شارك لحظاتك مع الأصدقاء',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Upload Buttons - VERY BIG
                          Column(
                            children: [
                              // Photo Button
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: ElevatedButton.icon(
                                  onPressed: () => _pickImage(context, storyTabCubit),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    foregroundColor: Colors.white,
                                    elevation: 5,
                                    shadowColor: AppColors.primaryColor.withOpacity(0.3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  icon: const Icon(Icons.photo_camera, size: 30),
                                  label: const Text(
                                    '📸 اختيار صورة',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              
                              // Video Button
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: ElevatedButton.icon(
                                  onPressed: () => _pickVideo(context, storyTabCubit),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    elevation: 5,
                                    shadowColor: Colors.blue.withOpacity(0.3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  icon: const Icon(Icons.videocam, size: 30),
                                  label: const Text(
                                    '🎥 اختيار فيديو',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          // Loading indicator
                          if (state is StoryUploadLoading) ...[
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(color: AppColors.primaryColor),
                                  SizedBox(width: 15),
                                  Text(
                                    'جاري رفع الاستوري...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Stories Section
                    Row(
                      children: [
                        const Text(
                          '📱 الستوريز المتاحة',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        if (state is StoryTabLoading)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryColor,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    
                    // Stories List
                    _buildStoriesSection(context, storyTabCubit, state),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStoriesSection(BuildContext context, StoryTabCubit cubit, StoryTabState state) {
    if (state is StoryTabLoading) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primaryColor),
              SizedBox(height: 16),
              Text(
                'جاري تحميل الستوريز...',
                style: TextStyle(
                  fontSize: 16, 
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final allStories = cubit.userStories;
    
    if (allStories.isEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.photo_library_outlined,
                  size: 40,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'لا توجد ستوريز بعد',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ابدأ بإضافة أول استوري لك من الأزرار أعلاه!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: allStories.map((userStory) {
        final isMyStory = userStory.userId == AppConstant.userId;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: userStory.hasUnviewedStories 
                  ? AppColors.primaryColor 
                  : Colors.grey[300]!,
              width: userStory.hasUnviewedStories ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: userStory.hasUnviewedStories 
                    ? AppColors.primaryColor.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(15),
            leading: Stack(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: userStory.hasUnviewedStories 
                          ? AppColors.primaryColor 
                          : Colors.grey[400]!,
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                    child: Text(
                      userStory.userName.isNotEmpty 
                          ? userStory.userName[0].toUpperCase() 
                          : '?',
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                if (userStory.hasUnviewedStories)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    isMyStory ? '📱 استوريك' : '👤 ${userStory.userName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (isMyStory)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'أنت',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  '📊 ${userStory.stories.length} استوري متاح',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (userStory.latestStory != null)
                  Text(
                    '🕐 ${_formatTime(userStory.latestStory!.createdAt)}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: AppColors.primaryColor,
                size: 30,
              ),
            ),
            onTap: () => _openStoryViewer(context, userStory, cubit),
          ),
        );
      }).toList(),
    );
  }

  void _pickImage(BuildContext context, StoryTabCubit cubit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.photo_camera, color: AppColors.primaryColor),
            SizedBox(width: 10),
            Text('إضافة صورة'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'هل تريد إضافة تعليق على الصورة؟',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: const InputDecoration(
                hintText: 'اكتب تعليق (اختياري)...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
              maxLines: 2,
              onChanged: (value) {
                // Store caption
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.pickAndUploadImage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: const Text(
              'اختيار صورة',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _pickVideo(BuildContext context, StoryTabCubit cubit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.videocam, color: Colors.blue),
            SizedBox(width: 10),
            Text('إضافة فيديو'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'هل تريد إضافة تعليق على الفيديو؟',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: const InputDecoration(
                hintText: 'اكتب تعليق (اختياري)...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.pickAndUploadVideo();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text(
              'اختيار فيديو',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
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
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }
}
