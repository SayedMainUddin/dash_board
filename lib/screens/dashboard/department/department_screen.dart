import 'package:dash_board/constants.dart';
import 'package:dash_board/controllers/MenuAppController.dart';
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/departments.dart';
import 'package:dash_board/responsive.dart';
import 'package:dash_board/screens/dashboard/department/components/callback.dart';
import 'package:dash_board/screens/dashboard/department/components/departmentHeadModal.dart';
import 'package:dash_board/screens/dashboard/department/components/userList.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/Users.dart';



class DepartmentPage extends StatefulWidget {
  @override
  _DepartmentPageState createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  //List<Department> departments = []; // Your list of categories
  final MenuAppController menuAppController=Get.put(MenuAppController());

  final ApiController apiController=Get.put(ApiController());
  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child:Column(
          children: [
            Row(
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
                  label: Text("Add Department"),
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
                  return DepartmentListTable(
                    departmentList:departments
                  );

                }
              },
            ),
          ],
        ),
      ),
    );
  }





}








