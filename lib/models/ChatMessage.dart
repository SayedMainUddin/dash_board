class ChatMessage {
  final String? id;
  final String? type;
  final String? message;
  final bool? isSentByUser;
  final String? seenStatus;
  ChatMessage({
     this.id,
     this.type,
     this.message,
     this.isSentByUser,
    this.seenStatus
  });
}
