import 'package:dash_board/models/notification.dart';
import 'package:flutter/material.dart';

class NotificationListScreen extends StatelessWidget {
  final List<NotificationModel> notifications = [
    NotificationModel(
      notificationId: "1",
      notificationTitle: 'New Message',
      notificationDescription: 'You have a new message from John Doe.',
    ),
    NotificationModel(
      notificationId: "2",
      notificationTitle: 'Reminder',
      notificationDescription: 'Don\'t forget to attend the meeting at 2 PM.',
    ),
    // Add more notifications as needed
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child:  ListView.builder(
        itemCount: notifications.length,
         shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notifications[index].notificationTitle!),
            subtitle: Text(notifications[index].notificationDescription!),
            onTap: () {
              // Open the detail screen or perform any action when a notification is tapped
              _showNotificationDetail(context, notifications[index]);
            },
          );
        },
      ),
    );
  }

  void _showNotificationDetail(BuildContext context, NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(notification.notificationTitle!),
          content: Text(notification.notificationDescription!),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


