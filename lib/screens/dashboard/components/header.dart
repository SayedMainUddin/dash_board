import 'package:dash_board/controllers/MenuAppController.dart';
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/responsive.dart';
import 'package:dash_board/screens/login/login_controller.dart';
import 'package:dash_board/screens/login/login_screen.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/socket.dart';
import 'package:dash_board/utils/urls.dart';
import 'package:dash_board/widgets/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../constants.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  ApiController apiController=Get.put(ApiController());
  MenuAppController menuAppController=Get.put(MenuAppController());
  final ThemeController themeController=Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: menuAppController.controlMenu,
          ),
        if (!Responsive.isMobile(context))
          Container(
            padding: EdgeInsets.all(defaultPadding),
            child: Text(
              "Dashboard",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        IconButton(
            onPressed: (){
          print("mode change");
          setState(() {
            Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
           themeController.toggleDarkMode();


          });

        }, icon: Icon(Icons.mode_night_outlined)),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
       // Expanded(child: SearchField()),
        ProfileCard()
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
   ProfileCard({
    Key? key,
  }) : super(key: key);
  final SocketController socketController=Get.put(SocketController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
    //    color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          if(LocalStorage.ADMINIMAGE=='')
            Image.asset(
              "assets/images/profile_pic.png",
              height: 38,
            ),
         if(LocalStorage.ADMINIMAGE!='')
           Image.network(
             LocalStorage.ADMINIMAGE,
             height: 38,),
          if (!Responsive.isMobile(context))
            InkWell(
              onTap: (){
                showAlertErrorDialog("Do you want to Logout?",context);
              },
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: Text("Admin"),
              ),
            ),
          IconButton(onPressed: (){
            showAlertErrorDialog("Do you want to Logout?",context);

          }, icon:   Icon(Icons.keyboard_arrow_down),)


        ],
      ),
    );
  }
   showAlertErrorDialog(String message,BuildContext context) {
     Widget okButton = TextButton(
       child: Text("OK"),
       onPressed: () async {
         // Navigator.pop(context);
         socketController.socket.disconnect();

         socketController.socket.onDisconnect((data) => print("Hit socket disconnect"));
         SharedPreferences preferences = await SharedPreferences.getInstance();
         await preferences.setString("logedin", "no");
         await PreferencesManager.setLoggedIn(false);
         await preferences.clear();
         Get.offAll(LoginPage());
         //   Get.until((route) => Get.currentRoute == '/');
       },
     );
     Widget noButton = TextButton(
       child: Text("No"),
       onPressed: () {
         Get.back();
        // Navigator.pop(context,false);

       },
     );
     // configura o  AlertDialog
     AlertDialog alertDialog = AlertDialog(
       title: Text("Warning!"),
       content: Text(message),
       actions: [
         okButton,
         noButton
       ],
     );
     // exibe o dialog
     Get.defaultDialog(
         title: "Warning!",
         content: Text(message),
         actions: [
           okButton,
           noButton
         ]
     );
   }

}
class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
