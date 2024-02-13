import 'dart:convert';

import 'package:dash_board/screens/dashboard/group/group_controllers/group_controller.dart';
import 'package:dash_board/screens/dashboard/group/group_widgets/poll.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PollDetailsDialog extends StatefulWidget {
  var voters;
  Poll poll;

  PollDetailsDialog({this.voters,required this.poll});
  @override
  _CreatePollDialogState createState() => _CreatePollDialogState();
}

class _CreatePollDialogState extends State<PollDetailsDialog> {
  GroupController groupController=Get.put(GroupController());
  List<String> memberIds = [];



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Poll Details'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.poll.options.map((option) {
                final voters = widget.poll.votes[option]['voterIds'];

                return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    height: 300,
                    width: 400,
                    child: Container(

                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.green
                            ),
                            child: Row(
                              children: [
                                Container(
                                  child: Text(option,style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),),
                                ),
                                SizedBox(width: 50,),
                                Container(
                                  child: Text(voters.length.toString(),style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: voters.length,
                              shrinkWrap: true,
                              controller: ScrollController(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (ctx, i) {
                                // Find the index of the user with the matching unique ID
                                final userIndex = groupController.allGroupMember.indexWhere((user) => user.uniqueId == voters[i]);

                                // Check if a user with the matching unique ID exists
                                if (userIndex != -1) {
                                  // Return a CircleAvatar with the user's image
                                  return Row(
                                    children: [
                                      Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50)
                                          ),
                                          child: Image.network(groupController.allGroupMember[userIndex].imageUrl!)

                                      ),
                                      Container(

                                        child: Text(groupController.allGroupMember[userIndex].name!),
                                      )
                                    ],
                                  );
                                } else {
                                  // Return a default CircleAvatar if the user is not found
                                  return Container(
                                    height: 50,
                                    width: 50,
                                    child: CircleAvatar(
                                      radius: 50,
                                      child: Image.asset("assets/image/female.png"),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                    )
                );
              }).toList(),
            ),


          ],
        ),
      ),

    );
  }

}
