class Activity {
  final String? activityId;
  final String? activityType;
  final String? activityDetails;
  final String? senderId;
  final String? receiverId;
  final String? groupId;
  final String? senderName;
  final String? receiverName;
  final String? actionDate;

  Activity({
    this.receiverName,
    this.senderName,
    this.senderId,
    this.receiverId,
    this.actionDate,
    this.activityDetails,
    this.activityId,
    this.activityType,
    this.groupId,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      activityId: json['_id'] ?? '',
      activityType: json['Type'] ?? '',
      activityDetails: json['Message'] ?? '',
      senderId: json['SenderID'] ?? '',
      receiverId: json['ReceiverId'] ?? '',
      groupId: json['GroupId'] ?? '',
      senderName: json['SenderName'] ?? '',
      receiverName: json['ReceiverName'] ?? '',
      actionDate: json['DateTime'] ?? '',
    );
  }
}
