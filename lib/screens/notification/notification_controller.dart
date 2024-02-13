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
class NotificationController extends GetxController {
  var notices = <Notice>[].obs;

  Future<void> addNotification(Notice notice) async {
    // notices.add(notice);
    Map data={
      "NotificationTitle": notice.noticeTitle,
      "NotificationDescription": notice.noticeDescription,
      "SenderId": LocalStorage.ADMINID,
      "NotificationDeadLine": notice.noticeDeadLine.toString()
    };
    try {
      final response = await http.post(Uri.parse('${WebApi.basesUrl}/createNotice'),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*'
        },
        body: jsonEncode(data),
      );


      if (response.statusCode == 200) {
        print('user created: ${response.body}');
        toggleSuccess(Get.context!, "Notice public successfully!");
        //Get.back();

      } else {
        throw Exception('Failed to load data');
      }


    } catch (e) {
      print('Error: $e');
      // Handle errors here
    }finally{
      // await getAllDepartments();

    }
    update();
  }

  void removeNotice(Notice notice) {
    notices.remove(notice);
  }
  fetchNotification() async {

    try {
      final response = await http.post(Uri.parse('${WebApi.basesUrl}/getAllNotices'),
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
          List<Notice>    allNotices = data.map((json) => Notice.fromJson(json)).toList();
          notices.value=allNotices;
        }
        // List<Notice> allNotices = data.map((json) => Notice.fromJson(json)).toList();
        // notices.value=allNotices;


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
    fetchNotification();
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
    await fetchNotification();
    update();
  }

}