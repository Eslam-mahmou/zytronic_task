import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zytronic_task/core/utils/app_colors.dart';
import 'package:zytronic_task/domain/entity/chat_entity.dart';

class ChatItemWidget extends StatelessWidget {
  final ChatUserEntity chat;
  final VoidCallback onTap;

  const ChatItemWidget({super.key, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.primaryColor.withOpacity(0.2),
          backgroundImage: chat.anotherPerson.avatarUrl.isNotEmpty
              ? NetworkImage(chat.anotherPerson.avatarUrl)
              : null,
          child: chat.anotherPerson.avatarUrl.isEmpty
              ? Text(
                  chat.anotherPerson.name[0].toUpperCase(),
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
              : null,
        ),
      ),
      title: Text(
        chat.anotherPerson.name,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        chat.lastMessage.isNotEmpty ? chat.lastMessage : 'No messages yet',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          fontWeight: chat.lastMessage.isNotEmpty
              ? FontWeight.w500
              : FontWeight.w400,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(chat.updatedAt),
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          if (chat.lastMessage.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '1',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 4),
          // Online indicator
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.onlineIndicatorColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.scaffoldBackgroundColor,
                width: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return DateFormat('MMM dd').format(dateTime);
    } else if (difference.inHours > 0) {
      return DateFormat('HH:mm').format(dateTime);
    } else {
      return 'now';
    }
  }
}
