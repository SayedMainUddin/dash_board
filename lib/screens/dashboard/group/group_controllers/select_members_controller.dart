import 'dart:convert';

import 'package:dash_board/constants.dart';
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/Users.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class AddMemberController extends GetxController{
  ApiController gc=Get.put(ApiController());
  final groupmember = <User>[].obs;
  final searchList = <User>[].obs;
  final allFriendListForGroup=<User>[].obs;


  final allGroupMembers = <User>[].obs;
  final searchControllerInAddFirend=TextEditingController().obs;
  void searchInFriends(String enteredKeyword) {

    List<User> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = searchList;
    } else {
      results = searchList
          .where((user) =>
          user.userName!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    allGroupMembers.value = results;
    update();
  }
  void removeGroupMember(index){
    groupmember.remove(allGroupMembers[index]);
    allGroupMembers[index].isSelected = false;
    update();
  }
  void addGroupMember(index){
    if (allGroupMembers[index - 1]
        .isSelected == true) {
      groupmember.remove(
          allGroupMembers[index - 1]);
      allGroupMembers[index - 1].isSelected =
      false;
    } else {
      groupmember.add(
          allGroupMembers[index - 1]);
      allGroupMembers[index - 1].isSelected =
      true;
    }
    update();
  }
  loadFriendListForGroup() async {
    var searchValue='';
    if(searchControllerInAddFirend.value.text==null){
      searchValue=searchControllerInAddFirend.value.text;


    }else{
      searchValue=searchControllerInAddFirend.value.text;
    }
    Map data = {
      'AdminId': LocalStorage.ADMINID,
    };
    final response = await http.post(Uri.parse('${WebApi.basesUrl}/allUserforControllbyadmin', ),
        headers: {'connection': "keep-alive",},
        body: data
    );
    var json = jsonDecode(response.body);
    // var json=jsonDecode(result);
     print('all friends for group :'+ json.toString());

    if(response.statusCode==200){
      for (var i = 0; i < json.length; i++) {
        var userId = json[i]['_id'];
        var userName = json[i]['FullName'];
        var userEmail = json[i]['Email'];
        var userImage = json[i]['ProfilePic'];
        var userGender = json[i]['Gender'];
        var userType=json[i]['UserType'];
        var isActive=json[i]['AccountStatus'];
        var userDOB=json[i]['DOB'];

        if(userImage==null||userImage=='' ||userImage.toString().contains("undefined")){
          if(userGender=='Male'){
            userImage='${WebApi.basesUrl}/Image/male.png';
          }else{
            userImage='${WebApi.basesUrl}/Image/female.png';
          }

        }else{
          userImage='${WebApi.basesUrl}/'+userImage.toString().substring(3);
        }
        //  print(userImage);
        if (userId != LocalStorage.ADMINID) {
          final User searchCOntact = User(
            userId: userId,
              userName: userName,
              userImageUrl: userImage,
              status: "This is test",
              gender:userGender,
              uniqueId: userId,
              email: userEmail,
              Type: userType,
              StoryList: []
          );

          allFriendListForGroup.add(searchCOntact);




        } else {
          print("Same contact found ");
        }
      }
    }
    // allFriendGroupCreate.value=[];
    update();
    return;
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadFriendListForGroup();
    searchList.value=allFriendListForGroup;
    allGroupMembers.value=allFriendListForGroup;
  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

}