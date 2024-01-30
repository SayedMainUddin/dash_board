import 'package:dash_board/models/notice.dart';
import 'package:dash_board/screens/dashboard/notice/notice_controller.dart';
import 'package:dash_board/screens/dashboard/notice/notice_description.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';


class NoticePage extends StatelessWidget {
  final NoticeController noticeController = Get.put(NoticeController());
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        //   color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child:GetBuilder<NoticeController>(builder: (controller){
        // final filteredUsers = apiController.getFilteredUsers();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("NoticeList"),
                    IconButton(onPressed: (){
                      controller.fetchNotices();
                    }, icon: Icon(Icons.refresh)
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Open the create notice modal
                    _showCreateNoticeDialog(context);
                  },
                  child: Text('Create Notice'),
                ),
              ],
            ),
            SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 500,
            child: Obx((){
              return  ListView.builder(
                itemCount: controller.notices.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final notice = controller.notices[index];
                  return ListTile(
                    title: Text(notice.noticeTitle!),
                    subtitle: Text(notice.noticeDescription!),
                    leading:  Text(notice.noticeDeadLine.toString()),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        print(notice.noticeId);
                        print(notice.noticeDescription);
                        // Remove the notice from the list
                       // controller.removeNotice(notice);
                        showDeleteConfirmationDialog(context,notice.noticeId!);
                      },
                    ),
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (context) {
                          return   NoticeDetailScreen(notice: notice);
                        },
                      );

                    },
                  );
                },
              );
            }),
          )
          ],
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
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
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