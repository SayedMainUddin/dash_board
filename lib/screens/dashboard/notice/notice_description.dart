import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/MyFiles.dart';
import 'package:dash_board/models/Users.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/notice.dart';

class NoticeDetailScreen extends StatelessWidget {
  final Notice notice;
   // userList containing user ids and names
  //final List<User> UserList;
  NoticeDetailScreen({required this.notice,});

  @override
  Widget build(BuildContext context) {
    final ApiController apiController=Get.put(ApiController());

    List<String> seenUserIds = [];
    List<String> unseenUserIds = [];

    // Extract seen and unseen user ids
    for (var user in notice.seenUsers!) {
      if (user.seen) {
        seenUserIds.add(user.userId);
      } else {
        unseenUserIds.add(user.userId);
      }
    }
    print(seenUserIds);
    // Map user ids to user names
    List<String> seenUserNames = [];
    List<String> unseenUserNames = [];
    List<String> seenUserEmail = [];
    List<String> unseenUserEmail = [];

    for (var user in apiController.userList) {
      print(user.userId);

      if (seenUserIds.contains(user.userId)) {
        seenUserNames.add(user.userName!);
        seenUserEmail.add(user.email!);
      } else {
        unseenUserNames.add(user.userName!);
        unseenUserEmail.add(user.email!);
      }
    }

    print('Seen UserNames: $seenUserNames');
    print('Unseen UserNames: $unseenUserNames');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, seenUserNames,seenUserEmail, unseenUserNames,unseenUserEmail),
    );
  }

  contentBox(context, List<String?> seenUserNames,List<String?> seenUserEmail, List<String?> unseenUserNames,List<String?> unseenUserEmail) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 10),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("Title: ${notice.noticeTitle!}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),),
                  width: Get.width*0.40,
                ),

                SizedBox(height: 8),

                Container(
                    child: Text('Description: ${notice.noticeDescription}'),
                  width: Get.width*0.40,
                ),
                SizedBox(height: 8),
                Text('Deadline: ${notice.noticeDeadLine}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    color: Colors.deepOrangeAccent
                  ),),
                SizedBox(height: 8),
                // Show seen user names
               Container(
                 width: Get.width*0.40,
                 child:  ElevatedButton(
                   onPressed: () {
                     _showUserList(context, seenUserNames,seenUserEmail);
                   },
                   child: Text('Seen Users'),
                 ),
               ),
                SizedBox(height: 8),
               Container(
                 width: Get.width*0.40,
                 child:  ElevatedButton(
                   onPressed: () {
                     _showUserList(context, unseenUserNames,unseenUserEmail);
                   },
                   child: Text('Unseen Users'),
                 ),
               )
              ],
            ),
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
  void _showUserList(BuildContext context, List<String?> usersName,List<String?> userEmail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User List'),
          content: SizedBox(
            width: Get.width*0.50,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: usersName.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildUserListItem(usersName[index]!,userEmail[index]!);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserListItem(String userName,String userEmail) {
 //   final user = apiController.userList.firstWhere((user) => user.userId == userId);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userName ?? ""), // Assuming profilePic is a URL
      ),
      title: Text(userName ?? ""),
      subtitle: Text(userEmail ?? ""),
      onTap: () {
        // Handle tapping on a user item if needed
      },
    );
  }

}
