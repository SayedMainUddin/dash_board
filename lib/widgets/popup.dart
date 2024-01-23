import 'package:dash_board/models/MyFiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void toggleSuccess(BuildContext context,String message) {



  // Display success message using SnackBar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ),
  );
}
showAlerDialog(String title,String message) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Get.back();
    //  apiController.getAllDepartments();
    },
  );
  // configura o  AlertDialog
  Get.defaultDialog(
      title: title,
      middleText: message,
      backgroundColor: Colors.amber,
      titleStyle: TextStyle(color: Colors.white),
      middleTextStyle: TextStyle(color: Colors.white),
      radius: 30,
      actions: [
        okButton
      ]
  );
}
modeChange(String title,String message) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      apiController.toggleTheme();
      Get.back();
      Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());

      //apiController.getAllDepartments();
    },
  );
  // configura o  AlertDialog
  Get.defaultDialog(
      title: title,
      middleText: message,
      backgroundColor: Colors.amber,
      titleStyle: TextStyle(color: Colors.white),
      middleTextStyle: TextStyle(color: Colors.white),
      radius: 30,
      actions: [
        okButton
      ]
  );
}