import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/Groups.dart';
import 'package:dash_board/models/Users.dart';
import 'package:dash_board/screens/dashboard/group/group_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupDetailModal extends StatefulWidget {
  final Group? group;

  GroupDetailModal({this.group});

  @override
  _GroupDetailModalState createState() => _GroupDetailModalState();
}

class _GroupDetailModalState extends State<GroupDetailModal> {
  final ApiController apiController=Get.put(ApiController());
  // final TextEditingController groupNameController = TextEditingController();
  // final TextEditingController groupProfilePic = TextEditingController();
  // final TextEditingController groupPrivacy = TextEditingController();
  // final TextEditingController groupMembers = TextEditingController();
  // final TextEditingController groupAdmin= TextEditingController();
  // Add controllers for other fields as needed

  @override
  void initState() {
    super.initState();

    // Populate controllers with existing user data if available
    if (widget.group != null) {
      // groupNameController.text = widget.group!.groupName ?? '';
      // groupProfilePic.text = widget.group!.groupPic ?? '';
      // groupPrivacy.text = widget.group!.privacy ?? '';
      // groupMembers.text = widget.group!.membersID.toString() ?? '';
      // groupAdmin.text = widget.group!.adminID ?? '';
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
      backgroundColor: Colors.black,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width*0.50,
          decoration: BoxDecoration(
            color: Colors.brown,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              SizedBox(height: 16.0),
              Container(
                height: screenHeight*0.50,
                child: GroupInfoScreen(
                  groupId: widget.group!.id,
                  groupName: widget.group!.groupName,
                  group: widget.group,
                ),
              ),
              // TextField(
              //   controller: groupNameController,
              //   decoration: InputDecoration(labelText: 'Group Name',hintStyle: TextStyle(
              //       color: Colors.black
              //   )),
              //   style: TextStyle(
              //       color: Colors.black
              //   ),
              // ),
              // TextField(
              //   controller: groupProfilePic,
              //   decoration: InputDecoration(labelText: 'Group Profile'),
              //   style: TextStyle(
              //       color: Colors.black
              //   ),
              // ),
              // TextField(
              //   controller: groupPrivacy,
              //   decoration: InputDecoration(labelText: 'Privacy'),
              //   style: TextStyle(
              //       color: Colors.black
              //   ),
              // ),
              // TextField(
              //   controller: groupMembers,
              //   decoration: InputDecoration(labelText: 'Members'),
              //   style: TextStyle(
              //       color: Colors.black
              //   ),
              // ),
              // TextField(
              //   controller: groupAdmin,
              //   decoration: InputDecoration(labelText: 'Admin'),
              //   style: TextStyle(
              //       color: Colors.black
              //   ),
              // ),
              // Add text fields for other fields as needed
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showgroupDetailModal(BuildContext context, {Group? group}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return GroupDetailModal(group: group);
    },
  );
}
