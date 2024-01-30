import 'package:flutter/material.dart';

class DepartmentModal extends StatelessWidget {
  final VoidCallback onDelete;

  DepartmentModal({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Make department head'),
      content: Text('Are you sure you want to make department head this user user?'),
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
          child: Text('Make'),
        ),
      ],
    );
  }
}

void showDepartmentModal(BuildContext context, VoidCallback onDelete) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DepartmentModal(onDelete: onDelete);
    },
  );
}