import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zytronic_task/core/utils/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.whiteColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.roboto(
        color: AppColors.blackColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    textTheme: TextTheme(
      titleMedium: GoogleFonts.roboto(
        color: AppColors.blackColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: GoogleFonts.roboto(
        color: AppColors.blackColor,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      bodyMedium: GoogleFonts.roboto(
        color: AppColors.blackColor,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: GoogleFonts.roboto(
        color: AppColors.blackColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.unSelectedColor,
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      surface: AppColors.whiteColor,
      surfaceVariant: AppColors.messageBubbleColor,
      outline: AppColors.unSelectedColor,
    ),
  );
  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.blackColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.blackColor,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.roboto(
        color: AppColors.whiteColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    textTheme: TextTheme(
      titleMedium: GoogleFonts.roboto(
        color: AppColors.whiteColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: GoogleFonts.roboto(
        color: AppColors.whiteColor,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      bodyMedium: GoogleFonts.roboto(
        color: AppColors.whiteColor,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: GoogleFonts.roboto(
        color: AppColors.whiteColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.unSelectedColor,
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryColor,
      surface: AppColors.blackColor,
      surfaceVariant: Colors.grey[800]!,
      outline: AppColors.unSelectedColor,
    ),
  );
}
