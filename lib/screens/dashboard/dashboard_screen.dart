import 'package:dash_board/controllers/MenuAppController.dart';
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/responsive.dart';
import 'package:dash_board/screens/dashboard/activity/group/group_activity.dart';
import 'package:dash_board/screens/dashboard/activity/user/user_activity.dart';
import 'package:dash_board/screens/dashboard/components/file_info_card.dart';
import 'package:dash_board/screens/dashboard/department/department_screen.dart';
import 'package:dash_board/screens/dashboard/group/group_list.dart';
import 'package:dash_board/screens/dashboard/notice/notice_screen.dart';
import 'package:dash_board/screens/dashboard/onlineUsers/online_users.dart';
import 'package:dash_board/screens/dashboard/user/user_list.dart';
import 'package:dash_board/screens/notification/notification_screen.dart';
import 'package:dash_board/screens/profile/profile_screen.dart';
import 'package:dash_board/screens/test/test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import 'components/header.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  MenuAppController menuAppController=Get.put(MenuAppController());
final ApiController apiController=Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
final _height=MediaQuery.of(context).size.height;
final _width=MediaQuery.of(context).size.width;
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
       // padding: EdgeInsets.all(defaultPadding),
        child:Obx((){
          return  Column(
            children: [

              Header(),
              if (!Responsive.isMobile(context))
                  SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: _height*0.35,
                        width: _width*0.17,
                        child:FileInfoCard(info: apiController.userList.length,title: "User"),

                      ),
                      Container(
                        height: _height*0.35,
                        width: _width*0.17,
                        child:FileInfoCard(info: apiController.groupList.length,title: "Group"),

                      ),
                      Container(
                        height: _height*0.35,
                        width: _width*0.17,
                        child:FileInfoCard(info: apiController.onlineUserList.length,title: "Online User"),

                      ),
                      Container(
                        height: _height*0.35,
                        width: _width*0.17,
                        child:FileInfoCard(info: apiController.mutedUserList.length,title: "Muted User"),

                      )
                    ],
                  ),
                ),
              ),
              if (Responsive.isMobile(context))
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: _height*0.30,
                            width: _width*0.40,
                            padding: EdgeInsets.all(10),
                            child:FileInfoCard(info: apiController.userList.length,title: "User"),

                          ),
                          Container(
                            height: _height*0.30,
                            width: _width*0.40,
                            padding: EdgeInsets.all(10),
                            child:FileInfoCard(info: apiController.groupList.length,title: "Group"),

                          ),
                        ],
                      ),
                    Row(
                      children: [
                        Container(
                          height: _height*0.30,
                          width: _width*0.40,
                          padding: EdgeInsets.all(10),
                          child:FileInfoCard(info: apiController.temporaryOnlineUserList.length,title: "Online User"),

                        ),
                        Container(
                          height: _height*0.30,
                          width: _width*0.40,
                          padding: EdgeInsets.all(10),
                          child:FileInfoCard(info: apiController.mutedUserList.length,title: "Muted User"),

                        )
                      ],
                    )

                    ],
                  ),
                ),
              /*     Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      MyFiles(),
                      SizedBox(height: defaultPadding),
                      //RecentFiles(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) StorageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: StorageDetails(),
                  ),
              ],
            ),*/
              const Divider(),

              Obx(() {
                final selectedItem = menuAppController.selectedItem.value;

                switch (selectedItem) {

                  case MenuItem.dashboard:
                    return
                    Column(
                      children: [
                        //  SizedBox(height: defaultPadding),
                       UserListPage()

                      ],

                    );
                  case MenuItem.groupList:
                  // Replace with NotificationListPage()
                    return  GroupListPage();
                  case MenuItem.onlineUserList:
                    return OnlineUserList();
                  case MenuItem.profile:
                  // Replace with ProfileListPage()
                    return ProfilePage();

                  case MenuItem.settings:
                  // Replace with SettingsListPage()
                  // return SettingsListPage();
                  case MenuItem.department:
                    return DepartmentPage();
                  case MenuItem.notice:
                    return NoticePage();
                  case MenuItem.notification:
                    return NotificationListScreen();
                  case MenuItem.userActivity:
                    return UserActivityPage();
                  case MenuItem.groupActivity:
                    return GroupActivityPage();
                  default:return Container();
                // default:
                //   return Column(
                //     children: [
                //       if (Responsive.isMobile(context))
                //         SizedBox(height: defaultPadding),
                //       if (Responsive.isMobile(context)) StorageDetails(),
                //     ],
                //   );
                }
              }),

            ],
          );
        }),
      ),
    );
  }
}
