import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/screens/dashboard/department/components/callback.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/MenuAppController.dart';
import '../../../../models/Users.dart';
import '../../../../models/departments.dart';

class UserListPopup extends StatefulWidget {
  final List<User> userList;
  final  departmentId;

  UserListPopup({required this.userList,required this.departmentId});

  @override
  _UserListPopupState createState() => _UserListPopupState();
}

class _UserListPopupState extends State<UserListPopup> {
  List<User> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  final ApiController apiController=Get.put(ApiController());
  final MenuAppController menuAppController=Get.put(MenuAppController());
  @override
  void initState() {
    super.initState();
    filteredUsers = widget.userList;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Make Department Head'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(labelText: 'Search by name'),
              onChanged: (String value) {
                // Filter the user list based on the search input
                setState(() {
                  filteredUsers = widget.userList.where((user) {
                    return user.userName?.toLowerCase().contains(value.toLowerCase()) ?? false;
                  }).toList();
                });
              },
            ),
            SizedBox(height: 16),

            Text('Select a user:'),
            SingleChildScrollView(
              child:  Container(
                  width: 400,
                  height: 300,
                  child:  Obx(() => ListView.builder(
                    itemCount: filteredUsers.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      User user = filteredUsers[index];
                      return ListTile(
                        title: Text(user.userName ?? ''),
                        onTap: () {
                          print(user.userId);
                          print(user.userName);
                          print(widget.departmentId);
                          setState(() {

                          });
                        },
                        trailing:     ElevatedButton(onPressed: () async {
                          showDepartmentModal(context, () async{
                            await  apiController.makeDepartmentHead({"UserId":user.userId,"DepartmentId":widget.departmentId,"UserName":user.userName});
                            Navigator.of(context).pop(apiController.getAllDepartments());
                          },

                          );

                        }, child: Text('Make Department Head')),
                      );
                    },
                  ))
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            menuAppController.changeSelectedItem(MenuItem.department);
            getStateChange();
            Navigator.of(context).pop(); // Close the popup
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  getStateChange() async{
    await apiController.getAllDepartments();

    setState(() {
      menuAppController.changeSelectedItem(MenuItem.department);
    });
  }
}

class DepartmentListTable extends StatelessWidget {
  final List<Department> departmentList;
  final ApiController apiController=Get.put(ApiController());
  DepartmentListTable({required this.departmentList});
  final MenuAppController menuAppController=Get.put(MenuAppController());

// Function to delete a department
  Future<void> deleteDepartment(String departmentId) async {
    apiController.deleteDepartment(departmentId);
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
              onPressed: () async {
                menuAppController.changeSelectedItem(MenuItem.department);
                await apiController.getAllDepartments();

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
  void showDepartmentDetails(BuildContext context, String department) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Users in $department Department'),
          content: SingleChildScrollView(
            child: Column(
              children: apiController.userList
                  .where((user) => user.userId!.startsWith(department))
                  .map((user) => ListTile(
                title: Text(user.userName!),
              ))
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
  void showUsersByDepartment(BuildContext context, String departmentName) {
    List<User> usersInDepartment = apiController.userList.where((user) => user.userDepartment == departmentName).toList();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Users in $departmentName Department'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var user in usersInDepartment)
                ListTile(
                 // leading: Image.network("${WebApi.basesUrl}${user.userImageUrl.toString().substring(2)}"),
                  title: Text(user.userName ?? ''),
                  subtitle: Text(user.email??''),
                  trailing: Text(user.mobile??''),
                ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {


    // Map to store department-wise user count
    Map<String, int> departmentCounts = {};

    // Iterate through the userList to count users in each department
    for (var user in apiController.userList) {
      if (departmentCounts.containsKey(user.userDepartment)) {
        departmentCounts[user.userDepartment!] = departmentCounts[user.userDepartment]! + 1;
      } else {
        departmentCounts[user.userDepartment!] = 1;
      }
    }

    // Print department-wise user counts
    departmentCounts.forEach((department, count) {
      print('Department: $department, User Count: $count');
    });
    return  SizedBox( width: double.infinity,
        child: DataTable(

          columns: [
            DataColumn(label: Text('Department')),
            DataColumn(label: Text('Department Head')),
            DataColumn(label: Text('Users')),
            DataColumn(label: Text('Action')),
          ],
          rows: departmentList.map((department) {
            return DataRow(
              cells: [
                DataCell(Text(department.name)),
                DataCell(Text(department.departmentHead??"")),
              //  DataCell(Text(departmentCounts[department.name].toString())),
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      showUsersByDepartment(context, department.name);
                    },
                    child: Text(departmentCounts[department.name].toString())
                  ),
                ),
                DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            // Fetch the user list (replace this with your logic to fetch the user list)
                            await   apiController.fetchUsers({"AdminId": LocalStorage.ADMINID});
                            // Show the popup
                            // await UserListPopup( userList: apiController.userList);
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return UserListPopup(userList: apiController.userList,departmentId:department.id);
                              },
                            );
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
                    )
                ),
              ],
            );
          }).toList(),
        ));
  }
}