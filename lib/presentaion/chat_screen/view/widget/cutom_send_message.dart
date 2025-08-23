import 'package:flutter/material.dart';
import 'package:zytronic_task/core/responseve_screen/responseve_height_width.dart';
import 'package:zytronic_task/core/utils/constant_manager.dart';

import '../../../../core/utils/app_colors.dart';
import '../../manager/chat_screen_view_model.dart' show ChatCubit;

class CustomSendMessage extends StatelessWidget {
  final ChatCubit cubit;
  final String chatId;

  const CustomSendMessage({
    super.key,
    required this.cubit,
    required this.chatId,

  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: cubit.messageController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Type a message...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
             SizedBox(width: 8.widthResponsive),
            IconButton(
              icon: const Icon(
                Icons.send,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                cubit.sendMessage(chatId, AppConstant.userId);
              },
            ),
          ],
        ),
      ),
    );
  }
}
