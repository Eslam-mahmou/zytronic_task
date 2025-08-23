import 'package:flutter/material.dart';
import 'package:zytronic_task/core/routes/routes_page.dart';
import 'package:zytronic_task/presentaion/layout/view/layout_screen.dart';

class RoutesGenerator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesPage.layoutScreen:
        return MaterialPageRoute(
          builder: (context) => const LayoutScreen(),
          settings: settings,
        );
      default:
        return unDefinedRoute();
    }
  }
}

Route<dynamic> unDefinedRoute() {
  return MaterialPageRoute(
    builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Un defined route"),
          centerTitle: true,
        ),
        body: const Center(child: Text("Un defined route")),
      );
    },
  );
}
