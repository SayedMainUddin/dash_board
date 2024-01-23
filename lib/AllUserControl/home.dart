import 'package:dash_board/AllUserControl/user_list.dart';
import 'package:dash_board/AllUserControl/user_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/Users.dart';

Future<List<Post>> fetchPosts(http.Client client) async {
  final response = await client.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

  return compute(parsePosts, response.body);
}

List<Post> parsePosts(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Post>((json) => Post.fromJson(json)).toList();
}

class HomePage extends StatelessWidget {
  final String? title;

  HomePage({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("title!"),
      ),
      body: FutureBuilder<List<User>>(
        future:                   fetchUsers('allUserforControllbyadmin',{"AdminId":"6545cc78434c8b5bd35c9133"}),
          builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ListViewPosts(posts: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

