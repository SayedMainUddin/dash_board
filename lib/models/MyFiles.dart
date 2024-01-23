import 'package:dash_board/constants.dart';
import 'package:dash_board/controllers/api_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CloudStorageInfo {
  final String? svgSrc, title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color;
  final Icon? icon;
  Function? ontap;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
    this.icon,
    this.ontap
  });
}
ApiController apiController=Get.put(ApiController());

List demoMyFiles = [
  CloudStorageInfo(
    title: "Users",
    numOfFiles: apiController.userList.length,
    svgSrc: "assets/icons/Documents.svg",
    totalStorage: "Active",
    color: primaryColor,
    percentage: 35,
    icon: Icon(Icons.people_outline_outlined)
  ),
  CloudStorageInfo(
    title: "Groups",
    numOfFiles: apiController.groupList.length,
    svgSrc: "assets/icons/google_drive.svg",
    totalStorage: "2.9GB",
    color: Color(0xFFFFA113),
    percentage: 35,
    icon: Icon(Icons.groups)
  ),
  CloudStorageInfo(
    title: "Blocked Users",
    numOfFiles: apiController.groupList.length,
    svgSrc: "assets/icons/one_drive.svg",
    totalStorage: "1GB",
    color: Color(0xFFA4CDFF),
    percentage: 10,
    icon:Icon(Icons.group_off_outlined)
  ),
  CloudStorageInfo(
    title: "Muted Groups",
    numOfFiles: apiController.groupList.length,
    svgSrc: "assets/icons/drop_box.svg",
    totalStorage: "7.3GB",
    color: Color(0xFF007EE5),
    percentage: 78,
    icon:Icon(Icons.group_off_outlined)
  ),
];
