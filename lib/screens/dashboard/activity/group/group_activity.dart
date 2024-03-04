import 'package:dash_board/constants.dart';
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/notice.dart';
import 'package:dash_board/responsive.dart';
import 'package:dash_board/screens/dashboard/activity/group/group_activity_controller.dart';
import 'package:dash_board/screens/dashboard/group/group_controllers/group_controller.dart';
import 'package:dash_board/screens/dashboard/notice/notice_controller.dart';
import 'package:dash_board/screens/dashboard/notice/notice_description.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class GroupActivityPage extends StatelessWidget {
  final GroupActivityController groupActivityController = Get.put(GroupActivityController());
  final ApiController apiController=Get.put(ApiController());
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        //   color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child:GetBuilder<GroupActivityController>(builder: (controller){
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
                          Text("Group Activity List"),
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),),
                          SizedBox(width: Get.width*0.02,),
                          Text("Type",style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),),
                          SizedBox(width: Get.width*0.03,),
                          Text("Group Name",style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),),


                          SizedBox(width: Get.width*0.07,),
                          Text("Activities",style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),),
                          SizedBox(width: Get.width*0.10,),
                          Text("Description",style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),),
                          !Responsive.isMobile(context)
                              ? SizedBox(width: Get.width*0.20,):
                          SizedBox(width: Get.width*0.03,),
                          Text("Date",style: TextStyle(
                              fontSize: 16,
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
                      List<Color> itemColors = [Colors.blueGrey, Colors.blue, Colors.green, Colors.teal]; // Define your list of colors here
                      final activity = controller.activityList[index];
                      final groupActivityData = activity; // Assuming activityList contains group activity data
                      final groupData = apiController.groupList; // Assuming groupList contains group data

                      // Create a map from groupId to groupName
                      Map<String, String> groupIdToNameMap = {};
                      groupData.forEach((group) {
                        groupIdToNameMap[group.id] = group.groupName;
                      });

                      // Get the groupName for the current group activity
                      String? groupName = groupIdToNameMap[groupActivityData.groupId];
                      return ListTile(
                       // tileColor: itemColors[index % itemColors.length],
                        leading: Container(
                          width: MediaQuery.of(context).size.width * 0.20,
                          //  padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.10,
                                child: RichText(text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${i++}    ',
                                        style: TextStyle(
                                          color: Get.isDarkMode?Colors.white:Colors.black, // Color for the "Description: " part
                                          fontSize: 15,
                                        ),
                                      ),

                                      TextSpan(
                                        text: '${activity.activityType!}      ',
                                        style: TextStyle(
                                          color: Get.isDarkMode?Colors.white:Colors.black, // Color for the "Description: " part
                                          fontSize: 15,
                                        ),
                                      ),


                                    ]
                                )),
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width * 0.10,
                                child:  Text(
                                  '${groupName}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        title: Container(
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.10,
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      'By : ${activity.senderName}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      'To : ${activity.receiverName}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),


                             Container(
                               width: MediaQuery.of(context).size.width * 0.25,
                               child:  Text(
                                 '${activity.activityDetails}',
                                 style: TextStyle(
                                   fontSize: 15,
                                   overflow: TextOverflow.ellipsis,
                                 ),
                               ),
                             )
                            ],
                          ),
                        ),
                        trailing: Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      child: Text(
                      ' ${activity.actionDate.toString().substring(0,20)}',
                      style: TextStyle(
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis,
                      ),
                      ),
                      ),
                        onTap: () {
                          // showDialog(
                          //   context: context,
                          //   builder: (context) {
                          //     return NoticeDetailScreen(notice: notice);
                          //   },
                          // );
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
    groupActivityController.deleteNotice(noticeId);
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