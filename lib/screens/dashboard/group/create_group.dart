
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/screens/dashboard/group/add_groupName.dart';
import 'package:dash_board/screens/dashboard/group/group_controllers/group_controller.dart';
import 'package:dash_board/screens/dashboard/group/select_members.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGroupModal extends StatefulWidget {
  @override
  _CreateUserModalState createState() => _CreateUserModalState();
}

class _CreateUserModalState extends State<CreateGroupModal> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  bool isGroupCreate=false;
  // Add controllers for other fields as needed
  final ApiController apiController =ApiController();
  final GroupController gc=Get.put(GroupController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isGroupCreate=false;
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),

      ),

      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width*0.60,
       //   height: MediaQuery.of(context).size.height*0.90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child:Obx(()=> Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              gc.isMemberAdded.value==false? Container(
                  height: MediaQuery.of(context).size.width*0.30,
                  child: AddMember()):
              Container(
                  height: MediaQuery.of(context).size.width*0.30,
                  child: AddName(groupMemberList: gc.selectedMemberList,)),
              // ElevatedButton(
              //   onPressed: () {
              //     gc.isMemberAdded.value=true;
              //     //apiController.createNewUser({"UserName":userNameController.text,"Email":firstNameController.text,"Password":"1"});
              //     // TODO: Implement user creation logic
              //     // You can access the entered values using controllers like userNameController.text
              //     // Navigator.of(context).pop(); // Close the modal
              //   },
              //   child: Text('Create'),
              // )
/*
              Column(
                children: [
                  Text(
                    'Create User',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: userNameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(labelText: 'First Name'),
                  ),
                  // Add text fields for other fields as needed
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      apiController.createNewUser({"UserName":userNameController.text,"Email":firstNameController.text,"Password":"1"});
                      // TODO: Implement user creation logic
                      // You can access the entered values using controllers like userNameController.text
                      Navigator.of(context).pop(); // Close the modal
                    },
                    child: Text('Create'),
                  ),
                ],
              ),*/
            ],
          )),
        ),
      ),
    );
  }
}

void showCreateUserModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateGroupModal();
    },
  );
}