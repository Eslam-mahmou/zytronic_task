import 'package:flutter/material.dart';
import 'package:zytronic_task/core/routes/routes_page.dart';
import 'package:zytronic_task/presentaion/layout/view/layout_screen.dart';

import '../../presentaion/chat_screen/view/chat_screen.dart';
import '../../presentaion/layout/tabs/widgets/story_viewer_screen.dart';

class RoutesGenerator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesPage.layoutScreen:
        return MaterialPageRoute(
          builder: (context) => const LayoutScreen(),
          settings: settings,
        );
      case RoutesPage.chatScreen:
        return MaterialPageRoute(
          builder: (context) =>  ChatScreen(),
          settings: settings,
        );
      case RoutesPage.storyViewerScreen:
        return MaterialPageRoute(
          builder: (context) => StoryViewerScreen(
            stories: settings.arguments as List,
          ),
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
