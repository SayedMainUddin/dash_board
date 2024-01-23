
import 'package:dash_board/constants.dart';
import 'package:dash_board/models/Users.dart';
import 'package:dash_board/screens/dashboard/group/group_controllers/group_controller.dart';
import 'package:dash_board/screens/dashboard/group/group_controllers/select_members_controller.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
class AddMember extends StatelessWidget {
  AddMemberController amc=Get.put(AddMemberController());
GroupController gc=Get.put(GroupController(),permanent: true);


  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AddMemberController());
    //Get.lazyPut(() => GroupController());
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<AddMemberController>(builder: (controller) {
      return WillPopScope(
          child: Scaffold(
              backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
              appBar: AppBar(
                foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,

                leading: Container(
                  padding: EdgeInsets.only(left: 15),
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      amc.allGroupMembers.forEach((obj) {
                        obj.isSelected = false;
                      });
                      Get.back();
                      // Navigator.pop(context, true);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_outlined,
                      size: 22,
                      color: Color(color
                          .elementAt(0)
                          .values
                          .first),
                    ),
                  ),
                ),

                title: Text("Select Members", style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),),
                centerTitle: true,
                automaticallyImplyLeading: false,
                backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,


              ),
              floatingActionButton: FloatingActionButton(
                  backgroundColor: Color(0xFF128C7E),
                  onPressed: () {
                    print("${LocalStorage.ADMINID}");
                    var groupId;
                    groupId = LocalStorage.ADMINID;

                    if (LocalStorage.ADMINID != null) {
                      final User ownUserInfoForGrpCreate = User(
                          id: amc.groupmember.length - 1,
                          uniqueId: groupId,
                          userName: LocalStorage.ADMINNAME,
                          userImageUrl: LocalStorage.ADMINIMAGE,
                          lastMsg: "This is test",
                          StoryList: []

                      );
                      print("own user id:${LocalStorage.ADMINID}");
                      print("id: ${amc.groupmember.length - 1}");
                      print("group id as uniqueId: ${groupId}");
                      //  // groupmember.add(ownUserInfoForGrpCreate);
                      if (amc.groupmember.isEmpty ||
                          amc.groupmember.length == 1) {
                     //   showAlertErrorDialog("Ops!","At leat 2 members needed for creating a group");
                      } else {
                        amc.groupmember.insert(0, ownUserInfoForGrpCreate);
                        var ff = <User>[];
                        ff.addAll(amc.groupmember);
                        amc.groupmember.clear();
                        amc.allGroupMembers.forEach((obj) {
                          obj.isSelected = false;
                        });
                        //Navigator.pop(context);
                        gc.selectedMemberList.value=ff;
                        gc.isMemberAdded.value=true;
                      //  AddName(groupMemberList: ff,)
                        print(
                            "Own user for group create:${ownUserInfoForGrpCreate}");
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (_) =>
                        //       AddName(
                        //         groupMemberList: ff,)),
                        // );
                      }
                    } else {
                      return;
                    }
                  },
                  child: Icon(Icons.arrow_forward)),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10.0, 10.0, 0.0),
                        width: screenWidth * 0.90,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.05,
                        // color: Color(0xffffffff),
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(15)),
                        child: TextField(
                          cursorColor: Color(0xFF000000),
                          controller: amc.searchControllerInAddFirend.value,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color:  Colors.black
                              ),
                              hintText: "Search by name",
                              hintStyle: TextStyle(
                                color: Colors.black45

                              ),
                              border: InputBorder.none),
                          style: TextStyle(
                            color: Colors.black
                          ),
                          onChanged: (value) => amc.searchInFriends(value),
                        ),
                      ),
                      amc.groupmember.length > 0
                          ? Column(
                        children: [
                          Container(
                            height: 100,
                            color:Get.isDarkMode ? Colors.black : Colors.white,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: amc.allGroupMembers.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  if (amc.allGroupMembers[index].isSelected ==
                                      true)
                                    return InkWell(
                                      onTap: () {

                                        amc.removeGroupMember(index);

                                      },
                                      child: AvatarCard(
                                        chatModel: amc.allGroupMembers[index],
                                      ),
                                    );
                                  return Container();
                                }),
                          ),
                          Divider(
                            thickness: 1,
                          ),
                        ],
                      )
                          : Container(),
                      Container(
                        height: amc.groupmember.length > 0
                            ? screenHeight * 0.60
                            : screenHeight * 0.80,
                        child: ListView.builder(
                            itemCount: amc.allGroupMembers.length + 1,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Container(
                                  height: amc.groupmember.length > 0 ? 10 : 10,
                                );
                              }
                              return InkWell(
                                onTap: () {
                                  amc.addGroupMember(index);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ContactCard(
                                    contact: amc.allGroupMembers[index - 1],
                                  ),
                                ),
                              );
                            }),
                      ),

                    ],
                  ),
                ),
              )), onWillPop: () async {
        // Navigator.pop(context, true);
        Get.back();
        return true;
      });
    });
  }
}

class AvatarCard extends StatelessWidget {
  const AvatarCard({Key? key, this.chatModel}) : super(key: key);
  final User? chatModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
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
                        image: NetworkImage(chatModel!.userImageUrl!),
                        fit: BoxFit.cover)),
              ),
              /*  CircleAvatar(
                radius: 23,
                backgroundImage: AssetImage("assets/images/profile.jpg"),
                backgroundColor: Colors.blueGrey[200],
              ),*/
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 11,
                  child: Icon(
                    Icons.clear,
                    color: Colors.black,
                    size: 13,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            chatModel!.userName!,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonCard extends StatelessWidget {
  const ButtonCard({Key? key, this.name, this.icon}) : super(key: key);
  final String? name;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 23,
        child: Icon(
          icon,
          size: 26,
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF25D366),
      ),
      title: Text(
        name!,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black
        ),
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  const ContactCard({Key? key, this.contact}) : super(key: key);
  final User? contact;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 53,
        child: Stack(
          children: [
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
                      image: NetworkImage(contact!.userImageUrl!),
                      fit: BoxFit.cover)),
            ),
            contact!.isSelected
                ? Positioned(
              bottom: 4,
              right: 5,
              child: CircleAvatar(
                backgroundColor: Colors.teal,
                radius: 11,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            )
                : Container(),
          ],
        ),
      ),
      title: Text(
        contact!.userName!,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black
        ),
      ),
    );
  }
}
