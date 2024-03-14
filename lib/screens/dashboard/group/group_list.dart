
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/Groups.dart';
import 'package:dash_board/models/RecentFile.dart';
import 'package:dash_board/models/Users.dart';
import 'package:dash_board/responsive.dart';
import 'package:dash_board/screens/dashboard/group/delete_group.dart';
import 'package:dash_board/screens/dashboard/group/group_chat_modal.dart';
import 'package:dash_board/screens/dashboard/group/group_details.dart';
import 'package:dash_board/screens/dashboard/group/sent_to_all.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/urls.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../constants.dart';
import 'create_group.dart';




class GroupListPage extends StatefulWidget {
  //  ApiController apiController;
  //
  GroupListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<GroupListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<GroupListPage> {
  ApiController apiController=Get.put(ApiController());

  List selectedGroups = [];

  // Function to update the state after deleting a group
  void updateGroupsAfterDelete(String groupId) {
    setState(() {
      // Remove the deleted group from the list
      selectedGroups.removeWhere((group) => group.id == groupId);
    });
setState(() {

});
  }


  void initState() {
    super.initState();
    _fetchGroupData();
  }

  Future<void> _fetchGroupData() async {

    await apiController.fetchGroups({"AdminId":LocalStorage.ADMINID}); // Adjust 'users' according to your API endpoint

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
       // color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Group List",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(onPressed: (){
                    _fetchGroupData();
                  }, icon: Icon(Icons.refresh))
                ],
              ),
              Container(
                width: Get.width*0.20,
                height: Get.height*0.05,
                child: SearchBar(
                  hintText: "Search",
                  leading: Icon(Icons.search),
                  //onChanged: apiController.setSearchQuery,
                  onChanged: (String? value){
                    apiController.getFilteredGroups(value);
                  },
                ),
              ),
              selectedGroups.length>0? Padding(
                padding: const EdgeInsets.symmetric(horizontal: actionButtonPadding),
                child:Row(
                  children: [
                    Text(
                      "Send to selected Groups",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      onPressed: (){
                        showSendToAllGroupChatModal(context,selectedGroups);
                        print(selectedGroups);
                      },
                      icon: Icon(Icons.message_outlined,color: Colors.teal,),
                    ),
                  ],
                ),
              ):
              ElevatedButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding * 1.5,
                    vertical:
                    defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                  ),
                ),
                onPressed: () {
                  showCreateUserModal(context);
                },
                icon: Icon(Icons.add),
                label: Text("create Group"),
              ),

            ],
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              // minWidth: 600,
              columns: [
                /*  DataColumn(
                  label: SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: selectedGroups.length == userList.length,
                      onChanged: (selected) {
                        // Handle "Select All" checkbox change here
                        setState(() {
                          selectedGroups.forEach((user) {
                            user.isSelected = selected ?? false;
                          });
                        });
                      },
                    ),
                  ),
                ),*/

                DataColumn(
                  label: Text("Group"),
                ),
                // !Responsive.isMobile(context)?  DataColumn(
                //   label: Text("Privacy"),
                // ):DataColumn(
                //   label: Text(""),
                // ),
                !Responsive.isMobile(context)?    DataColumn(
                  label: Text("Members"),
                ):DataColumn(
                  label: Text(""),
                ),
                !Responsive.isMobile(context)?    DataColumn(
                  label: Text("Date"),
                ):DataColumn(
                  label: Text(""),
                ),
                DataColumn(
                  label: Text("Action"),
                ),
              ],
              rows: List.generate(
                apiController.groupList.length,
                    (index) => recentGroupDataRow(context,apiController.groupList[index]),
              ),
            ),
          ),

        ],
      ),
    );
  }


  DataRow recentGroupDataRow(BuildContext context, Group groupInfo) {
    ApiController apiController = ApiController();
    return DataRow(
      selected: groupInfo.isSelected,

      onSelectChanged: (selected) {
        setState(() {
          groupInfo.isSelected = selected ?? false;
          if (groupInfo.isSelected) {
            selectedGroups.add(groupInfo.id);

          } else {
            selectedGroups.remove(groupInfo.id);
          }

          print(selectedGroups.length);
       //   selectedGroups.map((e) =>  print(e['_id']));

        });

      },
      cells: [

        DataCell(
          GestureDetector(
            onTap: () {
              setState(() {
                groupInfo.isSelected = !groupInfo.isSelected!;
              });
            },
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color:Colors.green
                      ),

                      image: DecorationImage(image: NetworkImage(groupInfo.groupPic))
                  ),
                ),
                // CircleAvatar(
                //
                //   child: Image.network(groupInfo.groupPic),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Container(
                    width: Get.width*0.10,
                      child: Text(groupInfo.groupName,overflow: TextOverflow.ellipsis,)
                  ),
                ),

              ],
            ),
          ),
        ),
        !Responsive.isMobile(context)
            ? DataCell(Text(groupInfo.membersID.length.toString()))
            : DataCell(Text("")),
        !Responsive.isMobile(context)
            ? DataCell(Text(groupInfo.dateTime.toString()))
            : DataCell(Text("")),


        DataCell(
          Row(
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: actionButtonPadding),
                child:           IconButton(onPressed: (){
                  showgroupDetailModal(context,group: groupInfo);
                },icon: Icon(Icons.edit_document,color: Colors.green,),),
              ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: actionButtonPadding),
              //   child:           IconButton(onPressed: (){
              //     showUnMuteUserModal(context, () {
              //       apiController.muteUser(context,{"UserId":groupInfo.id,"AdminId":"6545cc78434c8b5bd35c9133","UserStatus":"InActive"});
              //       print('User account deleted!');
              //
              //     });
              //
              //   },icon: Icon(Icons.airplanemode_active,color: Colors.yellow,),),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: actionButtonPadding),
                child:           IconButton(onPressed: (){
                  showDeleteGroupModal(context,  (){
                    updateGroupsAfterDelete(groupInfo.id);
                  }, () {
                    apiController.deleteGroup(context,{"GroupId":groupInfo.id,"AdminId":LocalStorage.ADMINID});
                    print('User account deleted!');


                  });
                  // showUserDetailModal(context,user: groupInfo);
                },icon: Icon(Icons.delete_outline,color: Colors.red,),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: actionButtonPadding),
                child:IconButton(onPressed: (){
                  showGroupChatModal(context, groupInfo.groupName,groupInfo.id,"Group");

                },icon: Icon(Icons.messenger_outline,color: Colors.teal,),),
              ),
            ],
          ),
        ),
      ],
    );
  }
}



