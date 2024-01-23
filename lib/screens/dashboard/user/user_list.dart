
import 'package:dash_board/controllers/MenuAppController.dart';
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/RecentFile.dart';
import 'package:dash_board/models/Users.dart';
import 'package:dash_board/responsive.dart';
import 'package:dash_board/screens/dashboard/user/chat_modal.dart';
import 'package:dash_board/screens/dashboard/user/create_user.dart';
import 'package:dash_board/screens/dashboard/user/delete.dart';
import 'package:dash_board/screens/dashboard/user/mute_unmute_user.dart';
import 'package:dash_board/screens/dashboard/user/send_to_all.dart';
import 'package:dash_board/screens/dashboard/user/user_details.dart';
import 'package:dash_board/utils/local_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../constants.dart';


List selectedUsers = [];


class UserListPage extends StatefulWidget {
  //  ApiController apiController;
  //
  UserListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final ApiController apiController = Get.find<ApiController>();


  Future<void> _fetchGroupData() async {

    await apiController.fetchGroups({"AdminId":LocalStorage.ADMINID}); // Adjust 'users' according to your API endpoint

    setState(() {

    });
  }

  void initState() {
    super.initState();
    _fetchUserData();
    _fetchGroupData();

  }

  Future<void> _fetchUserData() async {

    await apiController.fetchUsers({"AdminId": LocalStorage.ADMINID});
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
     //   color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child:GetBuilder<ApiController>(builder: (controller){
       // final filteredUsers = apiController.getFilteredUsers();

        return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Users List",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(onPressed: (){
                    _fetchUserData();
                  }, icon: Icon(Icons.refresh))
                ],
              ),
              Container(
                width: 200,
                height: 30,
                child: SearchBar(
                 hintText: "Search by name",
                  leading: Icon(Icons.search),
                  //onChanged: apiController.setSearchQuery,
                  onChanged: (String? value){
                   apiController.getFilteredUsers(value);
                  },
                ),
              ),

              selectedUsers.length>0? Padding(
                padding: const EdgeInsets.symmetric(horizontal: actionButtonPadding),
                child:Row(
                  children: [
                    Text(
                      "Send to selected",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      onPressed: (){
                        showSendToAllChatModal(context,selectedUsers);
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
                label: Text("create User"),
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
                      value: selectedUsers.length == userList.length,
                      onChanged: (selected) {
                        // Handle "Select All" checkbox change here
                        setState(() {
                          selectedUsers.forEach((user) {
                            user.isSelected = selected ?? false;
                          });
                        });
                      },
                    ),
                  ),
                ),*/

                DataColumn(
                  label: Text("User"),
                ),
                !Responsive.isMobile(context)?  DataColumn(
                  label: Text("Email"),
                ):DataColumn(
                  label: Text(""),
                ),
                !Responsive.isMobile(context)?    DataColumn(
                  label: Text("Address"),
                ):DataColumn(
                  label: Text(""),
                ),
                DataColumn(
                  label: Text("Action"),
                ),
              ],

              rows:  List.generate(
                controller.userList.length,
                    (index) => recentFileDataRow(context,controller.userList[index]),
              ),
            ),
          ),

        ],
      );}),
    );
  }


  DataRow recentFileDataRow(BuildContext context, User userInfo) {
    ApiController apiController =Get.put(ApiController());
    return DataRow(
      selected: userInfo.isSelected,

      onSelectChanged: (selected) {
        setState(() {
          userInfo.isSelected = selected ?? false;
          if (userInfo.isSelected) {
            selectedUsers.add(userInfo.userId);

          } else {
            selectedUsers.remove(userInfo.userId);
          }

          print(selectedUsers.length);

        });

      },
      cells: [

        DataCell(
          GestureDetector(
            onTap: () {
              setState(() {
                userInfo.isSelected = !userInfo.isSelected;
              });
            },
            child: Row(
              children: [
                // CircleAvatar(
                //   child: Image.asset(userInfo.userImageUrl!),
                // ),
                CircleAvatar(
                  child: Image.network(userInfo.userImageUrl!),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Text(userInfo.userName!,overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ),
        !Responsive.isMobile(context)
            ? DataCell(Text(userInfo.email!))
            : DataCell(Text("")),
        !Responsive.isMobile(context)
            ? DataCell(Text(userInfo.address!))
            : DataCell(Text("")),

        DataCell(
          Row(
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: actionButtonPadding),
                child:           IconButton(onPressed: (){
                  showUserDetailModal(context,user: userInfo);
                },icon: Icon(Icons.edit_document,color: Colors.green,),),
              ),
              userInfo.status=="Active"?Padding(
                padding: const EdgeInsets.symmetric(horizontal: actionButtonPadding),
                child:           IconButton(onPressed: (){
                  showMuteUserModal(context, () {
                    apiController.muteUser(context,{"UserId":userInfo.userId,"AdminId":"6545cc78434c8b5bd35c9133","UserStatus":"Active"});
                    print('User account deleted!');

                  });

                },icon: Icon(Icons.stop_circle_outlined,color: Colors.yellow,),),
              ):
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: actionButtonPadding),
                child:           IconButton(onPressed: (){
                  showUnMuteUserModal(context, () {
                    apiController.muteUser(context,{"UserId":userInfo.userId,"AdminId":"6545cc78434c8b5bd35c9133","UserStatus":"InActive"});
                    print('User account deleted!');

                  });

                },icon: Icon(Icons.airplanemode_active,color: Colors.yellow,),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: actionButtonPadding),
                child: IconButton(
                  onPressed: (){
                  showDeleteUserModal(context, () {
                    apiController.deleteUser(context,{"UserId":userInfo.userId,"AdminId":"6545cc78434c8b5bd35c9133"});
                    setState(() {

                    });
                  });
                  // showUserDetailModal(context,user: userInfo);
                },icon: Icon(Icons.delete_outline,color: Colors.red,),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: actionButtonPadding),
                child:IconButton(onPressed: (){
                  showChatModal(context, userInfo.userName!,userInfo.userId!,"user");
                },icon: Icon(Icons.messenger_outline,color: Colors.teal,),),
              ),
            ],
          ),
        ),
      ],
    );
  }
}



