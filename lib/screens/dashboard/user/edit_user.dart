import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/Users.dart';
import 'package:dash_board/models/departments.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserEditModal extends StatefulWidget {
  final User? user;

  UserEditModal({this.user});

  @override
  _UserDetailModalState createState() => _UserDetailModalState();
}

class _UserDetailModalState extends State<UserEditModal> {
  final ApiController apiController=Get.put(ApiController());
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userDepartmentController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userContactNumber= TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // Add controllers for other fields as needed
  Future<List<Department>>? departments;
  Department? selectedDepartment;
  @override
  void initState() {
    super.initState();
    departments = apiController.getAllDepartments();
    // Populate controllers with existing user data if available
    if (widget.user != null) {
      userNameController.text = widget.user!.userName ?? '';
      userEmailController.text = widget.user!.email ?? '';
      userContactNumber.text = widget.user!.mobile ?? '';
      passwordController.text = widget.user!.password ?? '';
      userDepartmentController.text = widget.user!.userDepartment ?? '';
      // selectedDepartment!.name=userDepartmentController.text;

    }
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
                  Text(
                    widget.user == null ? 'Create User' : 'Edit User',
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
              FutureBuilder<List<Department>>(
                future: departments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Department> departmentList = snapshot.data!;
                    return DropdownButton<Department>(
                      value: selectedDepartment,
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      iconSize: 30.0,
                      icon: Icon(Icons.arrow_drop_down,
                        color: Colors.black,),
                      style: TextStyle(color: Colors.blue),
                      hint: selectedDepartment == null
                          ? Text(userDepartmentController.text,
                        style: TextStyle(
                            color: Colors.black45
                        ),)
                          : Text(
                        selectedDepartment!.name,
                        style: TextStyle(color: Colors.blue),
                      ),
                      onChanged: (Department? newValue) {
                        setState(() {
                          selectedDepartment = newValue;
                          print(selectedDepartment!.name);
                        });
                      },
                      items: departmentList.map((Department department) {
                        return DropdownMenuItem<Department>(
                          value: department,
                          child: Text(department.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20
                            ),),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
              // TextField(
              //   controller: userDepartmentController,
              //   decoration: InputDecoration(labelText: 'Department',hintStyle: TextStyle(
              //       color: Colors.black
              //   )),
              //   style: TextStyle(
              //       color: Colors.black
              //   ),
              // ),
              TextField(
                controller: userNameController,
                decoration: InputDecoration(labelText: 'Username',hintStyle: TextStyle(
                    color: Colors.black
                )),
                style: TextStyle(
                    color: Colors.black
                ),
              ),
              TextField(
                controller: userEmailController,
                decoration: InputDecoration(labelText: 'Email'),
                style: TextStyle(
                    color: Colors.black
                ),
              ),
              TextField(
                controller: userContactNumber,
                decoration: InputDecoration(labelText: 'Mobile Number'),
                style: TextStyle(
                    color: Colors.black
                ),
              ),
              // Add text fields for other fields as needed
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  apiController.updateUser({"UserId":widget.user?.userId,"UserName":userNameController.text,"Department":selectedDepartment!.name,"Email":userEmailController.text,"MobileNo":userContactNumber.text});
                  // TODO: Implement user creation or update logic
                  // You can access the entered values using controllers like userNameController.text
                  Navigator.of(context).pop(); // Close the modal
                },
                child: Text(widget.user == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showUserEditModal(BuildContext context, {User? user}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return UserEditModal(user: user);
    },
  );
}
