import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytronic_task/core/routes/routes_generator.dart';
import 'package:zytronic_task/core/routes/routes_page.dart';
import 'package:zytronic_task/core/utils/app_theme.dart';

import 'core/app_provider/app_config_provider.dart';
import 'core/service/bloc_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppConfigProvider()..getTheme(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: provider.themeMode,
      onGenerateRoute: RoutesGenerator.onGenerateRoute,
      initialRoute: RoutesPage.layoutScreen,
    );
  }
}
