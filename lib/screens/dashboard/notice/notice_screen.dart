import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/MyFiles.dart';
import 'package:dash_board/models/notice.dart';
import 'package:dash_board/responsive.dart';
import 'package:dash_board/screens/dashboard/notice/notice_controller.dart';
import 'package:dash_board/screens/dashboard/notice/notice_description.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';


class NoticePage extends StatelessWidget {
  final NoticeController noticeController = Get.put(NoticeController());
  final ApiController apiController=Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ApiController());

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        //   color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child:GetBuilder<NoticeController>(builder: (controller){
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
                      !Responsive.isMobile(context)?
                      Row(
                        children: [
                          Text("NoticeList"),
                          IconButton(onPressed: (){
                            controller.fetchNotices();
                          }, icon: Icon(Icons.refresh)
                          ),
                          SizedBox(width: Get.width*0.20,),
                          Container(
                            width: Get.width*0.20,
                            height: 30,
                            child: SearchBar(
                              hintText: "Search",
                              leading: Icon(Icons.search),
                              //onChanged: apiController.setSearchQuery,
                              onChanged: (String? value){
                                controller.getFilteredNotice(value);
                              },
                            ),
                          ),
                        ],
                      ):Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: Get.width*0.03,),
                          Text("Title",style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),),
                          SizedBox(width: Get.width*0.12,),
                          Text("Description",style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),),
                          SizedBox(width: Get.width*0.10,),

                          Text("Seen Users",style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),),
                          SizedBox(width: Get.width*0.10,),

                          Text("Unseen Users",style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),),

                        ],
                      ),
                      Responsive.isMobile(context)?
                      Container(
                        width: Get.width*0.15,
                        child:ElevatedButton(
                          onPressed: () {
                            // Open the create notice modal
                            _showCreateNoticeDialog(context);
                          },
                          child: Text('+ Create Notice',
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis
                            ),),
                        ),

                      ):Container(),

                    ],
                  ),
                  !Responsive.isMobile(context)?Container(
                    width: Get.width*0.15,
                    child:ElevatedButton(
                      onPressed: () {
                        // Open the create notice modal
                        _showCreateNoticeDialog(context);
                      },
                      child: Text('+ Create Notice',
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis
                        ),),
                    ),

                  ):Container()
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 500,
                child:Obx(() {
                  var i=1;
                  return ListView.separated(
                    itemCount: controller.notices.length,
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) => Divider(), // Add Divider between ListTiles
                    itemBuilder: (context, index) {
                      final notice = controller.notices[controller.notices.length - index - 1];
                      //final notice = controller.notices[index];
                      // Count the number of seen and unseen users
                      int seenCount = 0;
                      int unseenCount = 0;
                      if (notice.seenUsers != null) {
                        // Count the number of seen and unseen users
                        seenCount = notice.seenUsers!.where((user) => user.seen).length;
                        unseenCount = notice.seenUsers!.where((user) => !user.seen).length;
                      }

                     // int seenCount = notice.seenUsers!.where((user) => user.seen).length;
                     // int unseenCount = notice.seenUsers!.where((user) => !user.seen).length;
                      print("toato seen:$seenCount");
                     // print("toato unseen:${notice.seenUsers!.length}");
                      return ListTile(
                        title: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                '${notice.noticeDescription}',
                                style: TextStyle(
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.20,
                              padding: const EdgeInsets.only(left: 100),
                              child: Text(
                                '${seenCount}',
                                style: TextStyle(
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.20,
                              padding: const EdgeInsets.only(left: 70),
                              child: Text(
                                '${unseenCount}',
                                style: TextStyle(
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Container(
                          width: MediaQuery.of(context).size.width * 0.10,
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Deadline: ${notice.noticeDeadLine.toString()}',
                            style: TextStyle(
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        leading: Container(
                            width: MediaQuery.of(context).size.width * 0.12,
                            padding: const EdgeInsets.only(left: 05),
                            child: Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.10,
                                  padding: const EdgeInsets.only(left: 05),
                                  child: Text(
                                    '${notice.noticeTitle!}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              /*  RichText(
                                    text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${i++}    ',
                                            style: TextStyle(
                                              color: Get.isDarkMode?Colors.white:Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${notice.noticeTitle!}',
                                            style: TextStyle(
                                              color: Get.isDarkMode?Colors.white:Colors.black,
                                              fontSize: 18,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          // TextSpan(
                                          //   text: ' Seen: $seenCount, Unseen: $unseenCount', // Display seen and unseen counts
                                          //   style: TextStyle(
                                          //     color: Get.isDarkMode?Colors.white:Colors.black,
                                          //     fontSize: 18,
                                          //   ),
                                          // ),
                                        ]
                                    )
                                ),*/
                              ],
                            )
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete,color: Colors.red,),
                          onPressed: () {
                            print(notice.noticeId);
                            print(notice.noticeDescription);
                            // Remove the notice from the list
                            // controller.removeNotice(notice);
                            showDeleteConfirmationDialog(context, notice.noticeId!);
                          },
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              // Check if the userList is not empty before passing it to NoticeDetailScreen
                              if (apiController.userList.isNotEmpty) {
                                return NoticeDetailScreen(notice: notice);
                              } else {
                                // Handle case where userList is empty
                                return AlertDialog(
                                  title: Text('User List is Empty'),
                                  content: Text('User List is empty. Please try again later.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              }
                            },
                          );
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
                Notice newNotice = Notice(
                  noticeTitle: titleController.text,
                  noticeDescription: descriptionController.text,
                  noticeDeadLine: selectedDate,
                );
                noticeController.addNotice(newNotice);
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
    noticeController.deleteNotice(noticeId);
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