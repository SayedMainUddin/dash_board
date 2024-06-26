import 'package:dash_board/controllers/MenuAppController.dart';
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/main.dart';
import 'package:dash_board/responsive.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/widgets/popup.dart';
import 'package:dash_board/widgets/theme_controller.dart';
import 'package:dash_board/widgets/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SideMenu extends StatefulWidget {
   SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  // final ValueChanged<ThemeMode> onModeChanged=ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return   Responsive.isDesktop(context)?
    Container(
     // color:  Color(0xff1B3F4BFF),
      decoration: BoxDecoration(
        color:Color(0xff1B3F4BFF),
        border: Border.all(
          color: Color(0xff1B3F4BFF),
          width: 2
        ), // Border color
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(50),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.cyan
                ),

                image: DecorationImage(image:AssetImage("assets/images/loto_trans.png"))
            ),

            child: SizedBox(
              height: 0,
            ),
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(40),

            //child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Department",
            svgSrc: "assets/icons/menu_doc.svg",
            menuItem: MenuItem.department,
            icon: Icon(Icons.category,color: Colors.white,),
          ),
          DrawerListTile(
            title: "User List",
            svgSrc: "assets/icons/menu_dashboard.svg",
            menuItem: MenuItem.dashboard,
          ),
          DrawerListTile(
            title: "Group List",
            svgSrc: "assets/icons/menu_dashboard.svg",
            menuItem: MenuItem.groupList,

          ),


          DrawerListTile(
            title: "Notice",
            svgSrc: "assets/icons/menu_task.svg",
            menuItem: MenuItem.notice,
            icon: Icon(Icons.category,color: Colors.white,),
          ),
          DrawerListTile(
            title: "Online Users",
            svgSrc: "assets/icons/menu_notification.svg",
            menuItem: MenuItem.onlineUserList,
            icon: Icon(Icons.online_prediction,color: Colors.white,),
          ),
          DrawerListTile(
            title: "Users Activity",
            svgSrc: "assets/icons/drop_box.svg",
            menuItem: MenuItem.userActivity,
            icon: Icon(Icons.local_activity_outlined,color: Colors.white,),
          ),
          DrawerListTile(
            title: "Group Activity",
            svgSrc: "assets/icons/menu_tran.svg",
            menuItem: MenuItem.groupActivity,
            icon: Icon(Icons.local_activity,color: Colors.white,),
          ),
          DrawerListTile(
            title: "Admin Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            menuItem: MenuItem.profile,
          ),



        ],
      ),
    ):
        Drawer(
          child:   Container(
            // decoration: BoxDecoration(
            //   color: Color(0xff1B3F4BFF),
            //   border: Border.all(color: Colors.cyan), // Border color
            // ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(50),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.cyan
                      ),

                      image: DecorationImage(image:AssetImage("assets/images/loto_trans.png"))
                  ),

                  child: SizedBox(
                    height: 0,
                  ),
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(40),

                  //child: Image.asset("assets/images/logo.png"),
                ),
                DrawerListTile(
                  title: "Department",
                  svgSrc: "assets/icons/menu_doc.svg",
                  menuItem: MenuItem.department,
                  icon: Icon(Icons.category,color: Colors.white,),
                ),
                DrawerListTile(
                  title: "User List",
                  svgSrc: "assets/icons/menu_dashboard.svg",
                  menuItem: MenuItem.dashboard,
                ),
                DrawerListTile(
                  title: "Group List",
                  svgSrc: "assets/icons/menu_dashboard.svg",
                  menuItem: MenuItem.groupList,

                ),


                DrawerListTile(
                  title: "Notice",
                  svgSrc: "assets/icons/menu_task.svg",
                  menuItem: MenuItem.notice,
                  icon: Icon(Icons.category,color: Colors.white,),
                ),
                DrawerListTile(
                  title: "Online Users",
                  svgSrc: "assets/icons/menu_notification.svg",
                  menuItem: MenuItem.onlineUserList,
                  icon: Icon(Icons.online_prediction,color: Colors.white,),
                ),
                DrawerListTile(
                  title: "Users Activity",
                  svgSrc: "assets/icons/drop_box.svg",
                  menuItem: MenuItem.userActivity,
                  icon: Icon(Icons.local_activity_outlined,color: Colors.white,),
                ),
                DrawerListTile(
                  title: "Group Activity",
                  svgSrc: "assets/icons/menu_tran.svg",
                  menuItem: MenuItem.groupActivity,
                  icon: Icon(Icons.local_activity,color: Colors.white,),
                ),
                DrawerListTile(
                  title: "Admin Profile",
                  svgSrc: "assets/icons/menu_profile.svg",
                  menuItem: MenuItem.profile,
                ),



              ],
            ),
          )
        );


  }
}


class DrawerListTile extends StatelessWidget {
   DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.menuItem,


    this.icon
  }) : super(key: key);

  final String title, svgSrc;
  final MenuItem menuItem;
  final Icon? icon;

  MenuAppController menuAppController=Get.put(MenuAppController());


  @override
  Widget build(BuildContext context) {
    //bool isSelected = menuAppController.selectedItem == menuItem;

    return Obx(() {
      var selectedItem = menuAppController.selectedItem.value;
      bool isSelected = selectedItem == menuItem;
    return  ListTile(
      onTap: () {
        menuAppController.changeSelectedItem(menuItem);
      },
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        height: 16,
        color: isSelected ? Colors.blue :Get.isDarkMode?Colors.white: Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue :Get.isDarkMode?Colors.white: Colors.black,
        ),
      ),
    );
    });

  }
}
