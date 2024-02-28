import 'package:flutter/material.dart';
import 'package:get/get.dart';
enum MenuItem { dashboard,onlineUserList,mutedUserList,groupList, notice,notification, profile, settings,department,userActivity,groupActivity }
class MenuAppController extends GetxController {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  final Rx<MenuItem> selectedItem = MenuItem.dashboard.obs;


   changeSelectedItem(MenuItem item) {
    selectedItem.value = item;
    update();
  }
  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}
