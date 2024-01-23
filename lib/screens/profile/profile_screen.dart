import 'package:dash_board/constants.dart';
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/Users.dart';
import 'package:dash_board/models/departments.dart';
import 'package:dash_board/responsive.dart';
import 'package:dash_board/screens/profile/profile_controller.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class ProfilePage extends StatefulWidget {

  ProfilePage();
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ApiController apiController=Get.put(ApiController());
  final ProfileController profileController=Get.put(ProfileController());
  final TextEditingController adminUserNameController = TextEditingController();
  final TextEditingController adminFirstNameController = TextEditingController();
  final TextEditingController adminLastNameController = TextEditingController();
  final TextEditingController adminEmailController = TextEditingController();
  final TextEditingController adminMobileNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // Add controllers for other fields as needed
  @override
  void initState() {
    super.initState();
    // Populate controllers with existing user data if available
    if (LocalStorage.ADMINID != null) {
      adminUserNameController.text =     LocalStorage.ADMINNAME ?? '';
      adminEmailController.text =        LocalStorage.AdminEmail ?? '';
      passwordController.text =          LocalStorage.AdminPassword ?? '';
      adminMobileNumberController.text = LocalStorage.AdminMobile ?? '';
      adminFirstNameController.text = LocalStorage.AdminFirstName ?? '';
      adminLastNameController.text = LocalStorage.AdminLastName ?? '';
      // selectedDepartment!.name=userDepartmentController.text;

    }
  }
  @override
  Widget build(BuildContext context) {
    final _height=MediaQuery.of(context).size.height;
    final _width=MediaQuery.of(context).size.width;
    return Container(
      child:  Container(
        // padding: const EdgeInsets.all(16.0),

        child:Row(
          children: [
            if (!Responsive.isMobile(context))

              Container(
                decoration: BoxDecoration(
                    color: Color(0x63D0D0D0)
                ),
                height:_height*0.99,
                width: _width*0.20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height:_height*0.15 ,
                    ),
                    CircleAvatar(

                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            //   color: Colors.red,
                            image: DecorationImage(image: NetworkImage(LocalStorage.ADMINIMAGE ),fit: BoxFit.fill)

                        ),
                      ),
                      radius: 50,
                    ),
                    SizedBox(
                      height:_height*0.05 ,
                    ),
                    ElevatedButton(
                        onPressed: (){
                          profileController.profilePicChange(ImageSource.gallery, context: context);
                        },
                        child: Text('Change Image')
                    )
                  ],
                ),
              ),
            Column(
              children: [
                Container(
                  child: Text("Admin Details",
                      style: TextStyle(
                          fontSize: 22
                      )),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    width: MediaQuery.of(context).size.width*0.60,
                    decoration: BoxDecoration(
                      //   color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 16.0),
                        if (Responsive.isMobile(context))
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0x63D0D0D0)
                            ),
                            height:_height*0.40,
                            width: _width*0.20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                CircleAvatar(

                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        //   color: Colors.red,
                                        image: DecorationImage(image: NetworkImage(LocalStorage.ADMINIMAGE ),fit: BoxFit.fill)

                                    ),
                                  ),
                                  radius: 50,
                                ),
                                SizedBox(
                                  height:_height*0.05 ,
                                ),
                                ElevatedButton(
                                    onPressed: (){

                                    },
                                    child: Text('Change Image')
                                )
                              ],
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!Responsive.isMobile(context))
                              Container(
                                child: Text('User Name:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      //  color: Colors.white,
                                      letterSpacing: 2
                                  ),),
                              ),

                            Container(
                              width: _width*0.40,
                              child:  TextField(
                                controller: adminUserNameController,

                                decoration: InputDecoration(
                                    labelText: "Username"),

                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!Responsive.isMobile(context))
                              Container(
                                child: Text('FirstName:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      //   color: Colors.white,
                                      letterSpacing: 2
                                  ),),
                              ),

                            Container(
                              width: _width*0.40,
                              child:  TextField(
                                controller: adminFirstNameController,

                                decoration: InputDecoration(
                                    labelText: "Firstname"),

                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!Responsive.isMobile(context))
                              Container(
                                child: Text('Last Name:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      // color: Colors.white,
                                      letterSpacing: 2
                                  ),),
                              ),

                            Container(
                              width: _width*0.40,
                              child:  TextField(
                                controller: adminLastNameController,

                                decoration: InputDecoration(
                                    labelText:"Lastname"),

                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!Responsive.isMobile(context))
                              Container(
                                child: Text('Email:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      // color: Colors.white,
                                      letterSpacing: 2
                                  ),),
                              ),

                            Container(
                              width: _width*0.40,
                              child:  TextField(
                                controller: adminEmailController,

                                decoration: InputDecoration(
                                    labelText:"Email"),

                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!Responsive.isMobile(context))
                              Container(
                                child: Text('Mobile Number:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      // color: Colors.white,
                                      letterSpacing: 2
                                  ),),
                              ),

                            Container(
                              width: _width*0.40,
                              child:  TextField(
                                controller: adminMobileNumberController,

                                decoration: InputDecoration(
                                    labelText:"Mobile Number"),

                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!Responsive.isMobile(context))
                              Container(
                                child: Text('Password:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      //   color: Colors.white,
                                      letterSpacing: 2
                                  ),),
                              ),

                            Container(
                              width: _width*0.40,
                              child:  TextField(
                                controller: passwordController,

                                decoration: InputDecoration(
                                    labelText:"Password"),

                              ),
                            ),
                          ],
                        ),

                        // Add text fields for other fields as needed
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            apiController.updateUser({"UserId":LocalStorage.ADMINID,"UserName":adminUserNameController.text,"FirstName":adminFirstNameController.text,"LastName":adminLastNameController.text,"Email":adminEmailController.text,"MobileNo":adminMobileNumberController.text,"Password":passwordController.text});
                            // TODO: Implement user creation or update logic
                            // You can access the entered values using controllers like userNameController.text
                            // Navigator.of(context).pop(); // Close the modal
                          },
                          child: Text('Update'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
            /*  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Department List",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(onPressed: (){
                      setState(() {
                        apiController.getAllDepartments();

                      });
                    }, icon: Icon(Icons.refresh))
                  ],
                ),

                ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                    ),
                  ),
                  onPressed: () {
                    showCreateDepartmentModal(context);
                  },
                  icon: Icon(Icons.add),
                  label: Text("create User"),
                ),

              ],
            ),
            FutureBuilder<List<Department>>(
              future: apiController.getAllDepartments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // If the Future is still running, show a loading indicator
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // If there is an error with the Future, display an error message
                  return Text('Error: ${snapshot.error}');
                } else {
                  // If the Future is complete, display the list of departments
                  final List<Department> departments = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: departments.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final department = departments[index];
                      return ListTile(
                        title: Text(department.name),
                        trailing:  Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Handle edit button tap
                                // Implement the logic to edit the department
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => EditProfilePage(
                                //       department: department,
                                //     ),
                                //   ),
                                // );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Handle delete button tap
                                // Implement the logic to delete the department
                                showDeleteConfirmationDialog(context, department.id);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          // Handle department tap
                          // For example, navigate to a detailed page for the department
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => DepartmentDetailPage(
                          //       department: department,
                          //     ),
                          //   ),
                          // );
                        },
                      );
                    },
                  );
                }
              },
            ),*/
          ],
        ),
      ),
    );
  }

  // Function to show a confirmation dialog for deleting a department
  Future<void> showDeleteConfirmationDialog(BuildContext context, String departmentId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Department'),
          content: Text('Are you sure you want to delete this department?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle delete action
                deleteDepartment(departmentId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Function to delete a department
  Future<void> deleteDepartment(String departmentId) async {
    apiController.deleteDepartment(departmentId);
  }


  Widget infoCard(String? title, String? value, Color? color, IconData? icon,
      bool? isEnabled, TextEditingController? controller, Function? onPressed) {
    return InkWell(
      onTap: onPressed!(),
      child: Container(
        color: isEnabled! ? Get.isDarkMode? Colors.blue:Colors.blueGrey : Colors.transparent,
        margin: EdgeInsets.only(left: 0, right: 20, top: 12, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    title!,
                    style: TextStyle(
                        color:
                        Get.isDarkMode? Colors.white:Colors.black,
                        fontSize: 14),
                  ),
                )
              ],
            ),
            Flexible(
                child: Container(
                  child: TextFormField(
                    controller: controller,
                    enabled: isEnabled,
                    // initialValue: value,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Get.isDarkMode? Colors.white:Colors.indigo,
                    ),
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(3),
                        hintText: "One",
                        // border: OutlineInputBorder()
                        border: InputBorder.none),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}


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
