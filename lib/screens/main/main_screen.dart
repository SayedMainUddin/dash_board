import 'package:dash_board/controllers/MenuAppController.dart';
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/responsive.dart';
import 'package:dash_board/screens/dashboard/components/header.dart';
import 'package:dash_board/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
 ApiController apiController= Get.put(ApiController());
 MenuAppController menuAppController=Get.put(MenuAppController());
  @override
  Widget build(BuildContext context) {
    final _height=MediaQuery.of(context).size.height;

    Get.lazyPut(() => ApiController());
    Get.lazyPut(() => MenuAppController());
    return Scaffold(
      key: menuAppController.scaffoldKey,
      drawer: SideMenu(),
    //  drawerScrimColor: Colors.blue,
     // endDrawer:  ProfileCard(menuItem: MenuItem.values[0],),
     // backgroundColor: Colors.blue,

      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),

            Container(
             // width: 02,
            height: _height*0.99,
              color: Colors.white10,

            ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: DashboardScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
