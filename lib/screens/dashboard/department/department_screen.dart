import 'package:dash_board/constants.dart';
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/departments.dart';
import 'package:dash_board/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class DepartmentPage extends StatefulWidget {
  @override
  _DepartmentPageState createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  //List<Department> departments = []; // Your list of categories
  final ApiController apiController=Get.put(ApiController());
  @override
  void initState() {
    super.initState();
   // apiController.getAllDepartments();
    // Fetch categories from your data source (e.g., API, database)
    // and update the 'categories' list.
    // For demonstration, let's assume some sample categories.
    // categories = [
    //   Department(id: '1', name: 'Finance'),
    //   Department(id: '2', name: 'Human Resources'),
    //   Department(id: '3', name: 'Marketing'),
    //   // Add more categories as needed
    // ];
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
                                //     builder: (context) => EditDepartmentPage(
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
            ),
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
