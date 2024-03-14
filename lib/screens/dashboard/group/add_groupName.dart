import 'dart:convert';
import 'package:dash_board/constants.dart';
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/Users.dart';
import 'package:dash_board/screens/dashboard/group/group_controllers/group_controller.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/socket.dart';
import 'package:dash_board/utils/urls.dart';
import 'package:dash_board/widgets/popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
class AddName extends StatefulWidget{
  final List<User> groupMemberList;
  AddName({required this.groupMemberList});

  @override
  State<StatefulWidget> createState() {
    return _AddName();
  }
}
class _AddName extends State<AddName> {
  TextEditingController groupNameController = new TextEditingController();
  GroupController gc=Get.put(GroupController());
  ApiController apiController=Get.put(ApiController());
  final SocketController socketController=Get.put(SocketController());
  bool _switchValue = true;

  @override
  void initState() {
    /// socket.connect();
    print("socket id:${socketController.socket.id}");
    socketController.socket.on('memberAlertForGrpAdd'+LocalStorage.ADMINID,(data){
      print(data);
      gc.rtvGroupLists();
    });
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:
    Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,

        title:       Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                //  padding: EdgeInsets.only(top: 25, left: 10),
                child: InkWell(
                  onTap: () {
                    print("socket id:${socketController.socket.id}");
                    widget.groupMemberList.forEach((obj) {
                      if (mounted) {
                        setState(() {
                          obj.isSelected = false;
                        });
                      }
                    });
                    Navigator.pop(context, true);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_outlined,
                    size: 22,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 50,),

              Container(
                //  padding: EdgeInsets.only(top: 25, left: 10),
                child: InkWell(
                  child: Text(
                    "New Group",
                    style: TextStyle(
                        fontSize: 16,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3

                    ),
                  ),
                ),
              ),



            ],
          ),
        ),
        actions: [
          Container(
            // padding: EdgeInsets.only(top: 10, left: 10),
            child: TextButton(
                onPressed: () async{

                  if(groupNameController.text==''||groupNameController.text==null){
                //    showAlertErrorDialog("Warning!", "Group Name required");
                  }else{

                    var createGroupArray = [];

                    for (var i = 0; i <
                        widget.groupMemberList.length; i++) {
                      createGroupArray.add(widget.groupMemberList[i].uniqueId);
                    }
                    var items = jsonEncode(createGroupArray);

                    Map data = {
                      'UserList':items,
                      'GroupName':groupNameController.text,
                      'Creator': LocalStorage.ADMINID,
                      'SystemType':'Mobile',
                     // 'Privacy':_switchValue==true?"Public":"Private"
                    };

                    final response = await http.post(Uri.parse('${WebApi.basesUrl}/createGroupByAdmin', ),
                        headers: {'connection': "keep-alive",},
                        body: data
                    );

                    if(response.statusCode==200){

                     // gc.rtvGroupLists();
                      setState(() {
                        apiController.fetchGroups({"AdminId":LocalStorage.ADMINID});

                      });

                      Get.back();
                    }else{
                      print('group can be created');
                  //    showAlertErrorDialog("Warning!", "Members and Name required");
                    }
                  }

                  return;

                },
                child: Text(
                  "CREATE",
                  style: TextStyle(
                    fontSize: 16,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,

                  ),
                )
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Column(
            children: [
            /*  Row(
                children: [
                  SizedBox(height: 80,),
                  Container(
                    child: Text('Privacy:',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          letterSpacing: 2
                      ),),
                  ),
                  SizedBox(width: 20,),
                  CupertinoSwitch(
                    value: _switchValue,
                    onChanged: (value) {
                      setState(() {
                        _switchValue = value;
                      });
                    },
                  ),
                  _switchValue? Text("Public",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),):Text("Private",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),),
                ],
              ),*/
              Container(
                height: 50,
                alignment: Alignment.center,
                child: TextField(
                  controller: groupNameController,
                  cursorWidth: 1,
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),

                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Group Name (Required)",
                      border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal),
                        borderRadius: BorderRadius.circular(20),

                      ),
                      hintStyle: TextStyle(
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      )
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.symmetric(vertical: 15),
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "${widget.groupMemberList.length} Participants",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.groupMemberList.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return ContactCard(contact: widget.groupMemberList[index],);
                },
              ),
            ],
          ),
        ),
      ),
      // ),
    ), onWillPop: () async{
      widget.groupMemberList.forEach((obj) {
        setState(() {
          obj.isSelected = false;
        });
      });
      Navigator.pop(context, true);
      return true;
    });
  }
/*void createGroupButton(List createGroupArray) {

  }*/
}
class ContactCard extends StatelessWidget {
  const ContactCard({Key? key, this.contact}) : super(key: key);
  final User? contact;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 53,
        height: 53,
        child: Stack(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: NetworkImage(contact!.userImageUrl!),
                      fit: BoxFit.cover)),
            ),
          ],
        ),
      ),
      title: Text(
        contact!.userName!,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color:Get.isDarkMode? Colors.white:Colors.black,
        ),
      ),
      /*    subtitle: Text(
        contact.lastMsg,
        style: TextStyle(
          fontSize: 13,
        ),
      ),*/
    );
  }
}