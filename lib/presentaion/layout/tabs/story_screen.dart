import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zytronic_task/core/utils/constant_manager.dart';
import 'package:zytronic_task/presentaion/layout/manager/stoy_tab_cubit/story_tab_cubit.dart';
import 'package:zytronic_task/presentaion/layout/manager/stoy_tab_cubit/story_tab_state.dart';

import '../../../core/widget/custom_dialog.dart';
import '../../../di/injectable_initializer.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var viewmodel = getIt.get<StoryCubit>();
    return BlocConsumer<StoryCubit, StoryState>(
      bloc: viewmodel..loadStories(),
      listener: (context, state) {
        if (state is StoryError) {
          DialogUtils.showMessage(
            context: context,
            message: state.message,
            title: "Error",
            postActionName: "Ok",
          );
        }
        if (state is StoryUploaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Story uploaded successfully")),
          );
        }
      },
      builder: (context, state) {
        if (state is StoryLoading || state is StoryUploading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is StoriesLoaded) {
          final stories = state.stories;
          if (stories.isEmpty) {
            return const Center(child: Text("No stories yet 👀"));
          }

          return ListView.builder(
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(story.mediaUrl??""),
                ),
                title: Text(AppConstant.userId ?? "Unknown"),
                subtitle: Text(story.createdAt.toLocal().toString()),
              );
            },
          );
        }

        return const Center(child: Text("Press + to add a story 📸"));
      },
    );
  }
}
