import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:zytronic_task/core/utils/constant_manager.dart';
import 'package:zytronic_task/presentaion/chat_screen/view/widget/cutom_send_message.dart';
import 'package:zytronic_task/presentaion/chat_screen/view/widget/message_bubble.dart';

import '../../../core/app_provider/app_config_provider.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widget/custom_dialog.dart';
import '../../../di/injectable_initializer.dart';
import '../../../domain/entity/chat_entity.dart';
import '../../../domain/entity/message_entity.dart';
import '../manager/chat_screen_state.dart';
import '../manager/chat_screen_view_model.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = getIt.get<ChatCubit>();
    var args = ModalRoute.of(context)?.settings.arguments as ChatUserEntity;
    var provider = Provider.of<AppConfigProvider>(context);
    bool isDarkMode = provider.isDarkMode();
    return BlocConsumer<ChatCubit, ChatState>(
      bloc: viewmodel..loadMessages(args.chatId),
      listener: (context, state) {
        if (state is MessageErrorState) {
          DialogUtils.showMessage(
            context: context,
            message: state.message,
            title: "Error",
            postActionName: "Ok",
          );
        }
        if (state is ChatErrorState) {
          DialogUtils.showMessage(
            context: context,
            message: state.message,
            title: "Error",
            postActionName: "Ok",
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
            title: Text(args.anotherPerson.name),
            backgroundColor:isDarkMode
                ? AppColors.blackColor
                : AppColors.whiteColor,
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.chatBackground),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: state is ChatLoadingState
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : state is MessagesLoadedState &&
                            state.messages.isNotEmpty
                      ? ListView.builder(
                          reverse: true,
                          padding: const EdgeInsets.all(12),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final MessageEntity msg = state.messages[index];
                            final isMe = msg.senderId ==AppConstant.userId;
                            log("qwfwe ${msg.senderId}");
                            return MessageBubble(isUser: isMe, text: msg.text);
                          },
                        )
                      : const Center(child: Text("No messages yet")),
                ),
                // input box
                CustomSendMessage(
                  cubit: viewmodel,
                  chatId: args.chatId,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
