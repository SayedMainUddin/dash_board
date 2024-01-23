import 'package:dash_board/bindings.dart';
import 'package:dash_board/controllers/MenuAppController.dart';
import 'package:dash_board/screens/login/login_screen.dart';
import 'package:dash_board/screens/main/main_screen.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/socket.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  var logedin = preferences.getString('logedin');
  if(logedin=='yes'){
    LocalStorage.ADMINID = preferences.getString('userId')!;
    LocalStorage.AdminUserName = preferences.getString('userName')!;
    LocalStorage.AdminFirstName = preferences.getString('firstName')!;
    LocalStorage.AdminLastName = preferences.getString('lastName')!;
    LocalStorage.ADMINNAME = preferences.getString('fullName')!;
    //  LocalStorage.AdminDOB = preferences.getString('dob')!;
    // LocalStorage.AdminGender = preferences.getString('gender')!;
    LocalStorage.AdminMobile = preferences.getString('mobileNo')!;
    LocalStorage.AdminEmail = preferences.getString('email')!;
    LocalStorage.ADMINIMAGE = preferences.getString('profilePic')!;
    LocalStorage.BearerTOKEN = preferences.getString('token')!;

  }else{
    preferences.clear();
  }
  Get.put(SocketController());
  runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () =>logedin=='yes'? MyApp():LoginPage(), binding: AppBindings()),
       //   GetPage(name: '/login', page: () => MyHomePage(title: 'title',)),
          // GetPage(name: '/dashboard', page: () => DashboardScreen(),),
          // GetPage(name: '/users', page: () => UserListPage(),),
          // GetPage(name: '/groups', page: () => GroupListPage(),),
          // GetPage(name: '/category', page: () => DepartmentPage(),),
        ],
      )
  );
}


class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainScreen(),
    );
  }
}

