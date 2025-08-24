import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zytronic_task/core/utils/app_colors.dart';
import 'package:zytronic_task/core/widget/custom_dialog.dart';
import 'package:zytronic_task/di/injectable_initializer.dart';
import 'package:zytronic_task/domain/entity/stories_entity.dart';
import 'package:zytronic_task/presentaion/layout/manager/stoy_tab_cubit/story_tab_cubit.dart';
import 'package:zytronic_task/presentaion/layout/manager/stoy_tab_cubit/story_tab_state.dart';
import 'package:zytronic_task/presentaion/layout/tabs/widgets/add_story_widget.dart';
import 'package:zytronic_task/presentaion/layout/tabs/widgets/story_item_widget.dart';
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
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                // Header with Add Story
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        'Stories',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (state is StoryUploadLoading)
                        Container(
                          width: 20,
                          height: 20,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryColor,
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Stories List
                Expanded(
                  child: _buildStoriesContent(context, state, storyTabCubit),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStoriesContent(
    BuildContext context,
    StoryTabState state,
    StoryTabCubit cubit,
  ) {
    if (state is StoryTabLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (state is StoriesLoaded) {
      final userStories = cubit.userStories;
      
      if (userStories.isEmpty) {
        return _buildEmptyState(cubit);
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Story Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  AddStoryWidget(cubit: cubit),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add to story',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Share photos and videos that disappear after 24 hours',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 32),
            
            // Recent Stories
            if (userStories.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Recent stories',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Stories Grid
              Container(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: userStories.length,
                  itemBuilder: (context, index) {
                    final userStory = userStories[index];
                    return StoryItemWidget(
                      userStory: userStory,
                      onTap: () => _openStoryViewer(context, userStory, cubit),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      );
    }

    // Default empty or error state
    return _buildEmptyState(cubit);
  }

  Widget _buildEmptyState(StoryTabCubit cubit) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          
          // Add Story Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                AddStoryWidget(cubit: cubit),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add to story',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Share photos and videos that disappear after 24 hours',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 60),
          
          // Empty state illustration
          Icon(
            Icons.photo_library_outlined,
            size: 80,
            color: AppColors.primaryColor.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No stories yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start sharing your moments with stories!',
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

  void _openStoryViewer(
    BuildContext context,
    UserStoryEntity userStory,
    StoryTabCubit cubit,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StoryViewerScreen(
          stories: userStory.stories,
          onStoryViewed: (storyId) {
            cubit.markStoryAsViewed(storyId);
          },
          onComplete: () {
            // Story viewing completed - could update UI or analytics
          },
        ),
      ),
    );
  }
}
