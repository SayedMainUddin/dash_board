import 'package:flutter/material.dart';

class MuteUserModal extends StatelessWidget {
  final VoidCallback onDelete;

  MuteUserModal({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Mute User Account'),
      content: Text('Are you sure you want to mute this user account?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the modal
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onDelete(); // Callback to delete the user
            Navigator.of(context).pop(); // Close the modal
          },
          child: Text('Mute'),
        ),
      ],
    );
  }
}

void showMuteUserModal(BuildContext context, VoidCallback onDelete) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return MuteUserModal(onDelete: onDelete);
    },
  );
}

class UnMuteUserModal extends StatelessWidget {
  final VoidCallback onDelete;

  UnMuteUserModal({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('UnMute User Account'),
      content: Text('Are you sure you want to unmute this user account?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the modal
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onDelete(); // Callback to delete the user
            Navigator.of(context).pop(); // Close the modal
          },
          child: Text('UnMute'),
        ),
      ],
    );
  }
}

void showUnMuteUserModal(BuildContext context, VoidCallback onDelete) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return UnMuteUserModal(onDelete: onDelete);
    },
  );
}