import 'package:dash_board/controllers/api_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateDepartmentModal extends StatefulWidget {
  @override
  _CreateDepartmentModalState createState() => _CreateDepartmentModalState();
}

class _CreateDepartmentModalState extends State<CreateDepartmentModal> {
  TextEditingController _departmentNameController = TextEditingController();
  final ApiController apiController=Get.put(ApiController());
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Department'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _departmentNameController,
            decoration: InputDecoration(labelText: 'Department Name'),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the modal
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Add logic to create department
                  String departmentName = _departmentNameController.text;
                  // Call your method to create the department with the name
                  apiController.createDepartment(departmentName);
                  _departmentNameController.clear();
                  // Close the modal
                  Navigator.of(context).pop();
                },
                child: Text('Create'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showCreateDepartmentModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateDepartmentModal();
    },
  );
}