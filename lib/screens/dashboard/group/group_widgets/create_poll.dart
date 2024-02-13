import 'dart:convert';

import 'package:dash_board/screens/dashboard/group/group_controllers/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePollDialog extends StatefulWidget {
  final String? selectedId;
  final String? receiverName;
  final String? receiverType;


  CreatePollDialog({ this.receiverName,this.receiverType,this.selectedId});
  @override
  _CreatePollDialogState createState() => _CreatePollDialogState();
}

class _CreatePollDialogState extends State<CreatePollDialog> {
  TextEditingController _questionController = TextEditingController();
  GroupController groupController=Get.put(GroupController());
  List<String> _options = [];

  void _addOption() {
    setState(() {
      _options.add('');
    });
  }

  void _removeOption(int index) {
    setState(() {
      _options.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Poll'),

      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            SizedBox(height: 20),
            Text('Options:'),
            Column(
              children: _options.asMap().entries.map((entry) {
                int index = entry.key;
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          _options[index] = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Option ${index + 1}',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () {
                        _removeOption(index);
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addOption,
              child: Text('Add Option'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Save poll data and close dialog
            String question = _questionController.text;
            List<String> options = List.from(_options);
            Map<String, List<String>> optionVotes = {};
            Map<String, dynamic>? votes;
            votes = {};
            for (String option in options) {
              votes[option] = {'voterIds': [], 'count': 0};
            }
            String updatedVotesPart = 'Votes: ${jsonEncode(votes)}';
            String pollMessage = "Question: $question\nOptions: ${options.join(', ')}\n$updatedVotesPart";
           groupController.sendPollMsgtoServer(pollMessage,widget.selectedId,widget.receiverName,widget.receiverType);
            Navigator.of(context).pop();
          },
          child: Text('Create Poll'),
        ),
      ],
    );
  }

}
