import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:js';
import 'package:dash_board/bindings.dart';
import 'package:dash_board/constants.dart';
import 'package:dash_board/main.dart';
import 'package:dash_board/screens/login/login_screen.dart';
import 'package:dash_board/screens/main/main_screen.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/socket.dart';
import 'package:dash_board/utils/urls.dart';
import 'package:dash_board/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PreferencesManager {



  static const _keyLoggedIn = 'is_logged_in';

  static setLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, isLoggedIn);
  }

  static isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }
}
class LoginController extends GetxController{
  bool isLogin=false;
  SharedPreferences? prefs;
  final SocketController socketController=Get.put(SocketController());
  void loginButton(String mail,String pass) async {

    Future.delayed(Duration(seconds: 1), () async {
      print("fcmToke: ${LocalStorage.FcmTOKEN}");
      var passField = pass;
      var email = mail;
      final queryParameters = {
        'Email': email,
        'Password':passField,
        'FCMTOKEN':LocalStorage.FcmTOKEN
      };
      try {
        final response = await http.post(Uri.parse('${WebApi.basesUrl}/Login'),
            headers: {
              "Access-Control-Allow-Origin": "*", // Required for CORS support to work
              "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
              "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
              "Access-Control-Allow-Methods": "POST, OPTIONS"
            }, // if needed
            body: queryParameters
        ).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            return showAlerDialog("Ops!","No connection found", );
          },
        );

        var json = jsonDecode(response.body);
        print("json body: $json");
        LocalStorage.BearerTOKEN=json["token"];
        print(LocalStorage.BearerTOKEN);
        if(json['status']=="Password Incorrect"){
          showAlerDialog("Ops!","Password is incorrect, try with correct password.", );
        }else if(json['status']=="No user found"){
          showAlerDialog("Ops!","No user found by name $email", );
        }else{
          if (response.statusCode == 200) {

            if(json.length==0){
              showAlerDialog("Ops!","No user found !",);
            }else{
              LocalStorage.AdminEmail=email;
              LocalStorage.ADMINID = json['data'][0]['_id'];
              LocalStorage.ADMINNAME = json['data'][0]['FullName'];
              LocalStorage.AdminPassword = json['data'][0]['Password'];
              if(json['data'][0]['Gender']==null ||json['data'][0]['Gender'] == ''){
                LocalStorage.AdminGender = "";
              }else{
                LocalStorage.AdminGender = json['data'][0]['Gender'];
              }

              // localStorage.userAddress = json[0]['Address'];
              //  localStorage.userMobile = json[0]['Contact'];
              LocalStorage.AdminEmail = json['data'][0]['Email'];
              if(json['data'][0]['DOB']==null ||json['data'][0]['DOB'] == ''){
                LocalStorage.AdminDOB = '';
              }else{
                LocalStorage.AdminDOB = json['data'][0]['DOB'];
              }

              // localStorage.userType = json['data'][0]['UserType'];
              if(json['data'][0]['ProfilePic']==null || json['data'][0]['ProfilePic']==''){
                LocalStorage.ADMINIMAGE = '${WebApi.basesUrl}/Image/male.png';

                // if(localStorage.userGender=='Male'){
                //   localStorage.userProfilePic = '${WebApi.basesUrl}/Image/male.png';
                // }else{
                //   localStorage.userProfilePic = '${WebApi.basesUrl}/Image/female.png';
                // }
              }else{
                if(json['data'][0]['ProfilePic'].toString().contains('undefined')){
                  // if(localStorage.userGender=='Male'){
                  //   localStorage.userProfilePic = '${WebApi.basesUrl}/Image/male.png';
                  // }else{
                  //   localStorage.userProfilePic = '${WebApi.basesUrl}/Image/female.png';
                  // }
                  LocalStorage.ADMINIMAGE = '${WebApi.basesUrl}/Image/male.png';
                }else{
                  LocalStorage.ADMINIMAGE= '${WebApi.basesUrl}'+json['data'][0]['ProfilePic'].toString().substring(2);

                }
                print('profilepic : "${LocalStorage.ADMINIMAGE}"');
              }
              if(json['data'][0]['FirstName']==null || json['data'][0]['FirstName']==''){

                LocalStorage.AdminFirstName= '';
              }else{
                // SharedPreferences preferences = await SharedPreferences.getInstance();
                LocalStorage.AdminFirstName= json['data'][0]['FirstName'];
                //  preferences.setString("userFirstName", localStorage.userFirstName);
              }
              if(json['data'][0]['LastName']==null || json['data'][0]['LastName']==''){

                LocalStorage.AdminLastName = '';
              }else{
                //  SharedPreferences preferences = await SharedPreferences.getInstance();
                LocalStorage.AdminLastName= json['data'][0]['LastName'];
                // preferences.setString("userLastName", localStorage.userLastName);

              }
              if(json['data'][0]['UserName']==null || json['data'][0]['UserName']==''){

                LocalStorage.AdminUserName = '';
              }else{
                LocalStorage.AdminUserName= json['data'][0]['UserName'];
              }
              if(json['data'][0]['MobileNo']==null || json['data'][0]['MobileNo']==''){

                LocalStorage.AdminMobile = '';

              }else{
                LocalStorage.AdminMobile = json['data'][0]['MobileNo'];
              }

              if(json['data'][0]['AdminControlId']==LocalStorage.ADMINID){
                await PreferencesManager.setLoggedIn(true);
                SharedPreferences preferences = await SharedPreferences.getInstance();
                preferences.setString('logedin', "yes");
                preferences.setString('userId', LocalStorage.ADMINID);
                preferences.setString('userName', LocalStorage.AdminUserName);
                preferences.setString('firstName', LocalStorage.AdminFirstName);
                preferences.setString('lastName', LocalStorage.AdminLastName);
                preferences.setString('fullName', LocalStorage.ADMINNAME);
                preferences.setString('email', LocalStorage.AdminEmail);
                // preferences.setString('dob', LocalStorage.AdminDOB);
                preferences.setString('mobileNo', LocalStorage.AdminMobile);
                preferences.setString('profilePic', LocalStorage.ADMINIMAGE);
                preferences.setString('token', LocalStorage.BearerTOKEN);
                if(LocalStorage.BearerTOKEN!=null||LocalStorage.BearerTOKEN!=""){
                  Get.to(()=>MyApp());

                }else{
                  showAlerDialog("Warning!", "No token found for this device");
                }
                socketController.socket.connect();
              }else{
                showAlerDialog("Ops!", "You are not admin yet!");
              }

              //  print(socketController.socket.id);
            }

            // Do whatever you want to do with json.
          }else{
            showAlerDialog("Warning","Server error!", );
          }
        }



      } on TimeoutException catch (_) {
        showAlerDialog("Ops!","No connection found!",);

      } on SocketException catch (_) {
        showAlerDialog("Ops!","No internet!",);

      }

      print(LocalStorage.BearerTOKEN);


      return true;
    });

  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
//     Timer(
//       Duration(seconds: 3),
//           () async {
//         WidgetsFlutterBinding.ensureInitialized();
//         SharedPreferences preferences = await SharedPreferences.getInstance();
//
//         var logedin = preferences.getString('logedin');
//
//         print(logedin);
//         print("aooooo");
//
//         if (logedin == "yes") {
//           Get.to(()=>MyDashBoard());
//         }
// //IntroScreen
//         if (logedin == "no") {
//           Get.to(()=>LoginPage());
//         } //SignIn
//         // if (logedin != "yes" && logedin == null) {
//         //   Get.to(()=>MyDashBoard());
//         // }
//       },
//     );
    //  skipLogin();
  }
// Future<void> deleteCacheDir() async {
//   final cacheDir = await getTemporaryDirectory();
//   print(cacheDir.existsSync());
//   if (cacheDir.existsSync()) {
//     cacheDir.deleteSync(recursive: true);
//   }
//   print(cacheDir.existsSync());
// }
//
// Future<void> deleteAppDir() async {
//   final appDir = await getApplicationSupportDirectory();
//   print(appDir.existsSync());
//   if(appDir.existsSync()){
//     appDir.deleteSync(recursive: true);
//   }
//   print(appDir.existsSync());
// }
}
