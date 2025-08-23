import 'package:flutter/material.dart';
import 'package:zytronic_task/core/service/shared_pref_helper.dart';
import 'package:zytronic_task/core/utils/constant_manager.dart';

class AppConfigProvider extends ChangeNotifier {
  ThemeMode currentTheme = ThemeMode.light;
  ThemeMode themeMode = ThemeMode.light;

  void changeTheme(ThemeMode newTheme) {
    if (currentTheme == newTheme) {
      return;
    }
    currentTheme = newTheme;
    notifyListeners();
  }

  bool isDarkMode() {
    return currentTheme == ThemeMode.dark;
  }

  void saveTheme(ThemeMode themeMode) async {
    if (themeMode == ThemeMode.light) {
      SharedPrefHelper.setDate(AppConstant.themeKey, AppConstant.lightTheme);
    } else {
      SharedPrefHelper.setDate(AppConstant.themeKey, AppConstant.darkTheme);
    }
  }

  void getTheme() async {
    String? theme = SharedPrefHelper.getString(AppConstant.themeKey);
    if (theme == AppConstant.lightTheme) {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  //
  // String getBackgroundImage() {
  //   return isDarkMode()
  //       ? ImageAssets.background_dark_view
  //       : ImageAssets.background_view;
  // }
}
