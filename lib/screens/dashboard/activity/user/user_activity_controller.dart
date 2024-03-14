import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/activity.dart';
import 'package:dash_board/models/notice.dart';
import 'package:dash_board/screens/dashboard/user/user_controller/user_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:dash_board/controllers/MenuAppController.dart';
import 'package:dash_board/main.dart';
import 'package:dash_board/models/Groups.dart';
import 'package:dash_board/models/Users.dart';
import 'package:dash_board/models/departments.dart';
import 'package:dash_board/screens/dashboard/department/department_screen.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/socket.dart';
import 'package:dash_board/utils/urls.dart';
import 'package:dash_board/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class UserActivityController extends GetxController {
  final ApiController apiController=Get.put(ApiController());
  var activityList = <Activity>[].obs;



  String? getUserNameById(String id) {
    User? user = apiController.userList.firstWhere((user) => user.userId == id, orElse: () => User(userId: id, userName: 'Unknown'));
    return user.userName;
  }


  fetchActivity() async {

    try {
      final response = await http.post(Uri.parse('${WebApi.basesUrl}/api/getAllUserActivity'),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*'
        },
        body: jsonEncode({"AdminId":LocalStorage.ADMINID}),
      );


      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(data);
        if (data != null && data.isNotEmpty) {
          List<Activity>    activities = data.map((json) => Activity.fromJson(json)).toList();
          activityList.value=activities;
          for (Activity activity in activityList) {
            String? sender = getUserNameById(activity.senderId!);
            String? receiver = getUserNameById(activity.receiverId!);
              activity.senderName = sender =="Unknown"?  LocalStorage.ADMINNAME:sender;
              activity.receiverName = receiver =="Unknown"? LocalStorage.ADMINNAME:receiver;
            print('Sender: $sender, Receiver: $receiver');
          }
          // for (Activity activity in activityList) {
          //   User? sender = apiController.userList.firstWhere((user) => user.userId == activity.senderId);
          //   User? receiver = apiController.userList.firstWhere((user) => user.userId == activity.receiverId);
          //   activity.senderName = sender != null ? sender.userName : 'Unknown';
          //   activity.receiverName = receiver != null ? receiver.userName : 'Unknown';
          //   print(sender);
          // }
          //activityList.value=activityList;
         // print(activityList);
        }

      } else {
        throw Exception('Failed to load data');
      }


    } catch (e) {
      print('Error: $e');
      // Handle errors here
    }
    update();
  }
  getFilteredUserActivity(value) {
    print(activityList.length);
    List<Activity> newUser=activityList;
    final query = value.toLowerCase();
    newUser= activityList
        .where((user) =>
    user.activityType!.toLowerCase().contains(query)||
        user.senderName!.toLowerCase().contains(query)||
        user.receiverName!.toLowerCase().contains(query)||
        user.activityDetails!.toLowerCase().contains(query)||
        user.actionDate!.toLowerCase().contains(query)
    )
        .toList();
    activityList.value=newUser;
    if(value==''){
      fetchActivity();
    }
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchActivity();
  }

  Future<void> deleteNotice(String noticeId) async {
    print(noticeId);
    final response = await http.delete(Uri.parse('${WebApi.basesUrl}/deleteNotice/$noticeId'));
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Notice deleted successfully');
      // getAllDepartments();
      showAlerDialog("Success!", "Notice has been deleted!");
    } else {
      throw Exception('Failed to delete Notice');
    }
    await fetchActivity();
    update();
  }

}