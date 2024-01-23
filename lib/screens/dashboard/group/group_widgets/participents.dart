import 'dart:convert';
import 'package:dash_board/models/ChatMessage.dart';
import 'package:dash_board/screens/dashboard/group/group_info.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/socket.dart';
import 'package:dash_board/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

var color = [
  {'icon': 0xFF8C93C7},
  {'barBg': 0xFF8EDEDFB},
  {'text': 0xFF464A64},
  {'barShadow': 0xFFA5A3D1},
  {'bg': 0xFFF4F4F9},
  {'iconBelow': 0xFF464A65},
  {'iconBg': 0xFFCBC8E5},
];

class GroupInfoScreen extends StatefulWidget {
  String? groupName;
  String? groupId;

  GroupInfoScreen({this.groupName,this.groupId});
  @override
  State<StatefulWidget> createState() {
    return GroupInfoScreenState();
  }
}
List<ChatMessage> grpSharedGalleryList =[];
List<String> grpPreviewsharedGalleryList =[];
class GroupInfoScreenState extends State<GroupInfoScreen> {
  final SocketController socketController=Get.put(SocketController());

  @override
  void initState() {
    rtvGroupProfile(widget.groupId);
    rtvSharedGalleryForGrp();
    socketController.socket.on('removeMemeberFromExistGroupSuccess' + LocalStorage.ADMINID,(data) {
      print("member remove from group");
      rtvGroupProfile(data);

    });

    socketController.socket.on('memberAlertForGrpAdd' + LocalStorage.ADMINID,(data) {
      rtvGroupProfile(data);
    });
    socketController.socket.on('addMemeberToExistGroupSuccess' + LocalStorage.ADMINID,(data) {
      rtvGroupProfile(data);
    });
    socketController.socket.on('leavefromGroupSuccess' + LocalStorage.ADMINID,  (data) {
      print("Group Leave");
      rtvGroupProfile(data);
      //cc.selectedId.value = "";
      // if (mounted) {
      //   Navigator.of(context).pop(false);
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (_) => MyDashBoard()));
      // }
    });
    // TODO: implement initState

    // loadFriendListForGroup(context);
    // rtvSharedGalleryForGrp();
    // rtvGroupProfile(TestChat.selectedUserID);
    // rtvSharedGalleryForGrp(TestChat.selectedUserID);
    super.initState();
  }
  final ownUserId = LocalStorage.ADMINID;
  final user = LocalStorage.ADMINNAME;
  final userUnique = LocalStorage.ADMINID;
  var grpName = "groupName";
  var name = "name";
  var GroupAdmin = "name";
  var adminId = '';
  var grpPic = "${WebApi.basesUrl}/Image/Female.png";
  var groupMemberArray = [];
  List<GroupMember> allGroupMember = [];
  List<GroupMember> groupMemberForExistingArray = [];

  rtvGroupProfile(memberId) async {

    Map data = {
      'GroupId': widget.groupId,};

    final response = await http.post(Uri.parse('${WebApi.basesUrl}/loadAllGroupMemberByGroupId'),
        headers: {'connection': "keep-alive",'Authorization': 'Bearer ${LocalStorage.BearerTOKEN}'},
        // if needed
        body: data
    );
    var json = jsonDecode(response.body);
    print(json);
    if (response.statusCode == 200) {

      var MemberId, MemberName, MemberImageUrl;
      allGroupMember = [];
      groupMemberIdArray=[];
      if (json[0]["GroupPic"] == '' ||
          json[0]["GroupPic"] == null ||
          json[0]["GroupPic"] == 'undefined') {
        grpPic = "${WebApi.basesUrl}/Image/group.png";
      } else {
        grpPic ="${WebApi.basesUrl}${json[0]['GroupPic'].toString().substring(2)}";
      }
      grpName = json[0]['GroupName'];
      if(mounted){
        setState(() {
          grpName = grpName;
          grpPic=grpPic;
        });
      }
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
          MemberImageUrl = "${WebApi.basesUrl}/" +
              json[0]['GroupMemberInfo'][i]['ProfilePic'].toString().substring(2);
        }
        MemberId = json[0]["GroupMemberInfo"][i]["_id"];
        MemberName = json[0]["GroupMemberInfo"][i]["FullName"];
        adminId = json[0]["Admin"];

        groupMemberIdArray.add(json[0]["GroupMemberInfo"][i]["_id"]);

        final GroupMember currentGroupUser = GroupMember(
            id: i,
            uniqueId: MemberId,
            name: MemberName,
            imageUrl: MemberImageUrl,
            //Type: selectedType,
            admin: adminId);
        // print(individualPic);
        allGroupMember.add(currentGroupUser);
        for(var member in allGroupMember){
          // print('memberid ${member.uniqueId.toString()}');
          //print('adminId $adminId');
          if (member.uniqueId.toString() == adminId) {
            if (this.mounted) {
              setState(() {
                GroupAdmin= member.name!;

              });
            }
          }
        }
      }

      rtvFriendForExistingGrp(groupMemberIdArray);
    }
  }
  rtvFriendForExistingGrp(value) async {
    // String jsonGroup = jsonEncode(value);
    // var array = value.replaceAll('"', '');
    //array = array.substring(1);
    //  array = array.substring(0, array.length - 1);
    var jsonArray=jsonEncode(value);

//print("group array: $jsonArray");
    Map data = {
      'UserId': LocalStorage.ADMINID,
      'MemberArray':jsonArray,
      'SystemType':"Mobile"



    };

    final response = await http.post(Uri.parse('${WebApi.basesUrl}/loadFriendListForExistingGrp'),
        headers: {'connection': "keep-alive",'Authorization': 'Bearer ${LocalStorage.BearerTOKEN}'},
        // if needed
        body: data
    );
    var json = response.body;
    //  print("all friend of group: ${response.body}");
    // var array = jsonArray.replaceAll('"', '');
    var result =jsonDecode(json);
    //  print("all friend of group: ${json}");

    groupMemberForExistingArray = [];
    if (response.statusCode == 200) {
      //var json=jsonDecode(json);
      var individualName, individualPic, individualId;
      for (var i = 0; i < result.length; i++) {
        if (result[i]['UserInfo'].length > 0) {
          // console.log("Name: " + json[i].name + "Data: " + json[i].ProfilePicData[0].ProfilePicture);
          if (result[i]['UserInfo'][0]['ProfilePic'] == '' ||
              result[i]['UserInfo'][0]['ProfilePic'] == null ||
              result[i]['UserInfo'][0]['ProfilePic'] == 'undefined') {
            if (result[i]['UserInfo'][0]['Gender'] == "Male") {
              individualPic = "${WebApi.basesUrl}/Image/male.png";
            } else {
              individualPic = "${WebApi.basesUrl}/Image/Female.png";
            }
          } else {
            individualPic = "${WebApi.basesUrl}/" +
                result[i]['UserInfo'][0]['ProfilePic']
                    .toString()
                    .substring(2);
          }
          individualName = result[i]['UserInfo'][0]['FullName'];
          individualId = result[i]['UserInfo'][0]['_id'];
        }
        final GroupMember currentGroupUser = GroupMember(
            id: i,
            uniqueId: individualId,
            name: individualName,
            imageUrl: individualPic
          //Type: selectedType,
        );
        groupMemberForExistingArray.add(currentGroupUser);
      }

    }
  }
  rtvSharedGalleryForGrp() async {
    Map data = {
      'UserId': LocalStorage.ADMINID,
      'SelectId':widget.groupId,
      'UserType':'Group' ,



    };

    final response = await http.post(Uri.parse('${WebApi.basesUrl}/sharedGallery'),
        headers: {'connection': "keep-alive",'Authorization': 'Bearer ${LocalStorage.BearerTOKEN}'},
        // if needed
        body: data
    );
    var json = jsonDecode(response.body);

    // print(json);
    grpSharedGalleryList=[];
    grpPreviewsharedGalleryList=[];
    if (response.statusCode == 200) {

      print("Shared Gallery Length: ${json.length}");
      for (var i = 0; i < json.length; i++) {
        var xtrNormTxt='';
        if(json[i]['Type']=="Image"){

          final ChatMessage currentMessage = ChatMessage(
              id: json[i]['_id'],
              type: json[i]['Type'] ,
              message: json[i]['Message']
          );
          grpSharedGalleryList.add(currentMessage);
          grpPreviewsharedGalleryList.add(json[i]['Message']);

        }
        else if(json[i]['Type']=="Multi-Image") {
          print(json[i]["Message"].length);
          for (var j = 0; j < json[i]["Message"].length; j++) {
            xtrNormTxt =
                xtrNormTxt + ',' + json[i]["Message"][j]["FileName"].toString();
            print('all messages : ${json[i]["Message"][j]["FileName"]
                .toString()}');
            print('all messages2 : $xtrNormTxt');
            final ChatMessage currentMessage = ChatMessage(
                id: json[i]['_id'],
                type: json[i]['Type'],
                message: json[i]["Message"][j]["FileName"].toString()

            );
            grpSharedGalleryList.add(currentMessage);
            grpPreviewsharedGalleryList.add(
                json[i]["Message"][j]["FileName"].toString().substring(1));
          }
        }

      }
      if(mounted){
        setState(() {
          grpSharedGalleryList=grpSharedGalleryList;
        });
      }
    };
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor:Get.isDarkMode?Colors.black: Color(0xfff4f4f9),
          appBar: AppBar(
            backgroundColor: Get.isDarkMode?Colors.black:Colors.white,
            foregroundColor: Get.isDarkMode?Colors.white:Colors.black,
            leading: InkWell(
              child: Icon(
                Icons.arrow_back,
                size: 26,
              ),
              onTap: () {
                // print('grp profile back');
                // Future.delayed(const Duration(milliseconds: 500), () {
                //   Get.off(()=>ConversationPage(), arguments: [
                //     {"selectedId": '${cc.selectedId.value}'},
                //     {"selectedType": '${cc.selectedType.value}'},
                //     {"selectedName": '${cc.selectedName.value}'},
                //     {"selectedImage": '${cc.selectedImage.value}'},
                //     {"userBlockStatus": 'No'},
                //     {"blockedBy": 'No'},
                //   ]);
                //
                // });


              },
            ),
            title: Text(
              widget.groupName!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                },
                child: Icon(Icons.more_vert_outlined),
              )
            ],
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.card_membership,size: 24,),
                        SizedBox(width: 20,),

                        InkWell(
                          onTap: (){
                            //  Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroupDetails(
                                      groupAdmin: GroupAdmin,groupName:  grpName,groupImage: grpPic,groupId:widget.groupId
                                  )),
                            );
                          },
                          child: Container(
                            child: Text('Group Details',style: TextStyle(
                                color: Get.isDarkMode? Colors.white:Colors.black,fontSize: 22
                            ),),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,size: 20,),
                      ],
                    ),
                  ),
                  Divider(thickness: 2,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.card_membership,size: 24,),
                        SizedBox(width: 20,),

                        InkWell(
                          onTap: (){
                            //    Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MemberDetails(
                                    GroupMemberList: allGroupMember,GroupName: widget.groupName,GroupId: widget.groupId,
                                  )),
                            );
                          },
                          child: Container(
                            child: Text('Member Info',style: TextStyle(
                                color: Get.isDarkMode? Colors.white:Colors.black,fontSize: 22
                            ),),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,size: 20,),
                      ],
                    ),
                  ),
                  Divider(thickness: 2,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.person_add_outlined,size: 24,),
                        SizedBox(width: 20,),

                        InkWell(
                          onTap: (){
                            print( widget.groupName);
                            print(widget.groupId);
                            //print(groupMemberForExistingArray[1].name);
                            // Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForAddMember(
                                      memberListWithoutGroup: groupMemberForExistingArray,GroupName: widget.groupName,GroupId: widget.groupId,
                                    )));
                          },
                          child: Container(
                            child: Text('Add Members',style: TextStyle(
                                color: Get.isDarkMode? Colors.white:Colors.black,fontSize: 22
                            ),),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,size: 20,),
                      ],
                    ),
                  ),
                  Divider(thickness: 2,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app_outlined,size: 24,),
                        SizedBox(width: 20,),

                        InkWell(
                          onTap: (){

                            leaveFromGroup(widget.groupId!,widget.groupName!);

                          },
                          child: Container(
                            child: Text('Leave Group',style: TextStyle(
                                color: Get.isDarkMode? Colors.white:Colors.black,fontSize: 22
                            ),),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,size: 20,),
                      ],
                    ),
                  ),
                  Divider(thickness: 2,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(

                      children: [
                        Icon(Icons.image_outlined,size: 24,),
                        SizedBox(width: 20,),
                        InkWell(
                          onTap: (){
                            //rtvSharedGalleryForGrp();
                          },
                          child: Container(
                            child: Text('Shared Gallery',style: TextStyle(
                                color: Get.isDarkMode? Colors.white:Colors.black,fontSize: 22
                            ),),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down,size: 30,),
                      ],
                    ),
                  ),
                  //   Divider(thickness: 2,),
                  Container(
                      margin:
                      EdgeInsets.only(left: 17, right: 20, top: 8, bottom: 12),
                      child: GridView.builder(
                        // itemCount: messages.length,
                          itemCount: (grpSharedGalleryList.length > 6) ? 6 : grpSharedGalleryList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemBuilder: (ctx, index) {
                            return ImageItem('${WebApi.basesUrl}' +grpSharedGalleryList[index].message.toString().substring(2),index);
                          })),

                ],
              ),
            ),
          ),
          // ),
        ), onWillPop: () async{

      Get.back();
      return true;

    });
  }
  leaveFromGroup(String id,String name){
    showDialog(
        context: context,

        builder: (context) =>
            AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to leave from '+name+' ?'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      print("Leave No");
                      Navigator.pop(context);
                    }, //  We can return any object from here
                    child: Text('NO')),
                TextButton(
                    onPressed: () {
                      print("Leave Yes");
                      //  Navigator.of(context).pop(false);
                     // rc.recentChatLeaveGroup(id, widget.groupId);


                      //checkAdminOfGroup(id,name);
                      //     socketController.socket.emit('leaveFromGroup', id + "ID:" + ownUserId + "Name:" + user+"type:"+"user");

                    }, //  We can return any object from here
                    child: Text('YES'))
              ],
            ));

  }
  List<GroupMember> groupMemberForAdmin = [];


  Widget makeNewAdminContainer(String groupId) {
    return Container(
      height: 500.0, // Change as per your requirement
      width: 340.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: groupMemberForAdmin.length,
        itemBuilder: (BuildContext context, int index) {
          return  InkWell(
            onTap:(){
              socketController.socket.emit('leaveFromGroup', groupId + "ID:" + ownUserId + "Name:" + user+"type:"+"admin");
              socketController.socket.emit('changeAdminForGroup',groupId+'ID:'+ownUserId+'Name:'+groupMemberForAdmin[index].uniqueId!);
              Navigator.of(context).pop(false);
            },
            child: Container(
              // color: Color(0xff8ededfb),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(7.0, 10.0, 0.0, 5.0),
                //  padding: const EdgeInsets.only(bottom: 20,top:0.0),
                child: groupMemberForAdmin[index].uniqueId == LocalStorage.ADMINID?
                Container(): Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 55,
                      child: Stack(
                        children: <Widget>[

                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(18.0),
                                  bottomRight: Radius.circular(18.0),
                                  bottomLeft: Radius.circular(18.0),
                                  topLeft: Radius.circular(18.0),
                                ),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    image: AssetImage(groupMemberForAdmin[index].imageUrl!),
                                    fit: BoxFit.cover)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          child: Text(
                            groupMemberForAdmin[index].name!,
                            style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    /* groupMemberForAdmin[index].admin == LocalStorage.ADMINID
                        ?Container(
                        child: groupMemberForAdmin[index].uniqueId!=groupMemberForAdmin[index].admin?
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            child: Container(child: Icon(Icons.remove_circle)),
                            onTap: () {
                              *//*       removeFromGroup(groupMemberForAdmin[index].uniqueId,groupMemberForAdmin[index].name);
                            setState(() {
                              groupMemberForAdmin.removeAt(index);
                            });*//*
                            },
                          ),
                        ):Container()
                    )
                        : Container()*/
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _infoCard(String title, Color color, IconData icon, bool isEnabled,
      Function onPressed) {
    return InkWell(
      onTap: onPressed(),
      child: Container(
        margin: EdgeInsets.only(left: 0, right: 0, top: 12, bottom: 12),
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
                        (color == Colors.redAccent) ? color : Colors.black,
                        fontSize: 14),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable

class MemberDetails extends StatefulWidget {
  var GroupMemberList;
  var GroupName;
  var GroupId;
  MemberDetails({this.GroupMemberList,this.GroupName,this.GroupId});
  @override
  _MemberInfoPage createState() {
    return _MemberInfoPage();
  }
}
var groupMemberIdArray = [];

class _MemberInfoPage extends State<MemberDetails> {
  @override
  List<GroupMember>? allGroupMember;
  final SocketController socketController=Get.put(SocketController());
  void initState() {
    allGroupMember=widget.GroupMemberList;
    // TODO: implement initState
    super.initState();
  }


  removeFromGroup(memberId,memberName) async {
    print(LocalStorage.ADMINNAME);
    Map data = {
      'GroupId': widget.GroupId,
      'MemberId':memberId,
      'MemberName':memberName,
      'OwnName':LocalStorage.ADMINNAME,
      'UserId':LocalStorage.ADMINID



    };

    final response = await http.post(Uri.parse('${WebApi.basesUrl}/removeMemberFromGroup'),
        headers: {'connection': "keep-alive",'Authorization': 'Bearer ${LocalStorage.BearerTOKEN}'},
        // if needed
        body: data
    );
    var json = jsonEncode(response.body);
    print(json);
    socketController.socket.on('addMemeberToExistGroupSuccess'+LocalStorage.ADMINID,(data) {
      print("add member to existing group success:$data");
    },);

//addMemeberToExistGroupSuccess
    // socket.emit('removeMemberFromGroup', TestChat.selectedUserID + "ID:" + id + "Name:" + memberName + "OwnID:" + LocalStorage.user);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor:Get.isDarkMode?Colors.black: Color(0xfff4f4f9),
          appBar: AppBar(
            backgroundColor: Get.isDarkMode?Colors.black:Colors.white,
            foregroundColor: Get.isDarkMode?Colors.white:Colors.black,
            elevation: 0,
            leading: InkWell(
              child: Icon(
                Icons.arrow_back,
                size: 26,
              ),
              onTap: () {

                Navigator.pop(context);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (_) =>
                //             GroupInfoScreen(
                //               groupName:
                //               widget.GroupName,
                //               groupId: widget.GroupId,)
                //     )
                // );

              },
            ),
            title: Text(
              "Group Members",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

          ),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.symmetric(vertical: 15),
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "${allGroupMember!.length} Participants",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Get.isDarkMode?Colors.white54:Colors.black54),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: allGroupMember!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return    InkWell(
                        onLongPress: (){
                          print(allGroupMember![index].admin);
                          print(LocalStorage.ADMINID);
                        },
                        child: Container(
                          // color: Color(0xff8ededfb),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(7.0, 10.0, 0.0, 5.0),
                            //  padding: const EdgeInsets.only(bottom: 20,top:0.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 46,
                                  height: 46,
                                  child: Stack(
                                    children: <Widget>[
                                      /*Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(18.0),
                                              bottomRight: Radius.circular(18.0),
                                              bottomLeft: Radius.circular(18.0),
                                              topLeft: Radius.circular(18.0),
                                            ),
                                            shape: BoxShape.rectangle,
                                            border:
                                            Border.all(color: Colors.blueAccent, width: 3)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Container(
                                            width: 55,
                                            height: 55,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                image: DecorationImage(
                                                    image: NetworkImage(allGroupMember![index].imageUrl!),
                                                    fit: BoxFit.cover)),
                                          ),
                                        ),
                                      ),*/
                                      Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(18.0),
                                              bottomRight: Radius.circular(18.0),
                                              bottomLeft: Radius.circular(18.0),
                                              topLeft: Radius.circular(18.0),
                                            ),
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                                image: NetworkImage(allGroupMember![index].imageUrl!),
                                                fit: BoxFit.cover)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.50,
                                      child: Text(
                                        allGroupMember![index].name!,
                                        //  conversationList[index]['time'],
                                        style:
                                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    allGroupMember![index].admin == allGroupMember![index].uniqueId
                                        ?Container(
                                        child:
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Text('Admin',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14
                                              ),)
                                        )
                                    )
                                        : Container(
                                      child: Text('Member',
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13
                                        ),),
                                    )
                                  ],
                                ),
                                allGroupMember![index].admin == LocalStorage.ADMINID
                                    ?Container(
                                    child: allGroupMember![index].uniqueId!=allGroupMember![index].admin?
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        child: Container(
                                            child:
                                            Icon(Icons.remove_circle,color: Colors.red,)),
                                        onTap: () {
                                          removeFromGroup(allGroupMember![index].uniqueId,allGroupMember![index].name);
                                          if (mounted) {
                                            setState(() {
                                              allGroupMember!.removeAt(index);
                                            });
                                          }
                                        },
                                      ),
                                    ):Container(
                                        child:
                                        Text('Admin'))
                                )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                      );
                      /*    print(widget.groupMemberList.length);
                  print(widget.groupMemberList[0].name);
                  print(widget.groupMemberList[index].uniqueId);*/
                      /*  return ContactCard(
                    contact: widget.groupMemberList[index],
                  );*/
                    },
                  ),
                ),
              ],
            ),
          ),
        ), onWillPop: () async{
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  GroupInfoScreen(
                      groupName:
                      widget.GroupName)));
      return true;
    });
  }
}
class ForAddMember extends StatefulWidget {
  var memberListWithoutGroup;
  var GroupName;
  var GroupId;
  ForAddMember({this.memberListWithoutGroup,this.GroupName,this.GroupId});
  @override
  State<StatefulWidget> createState() {
    return _ForAddMember();
  }
}

class _ForAddMember extends State<ForAddMember> {

  List<GroupMember>? groupMemberForExistingArray;
  @override
  void initState() {
    groupMemberForExistingArray=widget.memberListWithoutGroup;
    // rtvFriendForExistingGrp(groupMemberIdArray);
    // TODO: implement initState
    super.initState();
  }
  AddMemberToExistGroup(memberName,id) async{

    Map data = {
      "GroupId":widget.GroupId,
      "MemberId":id,
      "MemberName":memberName,
      "OwnName":LocalStorage.ADMINNAME,
      "UserId":LocalStorage.ADMINID,


    };

    final response = await http.post(Uri.parse('${WebApi.basesUrl}/addMemberToExistGroup'),
        headers: {'connection': "keep-alive",'Authorization': 'Bearer ${LocalStorage.BearerTOKEN}'},
        // if needed
        body: data
    );
    var json = jsonEncode(response.body);
    print("add group member:$json");
    if(response.statusCode==200){
      return;
    }
    //  socket.emit('addToExistGroup', TestChat.selectedUserID + "ID:" + id + "Name:" + memberName + "OwnID:" + LocalStorage.user);
  }
  bool isAddButtonClick = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      backgroundColor:Get.isDarkMode?Colors.black: Color(0xfff4f4f9),
      appBar: AppBar(
        backgroundColor: Get.isDarkMode?Colors.black:Colors.white,
        foregroundColor: Get.isDarkMode?Colors.white:Colors.black,
        leading: InkWell(
          child: Icon(
            Icons.arrow_back,
            size: 26,
          ),
          onTap: () {
            Navigator.pop(context);
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (_) =>
            //             GroupInfoScreen(
            //               groupName:
            //               widget.GroupName,groupId: widget.GroupId,)));

          },
        ),
        title: Text(
          "Add Members",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        //   actions: [
        //     TextButton(
        //       onPressed: (){
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(builder: (context) => ChatScreen(groupMemberList: widget.groupMemberList,)),
        //         );
        //       },
        //       child: Icon(Icons.more_vert_outlined),
        //     )
        //   ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "${groupMemberForExistingArray!.length} Participants",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: groupMemberForExistingArray!.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: Container(
                      // color: Color(0xff8ededfb),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(7.0, 10.0, 0.0, 5.0),
                        //  padding: const EdgeInsets.only(bottom: 20,top:0.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 55,
                              height: 55,
                              child: Stack(
                                children: <Widget>[

                                  Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(18.0),
                                          bottomRight: Radius.circular(18.0),
                                          bottomLeft: Radius.circular(18.0),
                                          topLeft: Radius.circular(18.0),
                                        ),
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                            image: NetworkImage(groupMemberForExistingArray![index].imageUrl!),
                                            fit: BoxFit.cover)),
                                  ),
                                  Positioned(
                                    top: 35,
                                    left: 35,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0),
                                            topLeft: Radius.circular(10.0),
                                          ),
                                          color: Color(0xFF66BB6A),
                                          shape: BoxShape.rectangle,
                                          border:
                                          Border.all(color: Color(0xFFFFFFFF), width: 3)),
                                    ),
                                  ),
                                  Container()
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.50,
                                  child: Text(
                                    groupMemberForExistingArray![index].name!,
                                    //  conversationList[index]['time'],
                                    style:
                                    TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                child: Container(
                                    child: isAddButtonClick
                                        ? Icon(Icons.person_add_alt_1_outlined)
                                        : Icon(Icons.remove_circle)),
                                onTap: () {
                                  print('add button clicked');
                                  AddMemberToExistGroup(groupMemberForExistingArray![index].name,groupMemberForExistingArray![index].uniqueId);

                                  if (mounted) {
                                    setState(() {
                                      groupMemberForExistingArray!.removeAt(index);
                                    });
                                  }

                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ), onWillPop: () async{
      Navigator.pop(context);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) =>
      //             GroupInfoScreen(
      //                 groupName:
      //                 widget.GroupName)));
      return true;
    });
  }
}

class AddMemberCard extends StatefulWidget {
  AddMemberCard({Key? key, this.contact}) : super(key: key);
  final GroupMember? contact;

  @override
  _AddMemberCard createState() => _AddMemberCard();
}

class _AddMemberCard extends State<AddMemberCard> {
//  static IO.Socket socket = SocketController.socket;

  bool isAddButtonClick = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: InkWell(
      child: Container(
        // color: Color(0xff8ededfb),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(7.0, 10.0, 0.0, 5.0),
          //  padding: const EdgeInsets.only(bottom: 20,top:0.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 55,
                height: 55,
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(18.0),
                            bottomRight: Radius.circular(18.0),
                            bottomLeft: Radius.circular(18.0),
                            topLeft: Radius.circular(18.0),
                          ),
                          shape: BoxShape.rectangle,
                          border:
                          Border.all(color: Colors.blueAccent, width: 3)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  image: AssetImage(widget.contact!.imageUrl!),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(18.0),
                            bottomRight: Radius.circular(18.0),
                            bottomLeft: Radius.circular(18.0),
                            topLeft: Radius.circular(18.0),
                          ),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: AssetImage(widget.contact!.imageUrl!),
                              fit: BoxFit.cover)),
                    ),
                    Positioned(
                      top: 35,
                      left: 35,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                            ),
                            color: Color(0xFF66BB6A),
                            shape: BoxShape.rectangle,
                            border:
                            Border.all(color: Color(0xFFFFFFFF), width: 3)),
                      ),
                    ),
                    Container()
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Text(
                      widget.contact!.name!,
                      //  conversationList[index]['time'],
                      style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: Container(
                      child: isAddButtonClick
                          ? Icon(Icons.person_add_alt_1_outlined)
                          : Icon(Icons.remove_circle)),
                  onTap: () {
                    if (isAddButtonClick) {
                      print('add button clicked');
                    }
                    if (mounted) {
                      setState(() {
                        isAddButtonClick = !isAddButtonClick;
                      });
                    }

                  },
                ),
              )
            ],
          ),
        ),
      ),
    ), onWillPop: () async{
      Navigator.pop(context);
      return true;
    });
  }
}
class ImageItem extends StatelessWidget {
  final String? image;
  final int? index;
  BuildContext? context;

  ImageItem(this.image, this.index);

  Widget imageDialog(BuildContext context) {
    return Dialog(
      child: Container(
        height: 400,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image:
                DecorationImage(image: NetworkImage(image!), fit: BoxFit.fill),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.clear),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return (index == 5)
        ? InkWell(
        onTap: () {
          print('gallery clicked');
          // Navigator.push(
          //   context,
          //   // MaterialPageRoute(builder: (context)=>MyBottomBarDemo()),
          //   MaterialPageRoute(builder: (context)=>GalleryDemo(groupImage: grpPreviewsharedGalleryList,)),
          //   // MaterialPageRoute(builder: (context)=>FancyFab()),
          //
          // );
        },
        child: Container(
          child: Center(
              child: Text("See more",style: TextStyle(color: Colors.white,fontSize: 20),)
          ),
          margin: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.grey,
            image: DecorationImage(
                image: NetworkImage(image!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.grey.withOpacity(0.15), BlendMode.dstATop)),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
                bottomLeft: Radius.circular(7),
                bottomRight: Radius.circular(7)),
            border: Border.all(color: Colors.grey, width: 0.4),
          ),
        )
    )
        : InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            // Future.delayed(Duration(seconds: 1)).then((_) {}
            // Navigator.pop(context);
            return imageDialog(context);
          },
        );
      },
      child: Container(
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
                bottomLeft: Radius.circular(7),
                bottomRight: Radius.circular(7)),
            border: Border.all(color: Colors.grey, width: 0.4),
            image: DecorationImage(
              image:NetworkImage(image!),
              fit: BoxFit.cover,
            )),
      ),
    );
  }
  bool imagePlaceholder=false;
}


class GroupDetails extends StatefulWidget {
  final groupName;
  final groupImage;
  final groupAdmin;
  final groupId;
  const GroupDetails({Key? key,this.groupName,this.groupAdmin,this.groupImage,this.groupId}) : super(key: key);

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  //ConversationController cc=Get.put(ConversationController());
  var   groupProfile;
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
                  var    pageName='GroupProfile';
                  Navigator.pop(context);
                //  Navigator.push(context, MaterialPageRoute(builder: (_)=>CameraScreen(whichPage: pageName,)));

                  Navigator.pop(context);
                  //  _openCamera(context);
                  // profilePicChange(ImageSource.camera,context: context);
                  //       Navigator.pop(context);
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color: Colors.blue,),
              ),
              Divider(height: 1,color: Colors.blue,),


            ],
          ),
        ),);
    });
  }
  XFile? pickedFile=null;
  final ImagePicker _picker = ImagePicker();

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
    var request = new http.MultipartRequest("POST",Uri.parse('${WebApi.basesUrl}/editGroupProfilePicture') );
    // add file to multipart
    request.files.add(multipartFile);
    request.headers.addAll(header);
    request.fields["GroupId"] =widget.groupId;
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
        groupProfile = '${WebApi.basesUrl}'+ dataValue;
        // LocalStorage.groupProfileImage=groupProfile;
        print(groupProfile); // T


      });

    }).catchError((e) {
      print(e);
    });

    setState(() {

    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Get.isDarkMode?Colors.black: Color(0xfff4f4f9),
      appBar: AppBar(
        backgroundColor: Get.isDarkMode?Colors.black:Colors.white,
        foregroundColor: Get.isDarkMode?Colors.white:Colors.black,

        title: Text('Group Details'),
      ),
      body: Column(
        children: [
          Container(
            height: 20,
          ),
          Container(
            // height: 70.0,
            margin: EdgeInsets.only(bottom: 1.0),
            padding: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0.0),
              color: Get.isDarkMode? Colors.black:Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0),
                  blurRadius: 1.0,
                ),
              ],
            ),
            child: Stack(
              children: [

                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [

                      Column(
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50)),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(widget.groupImage),
                              ),
                            ),child: Container(

                            alignment: Alignment.bottomRight,
                            height: 40,
                            width: 40,
                            child:Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                              ),

                              child:  IconButton(
                                onPressed: (){
                                  showChoiceDialog(context);
                                  //profilePicChange();
                                },
                                icon: Icon(Icons.camera_alt_outlined,color: Colors.white,size: 20,),
                              ),
                            ),

                          ),

                          ),

                        ],
                      ),





                      Container(
                        margin: EdgeInsets.only(top: 8,bottom: 10),
                        child: InkWell(
                          onTap: (){

                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 300,
                                alignment: Alignment.center,
                                child: Text(
                                  widget.groupName,
                                  style: TextStyle(
                                      color:Get.isDarkMode? Colors.white:Colors.black,
                                      fontSize: 22,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),



              ],
            ),
          ),
          // CircleAvatar(
          //   radius: 100,
          //   child: Image.network(widget.groupImage),
          // ),
          //  IconButton(onPressed: (){}, icon: Icon(Icons.image)),
          /* Container(

            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text("Group Name",style: TextStyle(
                //     fontSize: 22
                // ),),
                // Text(":",style: TextStyle(
                //     fontSize: 22
                // ),),
                Container(
                  width: 200,
                  alignment: Alignment.center,
                  child: Text(widget.groupName,style: TextStyle(
                      fontSize: 22,

                  ),),
                ),
              ],
            ),
          ),*/
          Container(

            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Admin Name",style: TextStyle(
                    fontSize: 22
                ),),
                Text(":",style: TextStyle(
                    fontSize: 22
                ),),
                Container(
                  width: MediaQuery.of(context).size.width*0.40,
                  child: Text(widget.groupAdmin,style: TextStyle(
                      fontSize: 22,
                      overflow: TextOverflow.ellipsis
                  ),),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
