import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/activity.dart';
import 'package:dash_board/models/notice.dart';
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
class GroupActivityController extends GetxController {
  final ApiController apiController=Get.put(ApiController());
  var activityList = <Activity>[].obs;




  fetchActivity() async {

    try {
      final response = await http.post(Uri.parse('${WebApi.basesUrl}/api/getAllGroupActivity'),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*'
        },
        body: jsonEncode({"AdminId":LocalStorage.ADMINID}),
      );


      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data != null && data.isNotEmpty) {
          List<Activity>    activities = data.map((json) => Activity.fromJson(json)).toList();
          activityList.value=activities;
        }
        // List<Notice> allNotices = data.map((json) => Notice.fromJson(json)).toList();
        // notices.value=allNotices;
      var groupActivityData=activityList;
       var groupData=apiController.groupList;

        Map<String, String> groupIdToNameMap = {};

        // Create a map from groupId to groupName
        groupData.forEach((group) {
          groupIdToNameMap[group.id] = group.groupName;
        });

        // Match groupId from groupActivityData to get the groupName
        groupActivityData.forEach((activity) {
          String groupId = activity.groupId!;
          if (groupIdToNameMap.containsKey(groupId)) {
            String? groupName = groupIdToNameMap[groupId];
            print("Activity '${activity.activityDetails}' belongs to group '$groupName'");
          } else {
            print("No group found for activity '${activity.activityDetails}'");
          }
        });
      } else {
        throw Exception('Failed to load data');
      }


    } catch (e) {
      print('Error: $e');
      // Handle errors here
    }
    update();
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