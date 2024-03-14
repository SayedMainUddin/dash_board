
import 'package:dash_board/controllers/MenuAppController.dart';
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/Groups.dart';
import 'package:dash_board/models/RecentFile.dart';
import 'package:dash_board/models/Users.dart';
import 'package:dash_board/responsive.dart';
import 'package:dash_board/screens/dashboard/user/chat_modal.dart';
import 'package:dash_board/screens/dashboard/user/create_user.dart';
import 'package:dash_board/screens/dashboard/user/delete.dart';
import 'package:dash_board/screens/dashboard/user/edit_user.dart';
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
  List<String> sortingOptions = [
    'Sorting',
    'Department',
    'Time',
    'DOB',
    'Name',
    'Email',
    'Mobile',
  ];

  String selectedSortingOption = 'Sorting';
  bool isAscending = true;

  Future<void> _fetchUserData() async {

    await apiController.fetchUsers({"AdminId": LocalStorage.ADMINID});
    setState(() {

    });
  }
  void _sortUserList() {
    apiController.userList.sort((a, b) {
      switch (selectedSortingOption) {
        case 'Department':
          return isAscending
              ? a.userDepartment!.compareTo(b.userDepartment!)
              : b.userDepartment!.compareTo(a.userDepartment!);
        case 'Time':
          return isAscending
              ? a.time!.compareTo(b.time!)
              : b.time!.compareTo(a.time!);
          break;
        case 'DOB':
          return isAscending
              ? a.dob!.compareTo(b.dob!)
              : b.dob!.compareTo(a.dob!);
          break;
        case 'Name':
          return isAscending
              ? a.userName!.compareTo(b.userName!)
              : b.userName!.compareTo(a.userName!);
          break;
        case 'Email':
          return isAscending
              ? a.email!.compareTo(b.email!)
              : b.email!.compareTo(a.email!);
        case 'Mobile':
          return isAscending
              ? a.mobile!.compareTo(b.mobile!)
              : b.mobile!.compareTo(a.mobile!);
          break;
      }
      return 0;
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
              !Responsive.isMobile(context)? Container(
                width: 250,
                height: 30,
                child: SearchBar(
                 hintText: "Search user by any",
                  leading: Icon(Icons.search),
                  //onChanged: apiController.setSearchQuery,
                  onChanged: (String? value){
                   apiController.getFilteredUsers(value);
                  },
                ),
              ):Container(
                width: 50,
                height: 20,
                child: SearchBar(
                  hintText: "Search user by any",
                  leading: Icon(Icons.search),
                  //onChanged: apiController.setSearchQuery,
                  onChanged: (String? value){
                    apiController.getFilteredUsers(value);
                  },
                ),
              ),


              !Responsive.isMobile(context)?
              Container(
                color: Get.isDarkMode?Colors.black54: Colors.white,

                // margin: const EdgeInsets.all(15.0),
             //   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
             //    decoration: BoxDecoration(
             //        color: Get.isDarkMode?Colors.black54: Colors.white,
             //        border: Border.all(color: Get.isDarkMode?Colors.black54: Colors.white,)
             //    ),
                child: DropdownButton(
                  value: selectedSortingOption,
                 // focusColor: Get.isDarkMode?Colors.white: Colors.black,
                 // dropdownColor: Get.isDarkMode?Colors.white: Colors.black,
                  hint: Text('Sorting'),
                 // borderRadius: BorderRadius.circular(15),
                  items: sortingOptions
                      .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSortingOption = value.toString();
                      _sortUserList();
                    });
                  },
                ),
              ):Container(),

              !Responsive.isMobile(context)? IconButton(
                icon: Icon(Icons.sort),
                onPressed: () {
                  setState(() {
                    isAscending = !isAscending;
                    _sortUserList();
                  });
                },
              ):Container(),
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
                label: Text("Create User"),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              // minWidth: 600,
              columns: [

                DataColumn(
                  label: Text("User"),
                ),
                !Responsive.isMobile(context)?  DataColumn(
                  label: Text("Email"),
                ):DataColumn(
                  label: Text(""),
                ),
                !Responsive.isMobile(context)?    DataColumn(
                  label: Text("Mobile No"),
                ):DataColumn(
                  label: Text(""),
                ),
                !Responsive.isMobile(context)?    DataColumn(
                  label: Text("Department"),
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
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color:Colors.green
                      ),

                      image: DecorationImage(image: NetworkImage(userInfo.userImageUrl!))
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Text(userInfo.userName!,overflow: TextOverflow.ellipsis,style:
                    TextStyle(
                     // color: Colors.green
                     // color: userInfo.isOnline=="true"?Colors.green:Colors.black
                    ),),
                ),
              ],
            ),
          ),
        ),
        !Responsive.isMobile(context)
            ? DataCell(Text(userInfo.email!))
            : DataCell(Text("")),
        !Responsive.isMobile(context)
            ? DataCell(Text(userInfo.mobile!))
            : DataCell(Text("")),
        !Responsive.isMobile(context)
            ? DataCell(Text(userInfo.userDepartment!))
            : DataCell(Text("")),
        DataCell(
          Row(
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: actionButtonPadding),
                child:           IconButton(onPressed: (){
                  showUserEditModal(context,user: userInfo);
                },icon: Icon(Icons.edit_document,color: Colors.green,),),
              ),
              userInfo.status=="Active"?Padding(
                padding: const EdgeInsets.symmetric(horizontal: actionButtonPadding),
                child:           IconButton(onPressed: (){
                  showMuteUserModal(context, () {
                    apiController.muteUser(context,{"UserId":userInfo.userId,"AdminId":LocalStorage.ADMINID,"UserStatus":"Active"});

                  });

                },icon: Icon(Icons.stop_circle_outlined,color: Colors.red,),),
              ):
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: actionButtonPadding),
                child:           IconButton(onPressed: (){
                  showUnMuteUserModal(context, () {
                    apiController.muteUser(context,{"UserId":userInfo.userId,"AdminId":LocalStorage.ADMINID,"UserStatus":"InActive"});
                    print('User account deleted!');

                  });

                },icon: Icon(Icons.airplanemode_active,color: Colors.deepOrange,),),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: actionButtonPadding),
              //   child: IconButton(
              //     onPressed: (){
              //     showDeleteUserModal(context, () {
              //       apiController.deleteUser(context,{"UserId":userInfo.userId,"AdminId":LocalStorage.ADMINID});
              //       setState(() {
              //
              //       });
              //     });
              //     // showUserDetailModal(context,user: userInfo);
              //   },icon: Icon(Icons.delete_outline,color: Colors.red,),),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: actionButtonPadding),
                child:IconButton(onPressed: (){
                  showChatModal(context, userInfo.userName!,userInfo.userId!,"user");
                },icon: Icon(Icons.messenger_outline,color: Colors.teal,),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: actionButtonPadding),
                child: IconButton(
                  onPressed: (){

                   showUserDetailModal(context,user: userInfo);
                },icon: Icon(Icons.details_outlined,color: Colors.green,),),
              ),
              IconButton(
                icon: Icon(Icons.group),
                onPressed: () {
                  apiController.findUserGroups(userInfo.userId!);
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Groups of ${userInfo.userName}'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: apiController.userInGroupList
                                .map(
                                  (group) => ListTile(
                                    leading:     Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          border: Border.all(
                                              color:Colors.green
                                          ),

                                          image: DecorationImage(image: NetworkImage(group.groupPic))
                                      ),
                                    ),
                                title: Text(group.groupName),

                               // subtitle: Text(group.),
                              ),
                            )
                                .toList(),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                             apiController.userInGroupList==[];
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}



