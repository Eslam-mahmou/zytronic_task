import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zytronic_task/core/utils/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.whiteColor,
    appBarTheme: AppBarTheme(backgroundColor: AppColors.whiteColor),
    textTheme: TextTheme(
      titleMedium:GoogleFonts.roboto(
        color: AppColors.blackColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),

    ),
      bottomNavigationBarTheme:const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.unSelectedColor,

      )
  );
  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.blackColor,
    appBarTheme: AppBarTheme(backgroundColor: AppColors.blackColor),
    textTheme: TextTheme(
      titleMedium:GoogleFonts.roboto(
        color: AppColors.whiteColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
      bottomNavigationBarTheme:const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.unSelectedColor,

      )
  );
}
