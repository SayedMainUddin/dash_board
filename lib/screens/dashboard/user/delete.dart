import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteUserModal extends StatelessWidget {
  final VoidCallback onDelete;

  DeleteUserModal({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete User Account'),
      content: Text('Are you sure you want to delete this user account?'),
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
            Get.back(); // Close the modal
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
}

void showDeleteUserModal(BuildContext context, VoidCallback onDelete) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DeleteUserModal(onDelete: onDelete);
    },
  );
}