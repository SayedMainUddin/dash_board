class NotificationModel {
  final String notificationId;
  final String? notificationTitle;
  final String? notificationDescription;
  final String? senderId;
  final String? senderName;
  final DateTime? deadline;

  NotificationModel({required this.notificationId, this.notificationTitle,  this.notificationDescription,this.senderId,this.senderName,this.deadline});
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['_id'] ?? '',
      notificationTitle:json['NotificationTitle'] ?? '',
      notificationDescription: json['NotificationDescription'] ?? '',
      senderId: json['SenderId'] ?? '',
      senderName: json['SenderName'] ?? '',
      deadline: DateTime.parse(json['NotificationDeadLine'] ?? ''),
    );
  }
}
