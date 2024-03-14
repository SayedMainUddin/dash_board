import 'dart:io';
import 'dart:js';
import 'dart:html' as html;
import 'package:dash_board/bindings.dart';
import 'package:dash_board/constants.dart';
import 'package:dash_board/controllers/MenuAppController.dart';
import 'package:dash_board/screens/login/login_screen.dart';
import 'package:dash_board/screens/main/main_screen.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/socket.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
Future<String> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceId = '';

  try {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id; // Use Android ID as device ID
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor!; // Use iOS identifierForVendor as device ID
    }
  } catch (e) {
    print('Failed to get device ID: $e');
  }

  return deviceId;
}
Future<void> main() async {
  HttpOverrides.global = new MyHttpOverrides();
  // HttpOverrides.global = MyHttpOverrides();
  // HttpClient client = new HttpClient();
  // client.badCertificateCallback =
  // ((X509Certificate cert, String host, int port) => true);
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
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Get.textTheme)
              .apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
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

