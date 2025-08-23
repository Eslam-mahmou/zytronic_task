import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zytronic_task/core/utils/app_colors.dart';
import 'package:zytronic_task/domain/entity/message_entity.dart';

class MessageWidget extends StatelessWidget {
  final MessageEntity message;
  final bool isMe;
  final String? myName;

  const MessageWidget({
    super.key,
    required this.message,
    required this.isMe,
    this.myName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? 64 : 16,
          right: isMe ? 16 : 64,
          top: 4,
          bottom: 4,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.myMessageBubbleColor
              : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe && myName != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  myName!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            Text(
              message.text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isMe ? Colors.white : theme.colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: theme.textTheme.bodySmall?.copyWith(
                color: isMe
                    ? Colors.white.withOpacity(0.7)
                    : theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
}
