import 'dart:convert';
import 'package:dash_board/constants.dart';
import 'package:dash_board/models/Groups.dart';
import 'package:dash_board/models/Users.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GroupController extends GetxController{

  final searchController = new TextEditingController().obs;
  final ownImage=''.obs;
  final allGroupListArray = <Group>[].obs;
  final groupMembersIdList = <dynamic>[].obs;
  final selectedMemberList=<User>[].obs;
  final ownUserId=LocalStorage.ADMINID;
  final user=LocalStorage.ADMINNAME;
  final userUnique=LocalStorage.ADMINID;
  bool _isLoadGroupList=false;
  final searchGroupList = <Group>[].obs;
  final isSearchButtonClick=false.obs;
  final isMemberAdded=false.obs;
  rtvGroupLists() async {
    Map data = {
      'AdminId': LocalStorage.ADMINID,
    };
    final response =
    await http.post(Uri.parse('${WebApi.basesUrl}/allGroupforControllbyadmin0'),
        headers: {
          'connection': "keep-alive",
        //  'Authorization': 'Bearer ${localStorage.bearerToken}'
        },
        body: data);
    var json = jsonDecode(response.body);
    // print('all group : ${json}');
    allGroupListArray.value = [];
    searchGroupList.value = [];
    groupMembersIdList.value=[];
    var groups=json;
    // //print(groups.length);
    var individualName,
        individualPic,
        individualId,
        selectedType,
        notific,
        muteStatus,
        privacy,
        groupAdmin,
        deletedForever;
    //console.log("ProfilePic: "+json.ProfilePic[0].ProfilePicture);
    for (var i = 0; i < groups.length; i++) {
      if (groups.length > 0) {
        if(groups[i]["GroupInfo"].length>0){
          //   print(groups[i]['GroupInfo'][0]['GroupPic']);
          if (groups[i]['GroupInfo'][0]['GroupPic'] == '' ||
              groups[i]['GroupInfo'][0]['GroupPic']  == null ||
              groups[i]['GroupInfo'][0]['GroupPic']  == 'undefined') {
            individualPic = "${WebApi.basesUrl}/Image/group.png";
          } else {
            individualPic = '${WebApi.basesUrl}'+groups[i]['GroupInfo'][0]['GroupPic'].toString().substring(2);
          }
          individualName = groups[i]['GroupInfo'][0]['GroupName'];
          individualId = groups[i]['GroupInfo'][0]['_id'];
          groupMembersIdList.value = groups[i]['GroupInfo'][0]['MembersID'];
          groupAdmin = groups[i]['GroupInfo'][0]['Admin'];
          privacy = groups[i]['GroupInfo'][0]['Privacy'];
          selectedType = "Group";
          muteStatus = groups[i]['GroupInfo'][0]['SelectedUserMute'];
          notific=groups[i]['GroupInfo'][0]['IsNotification'];
          deletedForever="OFF";
          var lastMsg="No chat yet";
          var lastmsgtime=" ";
          final Group currentGroups = Group(
              id: individualId.toString(),
              groupName: individualName,
              groupPic: individualPic,
              adminID: groupAdmin,
              privacy: privacy,
              membersID: groupMembersIdList,
            dateTime: "12-10-2023"
          );
          // //print(individualPic);
          if(privacy=="Private"){
            if(groupMembersIdList.contains(LocalStorage.ADMINID)){
              allGroupListArray.add(currentGroups);
              searchGroupList.add(currentGroups);
            }else{
            }
          }else{
            allGroupListArray.add(currentGroups);
            searchGroupList.add(currentGroups);

          }
        }else{
          print('no group info');
        }
      }



      // searchGroupList.value=allGroupListArray;
    }
    _isLoadGroupList=true;
    update();


  }
  searchBar(){
    if(isSearchButtonClick.value==true){
      isSearchButtonClick.value=false;
      searchController.value.text='';
      rtvGroupLists();
    }else{
      isSearchButtonClick.value=true;
      searchController.value.text='';
      rtvGroupLists();
    }
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    init();

  }

  init() {
    rtvGroupLists();
  }

  void searchInFriends(String enteredKeyword) {
    //print("value count");
    List<Group> results = [];
    // allGroupListArray.value=[];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = searchGroupList;
    } else {
      results = searchGroupList
          .where((user) =>
          user.groupName.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    allGroupListArray.value = results;

    update();
  }
}