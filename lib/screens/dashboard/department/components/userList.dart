import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/screens/dashboard/department/components/callback.dart';
import 'package:dash_board/utils/local_storage.dart';
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
      content: Column(
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
          Container(
              width: 400,
              height: 300,
              child:  Obx(() => ListView.builder(
                itemCount: filteredUsers.length,
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
          )
        ],
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

  @override
  Widget build(BuildContext context) {
    return  SizedBox( width: double.infinity,
        child: DataTable(

          columns: [
            DataColumn(label: Text('Department')),
            DataColumn(label: Text('Department Head')),
            DataColumn(label: Text('Action')),
          ],
          rows: departmentList.map((department) {
            return DataRow(
              cells: [
                DataCell(Text(department.name)),
                DataCell(Text(department.departmentHead??"")),
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