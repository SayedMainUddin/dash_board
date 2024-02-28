import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/Users.dart';
import 'package:dash_board/models/departments.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDetailModal extends StatefulWidget {
  final User? user;

  UserDetailModal({this.user});

  @override
  _UserDetailModalState createState() => _UserDetailModalState();
}

class _UserDetailModalState extends State<UserDetailModal> {
  final ApiController apiController=Get.put(ApiController());
  // Add controllers for other fields as needed
  Future<List<Department>>? departments;
  Department? selectedDepartment;
  @override
  void initState() {
    super.initState();
    departments = apiController.getAllDepartments();

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
          width: MediaQuery.of(context).size.width*0.40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Text("User Details",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                  IconButton(onPressed: (){
                    Get.back();
                  }, icon: Icon(Icons.close))
                ],
              ),
              SizedBox(height: 16.0),
              _userWidget("Department:",widget.user!.userDepartment!??""),
              _userWidget("Full Name:",widget.user!.userName!??""),
              _userWidget("Email:",widget.user!.email!??""),
              _userWidget("Mobile:",widget.user!.mobile!??""),
              _userWidget("Address:",widget.user!.address!??""),
              _userWidget("DOB:",widget.user!.dob!??""),
              _userWidget("Gender:",widget.user!.gender!??""),
              _userWidget("Created Date:",widget.user!.time!.toString()),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the modal
                },
                child: Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  _userWidget(fieldName,fieldValue){
    return Container(
      width: Get.width,
      height: Get.height*0.06,
      child: Column(
        children: [
          Row(
            children: [
             Container(
               width: Get.width*0.10,
               child:  Text(fieldName,style: TextStyle(
                   color: Colors.black,
                   fontSize: 16
               ),),
             ),
              SizedBox(width: 20,),
              Text(fieldValue,style: TextStyle(
                  color: Colors.black,
                  fontSize: 16
              ),),
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}

void showUserDetailModal(BuildContext context, {User? user}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return UserDetailModal(user: user);
    },
  );
}
