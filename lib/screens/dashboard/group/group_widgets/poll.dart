
import 'package:dash_board/screens/dashboard/group/group_widgets/poll_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

class Poll {
  final String question;
  final List<String> options;
  final Map<String, dynamic> votes; // Change this to Map<String, dynamic>
  final List<String> votersId;

  Poll({
    required this.question,
    required this.options,
    required this.votes,
    required this.votersId,
  });
}


class PollOptionsContainer extends StatelessWidget {
  final Poll poll;
  final Function(String) onVote;
  final String? votedOption;

  PollOptionsContainer({
    Key? key,
    required this.poll,
    required this.onVote,
    this.votedOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.90,
          child: Text(poll.question,style: TextStyle(
              color: Get.isDarkMode?Colors.black:Colors.black,
              fontWeight: FontWeight.w600
          ),),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.90,
          child: Text("Select one option",    style: TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: poll.options.map((option) {
            final voters = poll.votes[option]['voterIds'];
            final isSelected = option == votedOption;
            final isAnyOptionSelected = votedOption;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: isAnyOptionSelected!=''
                    //onPressed: isSelected
                        ? null // Disable all buttons if any option is selected
                        : () => onVote(option),
                    style: ElevatedButton.styleFrom(
                      primary: isSelected ? Colors.green : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 16,
                          color: isSelected ? Colors.green : null,
                        ),
                        SizedBox(width: 8),
                        Text(option,style: TextStyle(
                          color:   Get.isDarkMode?Colors.black:Colors.black,
                        ),),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Row(
                    children: [
                      Text(
                        'Votes: ',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      Text(
                        '${voters.length}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        Container(

          child: TextButton(
            onPressed: () {
              Get.dialog(PollDetailsDialog(
                poll: poll,
              ));
            },
            child: Text("View Details",    style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.green,
          ),
          alignment: Alignment.center,
          height: 40,
        )
      ],
    );
  }
}