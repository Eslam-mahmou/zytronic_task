import 'package:flutter/material.dart';
import 'package:zytronic_task/core/app_provider/app_config_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zytronic_task/presentaion/layout/manager/layout_cubit/layout_state.dart';
import 'package:zytronic_task/presentaion/layout/manager/layout_cubit/layout_view_model.dart';
import 'package:zytronic_task/presentaion/layout/manager/stoy_tab_cubit/story_tab_cubit.dart';
import 'package:zytronic_task/di/injectable_initializer.dart';

import '../../../core/utils/app_assets.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool isDarkMode = AppConfigProvider().isDarkMode();

    return BlocProvider(
      create: (context) => LayoutViewModel(),
      child: BlocBuilder<LayoutViewModel, LayoutState > (
    builder: (context, state) {
      var viewModel = context.read<LayoutViewModel>();

      return Scaffold(
        appBar: AppBar(
          title: Text("WhatsApp", style: theme.textTheme.titleMedium),
          actions: [
            // Camera icon - only show on Stories tab and make it functional
            if (viewModel.currentIndex == 1) 
              IconButton(
                onPressed: () => _showCameraOptions(context),
                icon: Icon(
                  Icons.camera_alt_outlined,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              )
            else
              Icon(
                Icons.camera_alt_outlined,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            
            const SizedBox(width: 8),
            Icon(
              Icons.search,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.more_vert,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: viewModel.tabs[viewModel.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: viewModel.currentIndex,
          onTap: (index) {
            viewModel.changeBottomNav(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: const ImageIcon(AssetImage(AppAssets.iconChat)),
              label: "Chats",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: "Status",
            ),
          ],
        ),
      );
    },
    ),
    );
  }

  void _showCameraOptions(BuildContext context) {
    final storyTabCubit = getIt.get<StoryTabCubit>();
    
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
              'Create Status',
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
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.photo_library,
                  color: Colors.green,
                ),
              ),
              title: const Text('Photo'),
              subtitle: const Text('Share a photo from your gallery'),
              onTap: () {
                Navigator.pop(context);
                storyTabCubit.pickAndUploadImage();
              },
            ),
            
            // Video option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.videocam,
                  color: Colors.green,
                ),
              ),
              title: const Text('Video'),
              subtitle: const Text('Share a video from your gallery'),
              onTap: () {
                Navigator.pop(context);
                storyTabCubit.pickAndUploadVideo();
              },
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
