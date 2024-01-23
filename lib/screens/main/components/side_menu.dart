import 'package:dash_board/controllers/MenuAppController.dart';
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/main.dart';
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
    return Drawer(
      child: ListView(
        children: [

          DrawerHeader(
            padding: EdgeInsets.all(30),
            child:Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                   // borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(image: AssetImage("assets/images/loto_trans.png",),fit: BoxFit.fill)
                  ),
                ),


              ],
            )
          ),
          DrawerListTile(
            title: "User List",
            svgSrc: "assets/icons/menu_dashboard.svg",
            menuItem: MenuItem.dashboard,
          ),
          DrawerListTile(
            title: "Group List",
            svgSrc: "assets/icons/menu_dashboard.svg",
            menuItem: MenuItem.notification,

          ),
          DrawerListTile(
            title: "Admin Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            menuItem: MenuItem.profile,
          ),
          DrawerListTile(
            title: "Category",
            svgSrc: "assets/icons/menu_profile.svg",
            menuItem: MenuItem.category,
            icon: Icon(Icons.category,color: Colors.white,),
          ),


          const Divider(),
       /*   IconButton(
              onPressed: (){
                print("mode change");
                setState(() {
                  Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());

                });

              }, icon: Icon(Icons.mode_night_outlined)),*/


        ],
      ),
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
