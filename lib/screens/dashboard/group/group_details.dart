import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/Groups.dart';
import 'package:dash_board/models/Users.dart';
import 'package:dash_board/screens/dashboard/group/group_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupDetailModal extends StatefulWidget {
  final Group? group;

  GroupDetailModal({this.group});

  @override
  _GroupDetailModalState createState() => _GroupDetailModalState();
}

class _GroupDetailModalState extends State<GroupDetailModal> {
  final ApiController apiController=Get.put(ApiController());
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
   var screenHeight=MediaQuery.of(context).size.height;
   var screenWidth=MediaQuery.of(context).size.width;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,

     // backgroundColor: Colors.black,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width*0.50,
          decoration: BoxDecoration(
          //  color: Colors.cyan,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              SizedBox(height: 16.0),
              Container(
                height: screenHeight*0.50,
                child: GroupInfoScreen(
                  groupId: widget.group!.id,
                  groupName: widget.group!.groupName,
                  group: widget.group,
                ),
              ),

              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showgroupDetailModal(BuildContext context, {Group? group}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return GroupDetailModal(group: group);
    },
  );
}
