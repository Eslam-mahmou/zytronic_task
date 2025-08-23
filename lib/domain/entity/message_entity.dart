class MessageEntity {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;


  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });
}