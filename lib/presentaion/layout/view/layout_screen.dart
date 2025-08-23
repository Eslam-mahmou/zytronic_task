import 'package:flutter/material.dart';
import 'package:zytronic_task/core/app_provider/app_config_provider.dart';
import 'package:zytronic_task/core/responseve_screen/responseve_height_width.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zytronic_task/presentaion/layout/manager/layout_cubit/layout_state.dart';
import 'package:zytronic_task/presentaion/layout/manager/layout_cubit/layout_view_model.dart';

import '../../../core/utils/app_assets.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool isDarkMode = AppConfigProvider().isDarkMode();
    return BlocProvider(
      create: (context) => LayoutViewModel(),
      child: BlocBuilder<LayoutViewModel, LayoutState>(
        builder: (context, state) {
          var viewModel = context.read<LayoutViewModel>();

          return Scaffold(
            appBar: AppBar(
              title: Text("WhatsApp", style: theme.textTheme.titleMedium),
              actions: [
                Icon(
                  Icons.camera_alt_outlined,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                SizedBox(width: 16.widthResponsive),
                Icon(
                  Icons.search,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                SizedBox(width: 25.widthResponsive),
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
                  icon: Icon(Icons.storm),
                  label: "Story",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
