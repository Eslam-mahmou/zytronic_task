import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytronic_task/core/app_provider/app_config_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zytronic_task/core/responseve_screen/responseve_height_width.dart';
import 'package:zytronic_task/core/utils/constant_manager.dart';
import 'package:zytronic_task/di/injectable_initializer.dart';
import 'package:zytronic_task/presentaion/layout/manager/layout_cubit/layout_state.dart';
import 'package:zytronic_task/presentaion/layout/manager/layout_cubit/layout_view_model.dart';

import '../../../core/utils/app_assets.dart';
import '../manager/stoy_tab_cubit/story_tab_cubit.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var provider = Provider.of<AppConfigProvider>(context);
    bool isDarkMode = provider.isDarkMode();
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
                SizedBox(width: 8.widthResponsive),
                Icon(
                  Icons.search,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                SizedBox(width: 8.widthResponsive),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        var provider = Provider.of<AppConfigProvider>(context,listen: false);
                        ThemeMode selectedTheme = provider.currentTheme;

                        return AlertDialog(
                          backgroundColor: Colors.grey,
                          title: Text("Theme Mode"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RadioListTile<ThemeMode>(
                                title: Text("Light",
                                ),
                                value: ThemeMode.light,
                                groupValue: selectedTheme,
                                onChanged: (value) {
                                  if (value != null) {
                                    provider.changeTheme(value);
                                    provider.currentTheme = value;
                                    provider.saveTheme(value);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                              RadioListTile<ThemeMode>(

                                title: Text("Dark"),
                                value: ThemeMode.dark,
                                groupValue: selectedTheme,
                                onChanged: (value) {
                                  if (value != null) {
                                    provider.changeTheme(value);
                                    provider.currentTheme = value;
                                    provider.saveTheme(value);
                                    Navigator.pop(context);
                                    log(value.toString());
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },

                  child: Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(width: 8.widthResponsive),
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                getIt.get<StoryCubit>().pickAndUploadStory(AppConstant.userId);
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
