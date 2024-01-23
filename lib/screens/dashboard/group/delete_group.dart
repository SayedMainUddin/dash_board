import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteGroupModal extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onDeleted; // Callback for notifying the parent widget about deletion

  DeleteGroupModal({required this.onDelete, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Group'),
      content: Text('Are you sure you want to delete this group?'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close the modal

          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onDelete(); // Callback to delete the group
            onDeleted(); // Notify the parent about deletion
            Get.back(); // Close the modal
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
}

void showDeleteGroupModal(BuildContext context, VoidCallback onDelete, VoidCallback onDeleted) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DeleteGroupModal(onDelete: onDelete, onDeleted: onDeleted);
    },
  );
}
