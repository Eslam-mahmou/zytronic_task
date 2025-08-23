import 'package:flutter/material.dart';
import 'package:zytronic_task/core/routes/routes_generator.dart';
import 'package:zytronic_task/core/routes/routes_page.dart';
import 'package:zytronic_task/core/utils/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      onGenerateRoute: RoutesGenerator.onGenerateRoute,
      initialRoute: RoutesPage.layoutScreen,
    );
  }
}
