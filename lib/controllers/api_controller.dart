import 'dart:convert';
import 'package:dash_board/controllers/MenuAppController.dart';
import 'package:dash_board/main.dart';
import 'package:dash_board/models/Groups.dart';
import 'package:dash_board/models/Users.dart';
import 'package:dash_board/models/departments.dart';
import 'package:dash_board/screens/dashboard/department/department_screen.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/socket.dart';
import 'package:dash_board/utils/urls.dart';
import 'package:dash_board/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class ApiController extends GetxController {
  final userList=<User>[].obs;
  final everyUserWithAdmin=<User>[].obs;
  final departmentList=<Department>[].obs;
  final mutedUserList=<User>[].obs;
  final onlineUserList=<User>[].obs;
  final groupList=<Group>[].obs;
  final mode="Light".obs;
  var onlineusername = "name";
  var onlineNameList = [].obs;
  var onlineImageList = [].obs;
  var temporaryOnlineUserList = <dynamic>[].obs;
  SocketController socketController=Get.put(SocketController());
  final MenuAppController menuAppController=Get.put(MenuAppController());

   getFilteredUsers(value) {
    print(userList.length);
  List<User> newUser=userList;
    final query = value.toLowerCase();
    newUser= userList
        .where((user) =>
    user.userName!.toLowerCase().contains(query) ||
        user.email!.toLowerCase().contains(query)||
        user.mobile!.toLowerCase().contains(query)||
        user.time!.toLowerCase().contains(query)||
        user.dob!.toLowerCase().contains(query)||
        user.userDepartment!.toLowerCase().contains(query)

    )
        .toList();
    userList.value=newUser;
    if(value==''){
      fetchUsers({"AdminId": LocalStorage.ADMINID});
    }
  }
  getFilteredOnlineUsers(value) {
    print(onlineUserList.length);
    List<User> newUser=onlineUserList;
    final query = value.toLowerCase();
    newUser= onlineUserList
        .where((user) =>
    user.userName!.toLowerCase().contains(query) ||
        user.email!.toLowerCase().contains(query)||
        user.mobile!.toLowerCase().contains(query)||
        user.time!.toLowerCase().contains(query)||
        user.dob!.toLowerCase().contains(query)||
        user.userDepartment!.toLowerCase().contains(query)

    )
        .toList();
    onlineUserList.value=newUser;
    if(value==''){
      fetchUsers({"AdminId": LocalStorage.ADMINID});
    }
  }
  getFilteredGroups(value) {
    print(groupList.length);
    List<Group> newUser=groupList;
    final query = value.toLowerCase();
    newUser= groupList
        .where((user) =>
    user.groupName.toLowerCase().contains(query))
        .toList();
    groupList.value=newUser;
    if(value==''){
      fetchGroups({"AdminId": LocalStorage.ADMINID});
    }
  }

  MenuAppController controller=MenuAppController();
  void toggleTheme() {
    Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
  }

  ///create department
  Future<Map<String, dynamic>> createDepartment(String departmentName) async {
    final url = Uri.parse('${WebApi.basesUrl}/api/departments');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'DepartmentName': departmentName}),
      );
    if (response.statusCode == 201) {
      getAllDepartments();
        return  showAlerDialog("Congratulations!", "Department has been created successfully!");

      }else if(response.statusCode==400){
       return showAlerDialog("Warning!", "Department already taken! Try another one");
      } else {
        // Handle error cases
        print('Error creating department: ${response.statusCode}');
        return {'error': 'Failed to create department'};
      }
    } catch (e) {
      print('Exception creating department: $e');
      return {'error': 'Exception occurred'};
    }
    update();
  }
  ///get all departments
  Future<List<Department>> getAllDepartments() async {
    final response = await http.get(Uri.parse('${WebApi.basesUrl}/api/departments'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final List<dynamic> data = json.decode(response.body);
      List<Department> departments = data.map((json) => Department.fromJson(json)).toList();
      departmentList.value=departments;

      return departments;
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load departments');
    }

  }
  ///delete department
  Future<void> deleteDepartment(String id) async {
    final response = await http.delete(Uri.parse('${WebApi.basesUrl}/api/departments/$id'));
    if (response.statusCode == 200) {
      print('Department deleted successfully');
      getAllDepartments();
      showAlerDialog("Success!", "Department has been deleted!");
    } else {
      throw Exception('Failed to delete department');
    }
    update();
  }
  ///make departmentHead
  makeDepartmentHead(Map<String, dynamic> data) async {
    try {
    final response = await http.post(Uri.parse('${WebApi.basesUrl}/makeDepartmentHead'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode(data),
    );


    if (response.statusCode == 200) {
      print('user created: ${response.body}');
      menuAppController.changeSelectedItem(MenuItem.department);
      toggleSuccess(Get.context!, "You make this user as department head");
      //Get.back();

    } else {
      throw Exception('Failed to load data');
    }


    } catch (e) {
      print('Error: $e');
      // Handle errors here
    }finally{
      await getAllDepartments();

    }
    update();
  }
///user
  Future<void> createNewUser(BuildContext context,Map<String, dynamic> data) async {

    final response = await http.post(Uri.parse('${WebApi.basesUrl}/createUserbyadmin'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('user created: ${response.body}');
      await fetchUsers({"AdminId":LocalStorage.ADMINID});
    } else {
      throw Exception('Failed to load data');
    }
    update();
  }
  Future<void> updateUser(Map<String, dynamic> data) async {
    final response = await http.post(Uri.parse('${WebApi.basesUrl}/updateUserByAdmin'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('user created: ${response.body}');
     await fetchUsers({"AdminId": LocalStorage.ADMINID});

    } else {
      throw Exception('Failed to load data');
    }
    update();
  }
  Future<void> deleteUser(BuildContext context,Map<String, dynamic> data) async {
    final response = await http.post(Uri.parse('${WebApi.basesUrl}/DeleteAccountPermanentByAdmin'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print(response.body);
    //  userList.removeAt(index)
      print('User account deleted!');
      toggleSuccess(context,"User has been deleted successfully!");
      fetchUsers({"AdminId": LocalStorage.ADMINID});
      Get.to(()=>MyApp());


    } else {
      throw Exception('Failed to load data');
    }
    update();
  }
   fetchUsers(Map<String, dynamic> data) async {

    final response = await http.post(Uri.parse('${WebApi.basesUrl}/allUserforControllbyadmin'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final List<dynamic> userDataList = json.decode(response.body);
   // print('total users from api:$userDataList');
      // var userId,userName,userAddress;
      // for(var i=0;userDataList.length>i;i++){
      //   final User currentUser=User(
      //     userId: userDataList[i]['_id']
      //   );
      // }

      var userOnline;
      List<User> currentUserList = userDataList
          .where((userData) => userData['AccountStatus'] != 'None')
          .map((userData) {
        // if(onlineUserList.contains(userData['_id'])){
        //   userOnline=true;
        //
        // }else{
        //   userOnline=false;
        //
        // }
        return User(
          userId: userData['_id'],
          userImageUrl: userData['ProfilePic'] == null || userData['ProfilePic'] == "" ? "assets/images/logo.png" : "${WebApi.basesUrl}${userData['ProfilePic'].toString().substring(2)}",
          userName: userData['FullName'] ?? "",
          userDepartment:  userData['Department'] ?? "",
          email: userData['Email'] ?? "",
          password: userData['Password'] ?? "",
          address: userData['Address'] ?? "",
          mobile: userData["MobileNo"]??'',
          dob: userData["DOB"]??"",
          gender: userData["Gender"]??"",
          time: userData["SortingDate"]??"",
          status: userData['AccountStatus'] ?? "Active",

          // Add other properties as needed
        );
      }).toList();
      List<User> mutedUsers = userDataList
          .where((userData) => userData['AccountStatus'] == 'InActive')
          .map((userData) {
        return User(
          userId: userData['_id'],
          userImageUrl: userData['ProfilePic'] == null || userData['ProfilePic'] == "" ? "assets/images/logo.png" :"${WebApi.basesUrl}${userData['ProfilePic'].toString().substring(2)}",
          userName: userData['FullName'] ?? "",
          userDepartment:  userData['Department'] ?? "",
          email: userData['Email'] ?? "",
          password: userData['Password'] ?? "",
          address: userData['Address'] ?? "",
          mobile: userData["MobileNo"]??'',
          dob: userData["DOB"]??"",
          gender: userData["Gender"]??"",
          time: userData["SortingDate"]??"",
          status: userData['AccountStatus'] ?? "InActive",
          // Add other properties as needed
        );
      }).toList();
      List<User> onlineUserLists = userDataList
          .where((userData) => userData['isOnline'] == true)
          .map((userData) {
        return User(
          userId: userData['_id'],
          userImageUrl: userData['ProfilePic'] == null || userData['ProfilePic'] == "" ? "assets/images/logo.png" : "${WebApi.basesUrl}${userData['ProfilePic'].toString().substring(2)}",
          userName: userData['FullName'] ?? "",
          userDepartment:  userData['Department'] ?? "",
          email: userData['Email'] ?? "",
          password: userData['Password'] ?? "",
          address: userData['Address'] ?? "",
          mobile: userData["MobileNo"]??'',
         dob: userData["DOB"]??"",
          gender: userData["Gender"]??"",
          time: userData["SortingDate"]??"",
          status: userData['AccountStatus'] ?? "InActive",
          isOnline: userData['isOnline'] ?? true,
          // Add other properties as needed
        );
      }).toList();
      onlineUserList.value=onlineUserLists;
      mutedUserList.value=mutedUsers;
      userList.value = currentUserList;
     // print(userList[0].isOnline);

    } else {
      throw Exception('Failed to load data');
    }
    update();
  }
  Future<void> muteUser(BuildContext context,Map<String, dynamic> data) async {
    final response = await http.post(Uri.parse('${WebApi.basesUrl}/MuteUnMuteAccountPermanentByAdmin'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      toggleSuccess(context,"User has been muted successfully!");
      fetchUsers({"AdminId": LocalStorage.ADMINID});
    } else {
      throw Exception('Failed to load data');
    }
    update();
  }

  Future<void> getOnlineUsers(BuildContext context,Map<String, dynamic> data) async {
    final response = await http.post(Uri.parse('${WebApi.basesUrl}/api/getallonlineusers'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
   //   toggleSuccess(context,"User has been muted successfully!");
      fetchUsers({"AdminId": LocalStorage.ADMINID});
    } else {
      throw Exception('Failed to load data');
    }
    update();
  }

  ///Group
  Future<void> fetchGroups(Map<String, dynamic> data) async {
    final response = await http.post(Uri.parse('${WebApi.basesUrl}/allGroupforControllbyadmin'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final List<dynamic> groupDataList = json.decode(response.body);
   //   print('total users from api:$groupDataList');

      List<Group> currentGroupList = groupDataList.map((groupData) {
        return Group(
              id: groupData['_id'],
          adminID: groupData['Admin']??"",
          groupName: groupData['GroupName']??"",
          groupPic: groupData['GroupPic']==null||groupData['GroupPic']==''?"assets/images/group.png":"${WebApi.basesUrl}${groupData['GroupPic'].toString().substring(2)}",
          membersID: groupData['MembersID']??[],
          privacy: groupData['Privacy']??"",
          dateTime: groupData['DateTime']??""
          // Add other properties as needed
        );
      }).toList();

      groupList.value = currentGroupList;

      groupList.map((e) => print(e.groupPic));

    } else {
      throw Exception('Failed to load data');
    }
    update();
  }
  Future<void> createNewGroup(BuildContext context,Map<String, dynamic> data) async {
    final response = await http.post(Uri.parse('${WebApi.basesUrl}/createGroupByAdmin'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('user created: ${response.body}');
      toggleSuccess(context,"Group has been created successfully!");

    } else {
      throw Exception('Failed to load data');
    }
    update();
  }
  Future<void> updateGroup(BuildContext context,Map<String, dynamic> data) async {
    final response = await http.post(Uri.parse('${WebApi.basesUrl}/updateGroupByAdmin'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('group created: ${response.body}');

      toggleSuccess(context, "Group name successfully updated!");
    } else {
      throw Exception('Failed to load data');
    }
    update();
  }

  Future<void> deleteGroup(BuildContext context,Map<String, dynamic> data) async {
    final response = await http.post(Uri.parse('${WebApi.basesUrl}/deleteGroupByAdmin'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print(response.body);
      //  userList.removeAt(index)
      print('User account deleted!');
      toggleSuccess(context,"Group has been deleted successfully!");


    } else {
      throw Exception('Failed to load data');
    }
    update();
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    socketController.socket.emit('usrSocketIdForOnline',
        {"OwnId": LocalStorage.ADMINID, "SocketId": socketController.socketId}
    );

  }
}
