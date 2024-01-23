import 'dart:convert';

import 'package:dash_board/AllUserControl/user_model.dart';
import 'package:dash_board/models/Users.dart';
import 'package:dash_board/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

Future<List<User>> fetchUsers(String endpoint,Map<String, dynamic> data) async {
 // var uri = Uri.https('https://192.168.0.225:43673',"/$endpoint");

  final response = await http.post(Uri.parse('http://192.168.0.225:43673/allUserforControllbyadmin'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    final List<dynamic> userDataList = json.decode(response.body);
   print('total users:$userDataList');
    // var userId,userName,userAddress;
    // for(var i=0;userDataList.length>i;i++){
    //   final User currentUser=User(
    //     userId: userDataList[i]['_id']
    //   );
    // }
    final List<User> userList = userDataList.map((userData) {
      return User(
        userId: userData['_id'],
        userName: userData['FullName'],
        userImageUrl: userData['Email'],
        // Add other properties as needed
      );
    }).toList();
    print(userList[0].senderId.toString());
  //  final List<User> userList = userDataList.map((data) => User.fromJson(data)).toList();
    // for(var user in userList.toList() ){
    //   print(user.senderId);
    // }

    return userList;
  } else {
    throw Exception('Failed to load data');
  }
}

class ListViewPosts extends StatelessWidget {
  final List<User>? posts;

  ListViewPosts({Key? key, this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: ListView.builder(
          itemCount: posts!.length,
          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
          itemBuilder: (context, position) {
            return Column(
              children: <Widget>[
                Divider(height: 10.0),
                ListTile(
                  title: Text(
                    '${posts![position].userName}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  subtitle: Text(
                    '${posts![position].senderId.toString()}',   ////
                    style: new TextStyle(
                      fontSize: 15.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  leading: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: 10.0,
                        child: Text(
                          'User ${posts![position].userId.toString()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                trailing: IconButton(onPressed: (){
                  fetchUsers('allUserforControllbyadmin',{"AdminId":"6545cc78434c8b5bd35c9133"});
                }, icon: Icon(Icons.send)),
                //  onTap: () => _onTapItem(context, posts![position]),
                ),
              ],
            );
          }),
    );
  }

  // void _onTapItem(BuildContext context, Post post) {
  //   Scaffold
  //       .of(context)
  //       .showSnackBar(new SnackBar(content: new Text(post.id.toString() + ' - ' + post.title)));
  // }
}