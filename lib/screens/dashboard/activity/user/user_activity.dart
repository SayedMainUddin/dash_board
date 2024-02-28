import 'package:dash_board/constants.dart';
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/notice.dart';
import 'package:dash_board/screens/dashboard/activity/group/group_activity_controller.dart';
import 'package:dash_board/screens/dashboard/activity/user/user_activity_controller.dart';
import 'package:dash_board/screens/dashboard/group/group_controllers/group_controller.dart';
import 'package:dash_board/screens/dashboard/notice/notice_controller.dart';
import 'package:dash_board/screens/dashboard/notice/notice_description.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UserActivityPage extends StatelessWidget {
  final UserActivityController userActivityController = Get.put(UserActivityController());
  final ApiController apiController=Get.put(ApiController());
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        //   color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child:GetBuilder<UserActivityController>(builder: (controller){
        // final filteredUsers = apiController.getFilteredUsers();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("User Activity List"),
                          IconButton(onPressed: (){
                            controller.fetchActivity();
                          }, icon: Icon(Icons.refresh)
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("SL",style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),),
                          SizedBox(width: 20,),
                          Text("Type",style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),),


                          SizedBox(width: 100,),
                          Text("Description",style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),),


                        ],
                      ),
                    ],
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Open the create notice modal
                  //     _showCreateNoticeDialog(context);
                  //   },
                  //   child: Text('Create Notice'),
                  // ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 500,
                child:Obx(() {
                  var i=1;
                  return ListView.separated(
                    itemCount: controller.activityList.length,
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) => Divider(), // Add Divider between ListTiles
                    itemBuilder: (context, index) {
                      var activity = controller.activityList[index];
                      var allUsers = apiController.userList;

                      // Create a map from userId to userName
                      Map<String, String> userIdToNameMap = {};
                      allUsers.forEach((user) {
                        userIdToNameMap[user.userId!] = user.userName!;
                      });

                      // Get senderName and receiverName using userIdToNameMap
                      String senderName = userIdToNameMap[activity.senderId] ?? 'Unknown';
                      String receiverName = userIdToNameMap[activity.receiverId] ?? 'Unknown';

                      return ListTile(
                        title: Container(
                          width: MediaQuery.of(context).size.width * 0.10,
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${activity.activityDetails}',
                                style: TextStyle(
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'Sender: $senderName',
                                style: TextStyle(
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'Receiver: $receiverName',
                                style: TextStyle(
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Container(
                          width: MediaQuery.of(context).size.width * 0.10,
                          padding: const EdgeInsets.only(left: 100),
                          child: Text(
                            ' ${activity.actionDate.toString()}',
                            style: TextStyle(
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        leading: Container(
                          width: MediaQuery.of(context).size.width * 0.20,
                          padding: const EdgeInsets.only(left: 10),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${index + 1}    ',
                                  style: TextStyle(
                                    color: Get.isDarkMode ? Colors.white : Colors.black, // Color for the "Description: " part
                                    fontSize: 18,
                                  ),
                                ),
                                TextSpan(
                                  text: '${activity.activityType!}',
                                  style: TextStyle(
                                    color: Get.isDarkMode ? Colors.white : Colors.black, // Color for the "Description: " part
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // trailing: IconButton(
                        //   icon: Icon(Icons.delete, color: Colors.red),
                        //   onPressed: () {
                        //     // Handle delete action
                        //   },
                        // ),
                        onTap: () {
                          // Handle tap action
                        },
                      );
                    },
                  );

                })

                ,
              )
            ],
          ),
        );}),
    );
  }

  Future<void> _showCreateNoticeDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Notice'),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              Container(
                width: 400,
                height: 200,
                child: SingleChildScrollView(
                  child: TextField(
                    controller: descriptionController,
                    maxLines: null, // Allow unlimited lines of text
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    keyboardType: TextInputType.multiline, // Allow multiline input
                    textInputAction: TextInputAction.newline, // Add a newline action button
                  ),
                ),
              ),

              SizedBox(height: 10),
              Text('Select Notice Deadline:'),
              ElevatedButton(
                onPressed: () async {
                  // Show date picker
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != selectedDate) {
                    // Update the selected date
                    selectedDate = pickedDate;
                  }

                },
                child: Text('Pick Deadline'),
              ),
              Text('Selected Notice Deadline:$selectedDate'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Get.back();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Create a new notice and add it to the list

                // Close the dialog
                Get.back();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
// Function to delete a department
  Future<void> deleteNotice(String noticeId) async {
    //groupActivityController.deleteNotice(noticeId);
  }
  // Function to show a confirmation dialog for deleting a department
  Future<void> showDeleteConfirmationDialog(BuildContext context, String noticeId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Notice'),
          content: Text('Are you sure you want to delete this notice?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {

                //await noticeController.fetchNotices();

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {

                deleteNotice(noticeId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

}