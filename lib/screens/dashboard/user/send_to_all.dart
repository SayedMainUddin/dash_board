import 'package:dash_board/constants.dart';
import 'package:dash_board/models/ChatMessage.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/socket.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SendToAllChatModal extends StatefulWidget {
  final String? selectedId;
  final String? receiverName;
  final String? receiverType;
  final List? selectedUsers;


  SendToAllChatModal({ this.receiverName,this.receiverType,this.selectedId,this.selectedUsers});

  @override
  _ChatModalState createState() => _ChatModalState();
}

class _ChatModalState extends State<SendToAllChatModal> {
  SocketController socketController=Get.put(SocketController());
  final TextEditingController messageController = TextEditingController();
  List<ChatMessage> messages = [];
  DateTime d = DateTime.now();
  Future<void> sendMsgtoServer(String message) async {
    String datetime = DateFormat('dd/MM/yyyy hh:mm a').format(d);
    message = messageController.text;
    messageController.text = '';
    // print(selectedId);
    // print(receiverType);
    // print(receiverName);
    // print(message);
    if (message != "" || message != null) {
      messageController.clear();

      var sntData = {
        "UserId": LocalStorage.ADMINID,
        "Message": message,
        "MsgType": "text",
        "FileName": "",
        "UserType": "user",
        "SelectedUserIds":widget.selectedUsers
      };
      socketController.socket.emit('sendMessageToSelectedUsers', sntData);
    } else {
      //print("Are You Crazy");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width*0.40,
        height: MediaQuery.of(context).size.height*0.40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Chat with ${widget.receiverName}',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(
                    message: messages[index].message!,
                    isSentByUser: messages[index].isSentByUser!,
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(
                          color: Colors.black45
                      ),
                    ),
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send,color: Colors.teal,),
                  onPressed: () {
                    sendMessage();
                    sendMsgtoServer(messageController.text);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() {
    String message = messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        messages.add(ChatMessage(message: message, isSentByUser: true));
        // Add logic to send the message to the admin or perform any desired action
      });

      //   messageController.clear();
    }
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSentByUser;

  ChatBubble({required this.message, required this.isSentByUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: isSentByUser ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

void showSendToAllChatModal(BuildContext context,List selectedUsers) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SendToAllChatModal(selectedUsers: selectedUsers,);
    },
  );
}


