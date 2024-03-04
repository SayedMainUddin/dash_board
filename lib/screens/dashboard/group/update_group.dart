import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/Groups.dart';
import 'package:dash_board/models/Users.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupUpdateModal extends StatefulWidget {
  final Group? group;

  GroupUpdateModal({this.group});

  @override
  _GroupDetailModalState createState() => _GroupDetailModalState();
}

class _GroupDetailModalState extends State<GroupUpdateModal> {
  final ApiController apiController=Get.put(ApiController());
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController groupProfilePic = TextEditingController();
  final TextEditingController groupPrivacy = TextEditingController();
  final TextEditingController groupMembers = TextEditingController();
  final TextEditingController groupAdmin= TextEditingController();
  // Add controllers for other fields as needed

  @override
  void initState() {
    super.initState();

    // Populate controllers with existing user data if available
    if (widget.group != null) {
      groupNameController.text = widget.group!.groupName ?? '';
      groupProfilePic.text = widget.group!.groupPic ?? '';
      groupPrivacy.text = widget.group!.privacy ?? '';
      groupMembers.text = widget.group!.membersID.toString() ?? '';
      groupAdmin.text = widget.group!.adminID ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width*0.50,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(
                 'Edit Group Name',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              SizedBox(height: 16.0),

              TextField(
                controller: groupNameController,
                decoration: InputDecoration(labelText: 'Group Name',hintStyle: TextStyle(
                    color: Colors.black
                )),
                style: TextStyle(
                    color: Colors.black
                ),
              ),

              // TextField(
              //   controller: groupPrivacy,
              //   decoration: InputDecoration(labelText: 'Privacy'),
              //   style: TextStyle(
              //       color: Colors.black
              //   ),
              // ),

              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  apiController.updateGroup(context,{"GroupId":widget.group?.id,"GroupName":groupNameController.text,"Privacy":groupPrivacy.text});
                  // TODO: Implement user creation or update logic
                  // You can access the entered values using controllers like groupNameController.text
                  Navigator.of(context).pop(); // Close the modal
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showgroupUpdateModal(BuildContext context, {Group? group}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return GroupUpdateModal(group: group);
    },
  );
}
