import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:zytronic_task/core/utils/app_colors.dart';
import 'package:zytronic_task/core/utils/constant_manager.dart';
import 'package:zytronic_task/di/injectable_initializer.dart';
import 'package:zytronic_task/presentaion/layout/manager/home_tab_cubit/home_tab_view_model.dart';

import '../../../core/routes/routes_page.dart';
import '../../../core/widget/custom_dialog.dart';
import '../manager/home_tab_cubit/home_tab_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var viewmodel = getIt.get<HomeChatCubit>();
    return BlocConsumer<HomeChatCubit, HomeState>(
      bloc: viewmodel
        ..loadUsers()
        ..loadChats(AppConstant.userId),
      listener: (context, state) {
        if (state is HomeError) {
          DialogUtils.showMessage(
            context: context,
            message: state.message,
            title: "Error",
            postActionName: "Retry",
            postAction: () {
              viewmodel.loadUsers();
            },
          );
        }
        if (state is HomeChatError) {
          DialogUtils.showMessage(
            context: context,
            message: state.message,
            title: "Error",
            postActionName: "Retry",
            postAction: () {
              viewmodel.loadChats(AppConstant.userId);
            },
          );
        }
      },
      builder: (context, state) {
        return state is HomeLoadingState || state is HomeChatLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              )
            : state is HomeChatLoaded && viewmodel.users.isNotEmpty
            ? ListView.separated(
                itemCount: viewmodel.chats.length,
                separatorBuilder: (context, index) => Divider(
                  height: 0.5,
                  color: theme.colorScheme.outline.withOpacity(0.1),
                  indent: 80,
                ),
                itemBuilder: (context, index) {
                  final chat = viewmodel.chats[index];
                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutesPage.chatScreen,
                        arguments: chat,
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                      child: Text(
                        chat.anotherPerson.name.isNotEmpty
                            ? chat.anotherPerson.name[0].toUpperCase()
                            : "?",
                        style: const TextStyle(color: AppColors.primaryColor),
                      ),
                    ),
                    title: Text(
                      chat.anotherPerson.name,
                      style: theme.textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      chat.lastMessage,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      timeago.format(chat.updatedAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              )
            : Center(child: Text("No users available"));
      },
    );
  }
}
