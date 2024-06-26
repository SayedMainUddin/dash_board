
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/departments.dart';
import 'package:dash_board/utils/encrypt.dart';
import 'package:dash_board/widgets/popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
class CreateUserModal extends StatefulWidget {
  @override
  _CreateUserModalState createState() => _CreateUserModalState();
}

class _CreateUserModalState extends State<CreateUserModal> {


  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  DateTime selectedDate=DateTime.now();
  var genderRadioBtnVal = "Male";
  void _handleGenderChange(String? value) {
    setState(() {
      genderRadioBtnVal = value!;

    });

    print("gender:$value");
  }
  Future<List<Department>>? departments;
  Department? selectedDepartment;

  final ApiController apiController =ApiController();
  @override
  void initState() {
    // TODO: implement initState
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
          width: MediaQuery.of(context).size.width*0.60,
         // height: MediaQuery.of(context).size.height*0.80,
          decoration: BoxDecoration(
            color:Get.isDarkMode? Colors.black:Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color:Get.isDarkMode? Colors.white:Colors.black,
            )
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Text(
                    'Add User',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color:Get.isDarkMode? Colors.white:Colors.black,
                    ),
                  ),
                  IconButton(onPressed: (){
                    Get.back();
                  }, icon: Icon(Icons.highlight_remove_rounded,color: Colors.red,))
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
                      dropdownColor: Get.isDarkMode? Colors.black:Colors.white,
                      iconSize: 30.0,
                      icon: Icon(Icons.arrow_drop_down,
                        color:Get.isDarkMode? Colors.white:Colors.black,),
                      style: TextStyle(color: Colors.blue),
                      hint: selectedDepartment == null
                          ? Text('Departments',
                      style: TextStyle(
                          color:Get.isDarkMode? Colors.white:Colors.black,
                        fontSize: 15
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
                                color:Get.isDarkMode? Colors.white:Colors.black,
                              fontSize: 20
                            ),),
                        );
                      }).toList(),
                    );
                  }
                },
              ),

              TextField(
                controller: firstnameController,
                style: TextStyle(
                    color:Get.isDarkMode?Colors.white: Colors.black
                ),
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastnameController,
                style: TextStyle(
                    color:Get.isDarkMode?Colors.white: Colors.black
                ),
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: userNameController,
                style: TextStyle(
                    color:Get.isDarkMode?Colors.white: Colors.black
                ),
                decoration: InputDecoration(labelText: 'username'),
              ),
              TextField(
                controller: emailController,
                style: TextStyle(
                    color:Get.isDarkMode?Colors.white: Colors.black
                ),
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: mobileController,
                style: TextStyle(
                    color:Get.isDarkMode?Colors.white: Colors.black
                ),
                decoration: InputDecoration(labelText: 'Mobile Number'),
              ),
              TextField(
                controller: addressController,
                style: TextStyle(
                    color:Get.isDarkMode?Colors.white: Colors.black
                ),
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: passwordController,
                style: TextStyle(
                    color:Get.isDarkMode?Colors.white: Colors.black
                ),
                decoration: InputDecoration(labelText: 'Password'),
              ),
              Container(
                // decoration: BoxDecoration(
                //
                //     border: Border.all(
                //         color: Colors.black45
                //     ),
                //     borderRadius: BorderRadius.circular(15)
                // ),
                alignment: Alignment.centerLeft,
                child: new TextButton.icon(

                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                        }
                        return null; // Use the component's default.
                      },
                    ),
                  ),
                  icon: Icon(Icons.date_range,
                    color: Get.isDarkMode?Colors.white: Colors.black
                  ),
                  //icon image
                  label: Text(
                    "Date Of Birth:" + selectedDate.toString().split(' ')[0],
                    style: TextStyle(
                      color:Get.isDarkMode? Colors.white:Colors.black,
                    ),
                  ),

                  onPressed: () async {

                    DateTime? date = await showDatePicker(
                      context: context,
                      lastDate: DateTime.now().add(Duration(days: 1)),
                      firstDate: DateTime(1900),
                      initialDate: DateTime.now(),
                    );

                    if (date != null) {
                  setState(() {
                    selectedDate=date;
                  });
                  print(selectedDate);

                    }
                  },
                ),

              ),
              Divider(),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      'Select Gender :',
                      style: new TextStyle(fontSize: 15.0,
                        color:Get.isDarkMode? Colors.white:Colors.black,
                      ),
                    ),
                    Radio<String>(
                      value: "Male",
                      activeColor: Theme.of(context).primaryColor,
                      groupValue: genderRadioBtnVal,
                      onChanged: _handleGenderChange,

                    ),
                    Text("Male"),
                    Radio<String>(
                      value: "Female",

                      groupValue: genderRadioBtnVal,
                      onChanged: _handleGenderChange,
                    ),
                    Text("Female"),
                    // Radio<String>(
                    //   value: "Other",
                    //   groupValue: genderRadioBtnVal,
                    //   onChanged: _handleGenderChange,
                    // ),
                    // Text("Other"),
                  ],
                ),
              ),
              // Add text fields for other fields as needed
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  encrypt("sayedmainuddin");
                  final DateFormat formatter = DateFormat('dd/MM/yyyy');
                  final String formattedDate = formatter.format(selectedDate);
                  if(selectedDepartment!.name==''||selectedDepartment!.name==null||selectedDepartment!.name.isEmpty||userNameController.text==''||firstnameController.text==''||selectedDate==''||emailController.text==''||mobileController.text==''){
                    showAlerDialog("Warning!", "You have to select department.");
                    // setState(() {
                    //   selectedDepartment!.name=="General";
                    // });
                  }
                  if(emailController.text==''&& passwordController.text==''){
                    showAlerDialog("Worning!", "Email and Password required!");
                  }else{
                    //encrypt("sayedmainuddin");
                   //var  userData="${userNameController.text}|${firstnameController.text}|${lastnameController.text}|${firstnameController.text+" "+lastnameController.text}|${emailController.text}|${passwordController.text}|${formattedDate.toString()}|$genderRadioBtnVal|Active|${mobileController.text}|${addressController.text}|${selectedDepartment!.name}";
                    //String encryptedUserData = encrypt(userData);
                    apiController.createNewUser(context,{"UserName":userNameController.text,"FirstName":firstnameController.text,"LastName":lastnameController.text,"FullName":firstnameController.text+" "+lastnameController.text,"Email":emailController.text,"Password":passwordController.text,"DOB":formattedDate.toString(),"Gender":genderRadioBtnVal,"AccountStatus":"Active","MobileNo":mobileController.text,"Address":addressController.text,"Department":selectedDepartment!.name});
                    //apiController.createNewUser(context,{"EncryptedData":encryptedUserData});

                  }
                  // TODO: Implement user creation logic
                  // You can access the entered values using controllers like userNameController.text
                  Get.back(); // Close the modal
                },
                child: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showCreateUserModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateUserModal();
    },
  );
}