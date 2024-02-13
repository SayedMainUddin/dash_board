import 'dart:convert';
import 'package:dash_board/constants.dart';
import 'package:dash_board/models/Groups.dart';
import 'package:dash_board/models/Users.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/socket.dart';
import 'package:dash_board/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:dash_board/screens/dashboard/group/group_info.dart';


class GroupController extends GetxController{
  final SocketController socketController=Get.put(SocketController());
  final searchController = new TextEditingController().obs;
  final ownImage=''.obs;
  final selectedId=''.obs;
  final selectedName=''.obs;
  final selectedType=''.obs;
  var allGroupListArray = <Group>[].obs;
  var groupMembersIdList = <dynamic>[].obs;
  final selectedMemberList=<User>[].obs;
  final ownUserId=LocalStorage.ADMINID;
  final user=LocalStorage.ADMINNAME;
  final userUnique=LocalStorage.ADMINID;
  bool _isLoadGroupList=false;
  final searchGroupList = <Group>[].obs;
  final isSearchButtonClick=false.obs;
  final isMemberAdded=false.obs;
  var grpName = "groupName";
  var name = "name";
  var GroupAdmin = "name";
  var adminId = ''.obs;
  var grpPic = "${WebApi.basesUrl}/Image/Female.png";
  var groupMemberArray = [];
  var groupMemberIdArray = <String>[].obs;
  var allGroupMember = <GroupMember>[].obs;
  var groupMemberForExistingArray = <GroupMember>[].obs;
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
  rtvGroupProfile(groupId) async {

    Map data = {
      'GroupId': groupId,};

    final response = await http.post(Uri.parse('${WebApi.basesUrl}/loadAllGroupMemberByGroupId'),
        headers: {'connection': "keep-alive",'Authorization': 'Bearer ${LocalStorage.BearerTOKEN}'},
        // if needed
        body: data
    );
    var json = jsonDecode(response.body);
    print("Group members details: $json");
    if (response.statusCode == 200) {

      var MemberId, MemberName, MemberImageUrl;
      allGroupMember.value = [];
      groupMemberIdArray.value=[];
      if (json[0]["GroupPic"] == '' ||
          json[0]["GroupPic"] == null ||
          json[0]["GroupPic"] == 'undefined') {
        grpPic = "${WebApi.basesUrl}/Image/group.png";
      } else {
        grpPic ="${WebApi.basesUrl}${json[0]['GroupPic'].toString().substring(2)}";
      }
      grpName = json[0]['GroupName'];
      grpName = grpName;
      grpPic=grpPic;
      for (var i = 0; i < json[0]["GroupMemberInfo"].length; i++) {
        if (json[0]["GroupMemberInfo"][i]["ProfilePic"] == '' ||
            json[0]["GroupMemberInfo"][i]["ProfilePic"] == null ||
            json[0]["GroupMemberInfo"][i]["ProfilePic"] == 'undefined') {
          if (json[0]["GroupMemberInfo"][i]["Gender"] == "Male") {
            MemberImageUrl = "${WebApi.basesUrl}/Image/male.png";
          } else {
            MemberImageUrl = "${WebApi.basesUrl}/Image/female.png";
          }
        } else {
          MemberImageUrl = "${WebApi.basesUrl}" +
              json[0]['GroupMemberInfo'][i]['ProfilePic'].toString().substring(2);
        }
        MemberId = json[0]["GroupMemberInfo"][i]["_id"];
        MemberName = json[0]["GroupMemberInfo"][i]["FullName"];
        adminId.value = json[0]["Admin"];

        groupMemberIdArray.add(json[0]["GroupMemberInfo"][i]["_id"]);

        final GroupMember currentGroupUser = GroupMember(
            id: i,
            uniqueId: MemberId,
            name: MemberName,
            imageUrl: MemberImageUrl,
            //Type: selectedType,
            admin: adminId.value);
        // print(individualPic);
        allGroupMember.add(currentGroupUser);
        for(var member in allGroupMember){
          // print('memberid ${member.uniqueId.toString()}');
          //print('adminId $adminId');
          if (member.uniqueId.toString() == adminId) {
            GroupAdmin= member.name!;

          }
        }
      }

      //  rtvFriendForExistingGrp(groupMemberIdArray);
    }
    update();
  }
  Future<void> sendPollMsgtoServer(pollMessage,selectedId,selectedName,selectedType) async {
    //String datetime = DateFormat('dd/MM/yyyy hh:mm a').format(d);

    if (pollMessage != "" || pollMessage != null) {

      var sntData = {
        "UserId": LocalStorage.ADMINID,
        "SelectId": selectedId,
        "Message": pollMessage,
        "MsgType": "Poll",
        "FileName": "",
        "UserType": selectedType,
        "ReceiverName":selectedName,
        "SenderName":LocalStorage.ADMINNAME
      };
      socketController.socket.emit('sendMessage', sntData);
    } else {
      print("Are You Crazy");
    }
  }
  String updatePollMessage(String originalMessage, String votedOption, String voterId, String messageId) {
    List<String> parts = originalMessage.split('\n');

    if (parts.length >= 3) {
      String question = parts[0].substring('Question: '.length);
      List<String> options = parts[1].substring('Options: '.length).split(', ');
      String updatedQuestionPart = 'Question: $question';
      String updatedOptionsPart = 'Options: ${options.join(', ')}';
      Map<String, dynamic>? votes;
      if (parts[2].startsWith('Votes: ') && parts[2].length > 'Votes: '.length) {
        votes = jsonDecode(parts[2].substring('Votes: '.length));
      } else {
        votes = {};
        for (String option in options) {
          votes[option] = {'voterIds': [], 'count': 0};
        }
      }
      String userVote = votedOption; // Assume the user voted for 'yes'
      String userId = voterId; // Sample user ID

      if (options.contains(userVote)) {
        votes![userVote]!['voterIds'].add(userId); // Add voter ID
        votes[userVote]!['count']++; // Increment the vote count
      }

      String updatedVotesPart = 'Votes: ${jsonEncode(votes)}';
      String updatedMessage = '$updatedQuestionPart\n$updatedOptionsPart\n$updatedVotesPart';

      if (updatedMessage.isNotEmpty) {
        var sntData = {
          "MessageId": messageId,
          "UserId": LocalStorage.ADMINID,
          "SelectId": selectedId.value,
          "Message": updatedMessage,
          "MsgType": "Poll",
          "FileName": "",
          "UserType": selectedType.value,
          "ReceiverName": selectedName.value,
          "SenderName": LocalStorage.ADMINNAME
        };
        socketController.socket.emit('updateMessageForPoll', sntData);
      } else {
        print('Error: Invalid message format');
      }

      return updatedMessage;
    } else {
      print("Invalid message format");
      return originalMessage;
    }
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
