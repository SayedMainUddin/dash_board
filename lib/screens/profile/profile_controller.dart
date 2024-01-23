import 'dart:convert';
import 'dart:io';
import 'package:dash_board/models/message.dart';
import 'package:dash_board/screens/login/login_controller.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/socket.dart';
import 'package:dash_board/utils/urls.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'dart:io' show Platform, exit;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../login/login_screen.dart';
List<MESSAGE> sharedGalleryList =[];
List<MESSAGE> sharedGalleryFileList =[];
List<String> previewsharedGalleryList =[];
List<String> previewsharedGalleryFileList =[];
class ProfileController extends GetxController{
  final sharedGalleryList =<MESSAGE>[].obs;
  final sharedGalleryFileList =<MESSAGE>[].obs;
  final SocketController socketController=Get.put(SocketController());
  List<XFile>? _imageFileList;

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  bool isVideo = false;



  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  RxBool isExpanded = false.obs;

  void changeExpandedState() {

    isExpanded.value = !isExpanded.value;
    // isEdit.value=true;
    if(isEdit.value==true){
      isEdit.value=false;
    }else{
      isEdit.value=true;

    }
    update();
  }



  static String usrPic="assets/images/male.jpg";

  String   usrName="";
  String   firstName="";
  String   lastName="";
  String   userName="";
  String   usrAddr="";
  String   usrAbout='User Address';
  String   usrMob='';
  String   usrDob='';
  String   usrMail='';
  String   usrGender='';
  String   grpPic='User Address';
  String   usrOfficialMobile='User Address';
  String   hiddenSelecUserId='User Address';
  String   loggedUserAbout='User Address';
  String   muteAction='User Address';
  String   muteNotification='User Address';
  String   lastSeenAction='User Address';
  String   aboutPrivacy='User Address';
  String   profilePicturePrivacy='User Address';
  String   usrSecondMail="User Name";

  final ownUserId=LocalStorage.ADMINID;
  final user=LocalStorage.AdminUserName;
  final isEdit = true.obs;

  final isEditablePersonalInfo = false.obs,
      isEditableLocation = false,
      isEditableContact = false,
      isEditableEmail = false;
  TextEditingController firstNameController = TextEditingController(text: LocalStorage.AdminFirstName==''?"First Name":LocalStorage.AdminFirstName),
      lastNameController = TextEditingController(text: LocalStorage.AdminLastName==''?"Last Name":LocalStorage.AdminLastName),
      userNameController = TextEditingController(text: LocalStorage.ADMINNAME==''?"User Name":LocalStorage.ADMINNAME),
      birthdayController = TextEditingController(text: LocalStorage.AdminDOB==''?'Dob':LocalStorage.AdminDOB);
  TextEditingController emailController = TextEditingController(text: LocalStorage.AdminEmail==''?'Mail':LocalStorage.AdminEmail),
      mobileController = TextEditingController(text: LocalStorage.AdminMobile==''?'Mobile':LocalStorage.AdminMobile),
      genderController = TextEditingController(text: LocalStorage.AdminGender==''?'Gender':LocalStorage.AdminGender);

  //all bool for data show after progressbar
  bool _isProfilePicShow=false;
  bool _isProfilePicPost=false;
  bool _isPersonInformationShow=false;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadSharedGallery();

  }

  void showInSnackBar(String value) {
    Get.defaultDialog(
        title: "Success!",
        content: Text(value)
    );
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text(value)));

    //_scaffoldKey.currentState!.showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<void> loadSharedGallery() async {

    Map data = {
      'UserId': LocalStorage.ADMINID,
      'SelectId':LocalStorage.ADMINID ,
      'UserType':"user",



    };

    final response = await http.post(Uri.parse('${WebApi.basesUrl}/sharedGallery'),
        headers: {'connection': "keep-alive",'Authorization': 'Bearer ${LocalStorage.BearerTOKEN}'},

        body: data
    );

    var json = jsonDecode(response.body);
    //  print("Hit shared gallery");


    //print(reply);
    sharedGalleryList.value=[];
    sharedGalleryFileList.value=[];
    previewsharedGalleryList=[];
    previewsharedGalleryFileList=[];
    if (response.statusCode == 200) {
      var xtrNormTxt='';
      //  print("Shared Gallery Length: ${json.length}");
      for (var i = 0; i < json.length; i++) {
        if(json[i]['Type']=="File"){
          final MESSAGE currentMessage = MESSAGE(
              id: json[i]['_id'],
              msgType:json[i]['Type'] ,
              messageText: json[i]['Message'],
              fileSize: json[i]['FileSize']
          );
          sharedGalleryFileList.add(currentMessage);
          previewsharedGalleryFileList.add(json[i]['Message']);
        }
        // print(sharedGalleryFileList[i].fileSize);
        if(json[i]['Type']=="Image"||json[i]['Type']=="Multi-Image"){


          if(json[i]['Type']=='Multi-Image'){
            print(json[i]['Message'].length);
            for(var j=0;j<json[i]['Message'].length;j++){
              xtrNormTxt = xtrNormTxt + ','+  json[i]['Message'][j]["FileName"].toString();
              print('all messages : ${json[i]['Message'][j]["FileName"].toString().substring(2)}');
              print('all messages2 : $xtrNormTxt');
            }



            var groupImage = xtrNormTxt.toString().split(",");
            print('total image length : ${groupImage.length}');
            for(var k=1;k<groupImage.length;k++){
              final MESSAGE currentMessage = MESSAGE(
                  id: json[i]['_id'],
                  msgType:json[i]['Type'] ,
                  messageText: groupImage[k]
              );
              sharedGalleryList.add(currentMessage);
              previewsharedGalleryList.add(groupImage[k]);
            }
          }else{
            final MESSAGE currentMessage = MESSAGE(
                id: json[i]['_id'],
                msgType:json[i]['Type'] ,
                messageText: json[i]['Message']
            );
            sharedGalleryList.add(currentMessage);
            previewsharedGalleryList.add(json[i]['Message']);
          }
        }
      }
      // if(mounted){
      //   setState(() {
      //     sharedGalleryList=sharedGalleryList;
      //   });
      // }
      // if(mounted){
      //   setState(() {
      //     sharedGalleryFileList=sharedGalleryFileList;
      //   });
      // }
    };
  }
  void UserProfilePost() async {

    Map data = {
      'UserId': LocalStorage.ADMINID,
      'FirstName':firstNameController.text ,
      'LastName':lastNameController.text ,
      'DOB':birthdayController.text ,
      'Gender':genderController.text ,
      'MobileNo':mobileController.text  ,
      'UserName':userNameController.text  ,


    };

    final response = await http.post(Uri.parse('${WebApi.basesUrl}/editProfileInfo'),
        headers: {'connection': "keep-alive",'Authorization': 'Bearer ${LocalStorage.BearerTOKEN}'},

        body: data
    );
    var json = jsonDecode(response.body);
    print("profile data :"+json.toString());
    print("profile data1 ${response.statusCode}");
    if(response.statusCode==200){
      showInSnackBar('Profile Information successfully updated!');
      LocalStorage.AdminMobile=mobileController.text;
      LocalStorage.ADMINNAME=userNameController.text;
      _isPersonInformationShow=true;
    }
    update();
  }



  var   userProfileImage;
  Future<void> showChoiceDialog(BuildContext context)
  {
    return showDialog(context: context,builder: (BuildContext context){

      return AlertDialog(
        title: Text("Choose option",style: TextStyle(color: Colors.blue),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  isVideo = false;
                  profilePicChange(ImageSource.gallery, context: context);
                  /// profilePicChange(ImageSource.gallery,isMultiImage: false,context: context);
                  Navigator.pop(context);
                },
                title: Text("Gallery"),
                leading: Icon(Icons.account_box,color: Colors.blue,),
              ),

              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  var    pageName='UserProfile';
                  Navigator.pop(context);
                  // Navigator.push(context, MaterialPageRoute(builder: (_)=>CameraScreen(whichPage: pageName,)));
                  //
                  // Navigator.pop(context);
         
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color: Colors.blue,),
              ),
              Divider(height: 1,color: Colors.blue,),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text('Choose your avator',style: TextStyle(
                        letterSpacing: 2,fontWeight: FontWeight.w600
                    ),),
                  ),
                  LocalStorage.AdminGender=='Female'||LocalStorage.AdminGender=='Others'? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              LocalStorage.ADMINIMAGE='${WebApi.basesUrl}/Image/female.png';

                              Navigator.pop(context);
                              showInSnackBar('Profile Avatar successfully changed!');
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.network('${WebApi.basesUrl}/Image/female.png'),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              LocalStorage.ADMINIMAGE='${WebApi.basesUrl}/Image/female2.png';

                              Navigator.pop(context);
                              showInSnackBar('Profile Avatar successfully changed!');
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.network('${WebApi.basesUrl}/Image/female2.png'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              LocalStorage.ADMINIMAGE='${WebApi.basesUrl}/Image/female3.png';

                              Navigator.pop(context);
                              showInSnackBar('Profile Avatar successfully changed!');
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.network('${WebApi.basesUrl}/Image/female3.png'),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              LocalStorage.ADMINIMAGE='${WebApi.basesUrl}/Image/female4.png';

                              Navigator.pop(context);
                              showInSnackBar('Profile Avatar successfully changed!');
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.network('${WebApi.basesUrl}/Image/female4.png'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ):
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              LocalStorage.ADMINIMAGE='${WebApi.basesUrl}/Image/male.png';


                              Navigator.pop(context);
                              showInSnackBar('Profile Avatar successfully changed!');
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.network('${WebApi.basesUrl}/Image/male.png'),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              LocalStorage.ADMINIMAGE='${WebApi.basesUrl}/Image/male2.png';

                              Navigator.pop(context);
                              showInSnackBar('Profile Avatar successfully changed!');
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.network('${WebApi.basesUrl}/Image/male2.png'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              LocalStorage.ADMINIMAGE='${WebApi.basesUrl}/Image/male3.png';

                              Navigator.pop(context);
                              showInSnackBar('Profile Avatar successfully changed!');
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.network('${WebApi.basesUrl}/Image/male3.png'),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              LocalStorage.ADMINIMAGE='${WebApi.basesUrl}/Image/male4.png';

                              Navigator.pop(context);
                              showInSnackBar('Profile Avatar successfully changed!');
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.network('${WebApi.basesUrl}/Image/male4.png'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )

            ],
          ),
        ),);
    });
  }
  XFile? pickedFile=null;
  Future<void> profilePicChange(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    var header = {
      "Authorization":"Bearer ${LocalStorage.BearerTOKEN}"
    };
    pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 100,
    );
    String listOfFile = pickedFile!.path
        .split("/")
        .last;
    print(listOfFile);
    var stream =  new http.ByteStream(DelegatingStream.typed(pickedFile!.openRead()));
    var length = await pickedFile!.length();
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: listOfFile);
    var request = new http.MultipartRequest("POST",Uri.parse('${WebApi.basesUrl}/editProfilePicture') );
    // add file to multipart
    request.files.add(multipartFile);
    request.headers.addAll(header);
    request.fields["UserId"] = ownUserId;
    request.fields["SystemPic"] = 'no';
    request.fields["FineName"] = listOfFile;
    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        final dir = Directory(pickedFile!.path);
        dir.deleteSync(recursive: true);
        String jsonStr = value;

        // Parse the JSON string
        Map<String, dynamic> jsonData = json.decode(jsonStr);

        // Access the "Data" field
        String dataValue = jsonData["Data"];
        if (dataValue.startsWith('../')) {
          dataValue = dataValue.substring(2);
        }
        print(dataValue); // T
        userProfileImage = '${WebApi.basesUrl}'+ dataValue;
        LocalStorage.ADMINIMAGE=userProfileImage;

      });

    }).catchError((e) {
      print(e);
    });


    update();

  }
  Widget iconBuilder(IconData icon){
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: Container(
        width: 32,
        height: 30,
        child: Icon(icon,
          size: 20,
          color:Get.isDarkMode? Colors.white:Colors.black,
        ),
        decoration: BoxDecoration(
          color: Get.isDarkMode? Colors.white:Colors.black,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight:
              Radius.circular(12)),
        ),
      ),
    );
  }


  Widget divider() {
    return SizedBox(
      height: 1.5,
      child: Container(
        color: Colors.white,
      ),
      // color: Colors.white,
    );
  }

  Widget infoCard(String title, String value, Color color, IconData icon,
      bool isEnabled, TextEditingController controller, Function onPressed) {
    return InkWell(
      onTap: onPressed(),
      child: Container(
        color: isEnabled ? Get.isDarkMode? Colors.blue:Colors.blueGrey : Colors.transparent,
        margin: EdgeInsets.only(left: 0, right: 20, top: 12, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    title,
                    style: TextStyle(
                        color:
                        Get.isDarkMode? Colors.white:Colors.black,
                        fontSize: 14),
                  ),
                )
              ],
            ),
            Flexible(
                child: Container(
                  child: TextFormField(
                    controller: controller,
                    enabled: isEnabled,
                    // initialValue: value,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Get.isDarkMode? Colors.white:Colors.indigo,
                    ),
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(3),
                        hintText: "One",
                        // border: OutlineInputBorder()
                        border: InputBorder.none),
                  ),
                ))
          ],
        ),
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
        Navigator.pop(context);

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
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    //  _controller!.dispose();

  }
}