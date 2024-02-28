import 'dart:convert';
import 'dart:io';
import 'package:dash_board/utils/encrypt.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:dash_board/models/ChatMessage.dart';
import 'package:dash_board/models/message.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/socket.dart';
import 'package:dash_board/utils/urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
List<double> itemHeights2 = [];
List<MESSAGE> loadMsgTest = [];
int globalIndex = 0;
var isRuntimeMsg = false;
const int iconColor = 0xFF8C93C7;
enum MessageType { sent, received }
class UserChatController extends GetxController{
  final socketController = Get.put(SocketController());
  final scrollController=ScrollController();
  var message;
  DateTime d = DateTime.now();
  final messages = <MESSAGE>[].obs;
  final dateWiseValue = <String>[].obs;
  final selectedId=''.obs;
  final selectedName=''.obs;
  final selectedType=''.obs;
  final selectedImage=''.obs;
  final userBlockStatus=''.obs;
  final blockedBy=''.obs;
  final showEmojiKeyboard = false.obs;
  final isTyping = false.obs;
  final isShowSticker=false.obs;
  final isVoiceOrSend = true.obs;
  final isChatLoadComplete = false.obs;
  final isKeyPressed = false.obs;
  void loadReceiveData(data, loadmore) {
    // final encryptedData = 'V1cR1/KX/YahRypjCAi34A==';
    // final secretKey = '65bb785223571ee01f4a8dc4';
    // final customIV = "yourcustomIV1234";
    //
    // try {
    //   final decryptedData = decrypt(encryptedData, secretKey, customIV);
    //   print('Decrypted: $decryptedData');
    // } catch (error) {
    //   // Handle the decryption error here
    //   print('Decryption error: $error');
    // }
    var json = jsonEncode(data);
    Map<String, dynamic> map = jsonDecode(json);
    if (map["SenderInfo"] == '' || map["SenderInfo"] == null) {
      var id = map["_id"];
      var msgType = map["Type"];
      var messageText = '';

      var fullDateAndTime = map["DateTime"];
      var dateMsgBefore = fullDateAndTime.toString().substring(0, 10);
     // var dateMsg = loadLastChatOnRecentChat(dateMsgBefore);
      var dateMsg = "12-01-2024";
      var hr = fullDateAndTime.toString().substring(10);
      var profileIcon = "${WebApi.basesUrl}/Image/male.png";
      var usrFltrData = map["_id"];
      var dataSender = map["SenderID"];
      var dlFileName = map["FileName"];
      var senderStatus = map["AccountStatus"];
      var receiverStatus = map["Status"];
      var msgSenderNameFull = map["FullName"];
      var seenStatus = map['SeenStatus'];
      var chatType = map["UserType"];
      var msgReply = map["ReplyMsg"];
      var replyMessageType = map["ReplyMsgType"];
      var msgReplyId = map["ReplyMsgID"];
      var fileSize = map["FileSize"];
      var msgSenderName = msgSenderNameFull;
      var finalDateForHeading;
      bool dateAddInMsg = false;
      if (dateWiseValue.length == 0) {
        dateWiseValue.add(dateMsg.trim());
        dateAddInMsg = true;
        finalDateForHeading = dateMsg;
      }
      else {
        if (dateWiseValue.contains(dateMsg) == false) {
          dateWiseValue.add(dateMsg.trim());
          dateAddInMsg = true;
          finalDateForHeading = dateMsg;
        }
      }
      var typeFile;
      var filedwnloadLink;
      var seenValue;
      var showRunTime;
      var checkMediaListArray = [];
      if (isRuntimeMsg == true) {
        showRunTime = "Yes";
      } else {
        showRunTime = "No";
      }
      if (msgType == "Activity") {
        messageText = map["Message"];
        //  //print("Here is the message: ${messageText}");
      }
      final MESSAGE currentMessage = MESSAGE(
          id: id,
          senderId: dataSender,
          msgType: msgType,
          messageText: messageText,
          replyMsgType: replyMessageType,

          fullDateAndTime: fullDateAndTime,
          dateMsg: dateMsg,
          hr: hr,
          profileIcon: profileIcon,
          usrFltrData: usrFltrData,
          dlFileName: dlFileName,
          senderStatus: senderStatus,
          receiverStatus: receiverStatus,
          msgSenderNameFull: msgSenderNameFull,
          seenStatus: seenStatus,
          chatType: chatType,
          msgReply: msgReply,
          msgReplyId: msgReplyId,
          fileSize: fileSize,
          msgSenderName: msgSenderName,
          typeFile: typeFile,
          filedwnloadLink: filedwnloadLink,
          seenValue: seenValue,
          showRunTime: showRunTime,
          isVisible: true,
          dateHeading: dateAddInMsg);

      if (loadmore == true) {
        messages.insert(0,currentMessage);

        isRuntimeMsg = false;
      } else {
        messages.insert(0, currentMessage);
        isRuntimeMsg = false;
      }
      isChatLoadComplete.value = true;
    }
    else {
      List<dynamic> senderInfo = map["SenderInfo"];
      var fullDateAndTime = map["DateTime"];
      var dateMsgBefore = fullDateAndTime.toString().substring(0, 10);
     // var dateMsg = loadLastChatOnRecentChat(dateMsgBefore);
      var dateMsg = "12-01-2024";
      var hr = fullDateAndTime.toString().substring(10);
      var profileIcon = "${WebApi.basesUrl}/Image/male.png";
      var id = map["_id"];
      var msgType = map["Type"];
      var messageText = '';
      if (msgType == 'Multi-Image') {
        //print(map["Message"].length);
        for (var j = 0; j < map["Message"].length; j++) {
          messageText = messageText + ',' +
              map["Message"][j]["FileName"].toString().substring(2);
          // //print('all messages : ${map["Message"][j]["FileName"]
          //     .toString()
          //     .substring(2)}');
          // //print('all messages2 : $messageText');
        }
      }
      else {
        messageText = map["Message"];
      }

      var usrFltrData = map["_id"];
      var dataSender = map["SenderID"];
      var dlFileName = map["FileName"];
      var senderStatus = senderInfo[0]["AccountStatus"];
      var receiverStatus = map["Status"];

      var msgSenderNameFull = senderInfo[0]["FullName"];
      var seenStatus = map['SeenStatus'];
      //  //print(seenStatus);
      var chatType = senderInfo[0]["UserType"];
      var msgReply = map["ReplyMsg"];
      var replyMessageType = map["ReplyMsgType"];
      var msgReplyId = map["ReplyMsgID"];
      var fileSize = map['FileSize'];
      var msgSenderName;
      if (msgSenderNameFull.contains(' ')) {
        msgSenderName = msgSenderNameFull
            .toString()
            .substring(0, msgSenderNameFull.indexOf(' '));
      } else {
        msgSenderName = msgSenderNameFull;
      }
      var finalDateForHeading;
      final dateAddInMsg = false.obs;

      if (dateWiseValue.length == 0) {
        dateWiseValue.add(dateMsg.trim());
        dateAddInMsg.value = true;
        finalDateForHeading = dateMsg;
      }
      else {
        if (dateWiseValue.contains(dateMsg) == false) {
          dateWiseValue.add(dateMsg.trim());
          dateAddInMsg.value = true;
          finalDateForHeading = dateMsg;
        }
      }
      var typeFile;
      var filedwnloadLink;
      var seenValue;
      var showRunTime;
      var checkMediaListArray = [];
      if (isRuntimeMsg == true) {
        showRunTime = "Yes";
      } else {
        showRunTime = "No";
      }
      if (msgType == "Activity") {
        messageText = map["Message"];
        //   //print("Here is the message: ${messageText}");
      }
      final MESSAGE currentMessage = MESSAGE(
          id: id,
          senderId: dataSender,
          msgType: msgType,
          messageText: messageText,
          fullDateAndTime: fullDateAndTime,
          dateMsg: dateMsg,
          hr: hr,
          profileIcon: profileIcon,
          usrFltrData: usrFltrData,
          dlFileName: dlFileName,
          senderStatus: senderStatus,
          receiverStatus: receiverStatus,
          msgSenderNameFull: msgSenderNameFull,
          seenStatus: seenStatus,
          replyMsgType: replyMessageType,
          chatType: chatType,
          msgReply: msgReply,
          msgReplyId: msgReplyId,
          fileSize: fileSize,
          msgSenderName: msgSenderName,
          typeFile: typeFile,
          filedwnloadLink: filedwnloadLink,
          seenValue: seenValue,
          showRunTime: showRunTime,
          isVisible: true,
          dateHeading: dateAddInMsg.value);

      if (loadmore == true) {
        messages.insert(0,currentMessage);
        isRuntimeMsg = false;
      } else {
        messages.insert(0,currentMessage);
        isRuntimeMsg = false;
      }

      isChatLoadComplete.value = true;

    }

    // //print('seen status change ${currentMessage.seenStatus}');

  }
  final dataProcessed = false.obs;

  void ChatScreenPageReady(selectId,selectType) {

    socketController.socket.on("seenStatusChange"+selectedId.value, (data) {
         print("seen by user hit: $data");

      for(var i=0;messages.length>i;i++){

        messages[i].seenStatus!="Seen";
        //print(messages[i].seenStatus);

      }
    });
    messages.value = [];
    loadMsgTest = [];
   // LocalStorage.blockUserCheck = 'OFF';
    socketController.socket.emit(
        "loadAllChatWeb", {
      "UserId": LocalStorage.ADMINID,
      "SelectId": selectedId.value,
      "UserType": selectedType.value,
      // "DeviceId":LocalStorage.DEVICEID
    }
    );


// Listen for socket events
    socketController.socket.on('loadDataWeb' + LocalStorage.ADMINID, (data) {
      //print("load data: $data");

      // Check if data has been processed already
      if (!dataProcessed.value) {
        // Process the data
        for (var i = 0; i < data.length; i++) {
          loadReceiveData(data[i], true);
        }

        // Set the flag to true to indicate that data has been processed
        dataProcessed.value = true;
      }
    });
  }
  void removechat(msgId,selectId,type) async {

    //print('remove chat');
    Map data = {
      "MsgId":msgId,
      'UserId': LocalStorage.ADMINID,
      "SelectId":selectId,
      "Type":type,
    };
    final response =
    await http.post(Uri.parse('${WebApi.basesUrl}/msgDeleteById'),
        headers: {
          'connection': "keep-alive",
          'Authorization': 'Bearer ${LocalStorage.BearerTOKEN}'
        },
        body: data);
    var json = response.body;
    //print(json);
    if(json=='success'){
      //showAlertSuccessDialog("Message deleted successfully.", context);
    }
  }
  showMultitaskPOPUPDialog(String message, int index, BuildContext context) {
    Widget clickButton = Container(
      height: 100,
      width: 200,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          messages[index].msgType.toString().contains('Image') ||
              messages[index].msgType.toString().contains('Audio') ||
              messages[index].msgType.toString().contains('File') ||
              messages[index].msgType.toString().contains('Activity')


              ? Container() : InkWell(
            onTap: () async {
              await Clipboard.setData(
                  ClipboardData(text: messages[index].messageText!));
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Copy'),
            ),
          ),

          Divider(
            height: 1,
          ),
      /*    InkWell(
            onTap: () {

            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Forward'),
            ),
          ),*/

          Divider(
            height: 1,
          ),

          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Remove'),
            ),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text('Do you want to remove this message?'),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              }, //  We can return any object from here
                              child: Text('NO')),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);

                                if (messages[index].dateHeading == true &&
                                    index != 0) {
                                  if (messages[index - 1].dateHeading != true) {                                        messages[index - 1].dateHeading = true;
                                  messages[index - 1].dateHeading = true;
                                  }
                                }
                                removechat(messages[index].id.toString(),selectedId.value,selectedType.value);
                                messages.removeAt(index);
                              }, //  We can return any object from here
                              child: Text('YES'))
                        ],
                      ));
            },
          )

        ],
      ),
    );
    // configura o  AlertDialog
    AlertDialog alertDialog = AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 50),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            20.0,
          ),
        ),
      ),


      actions: [
        clickButton,

      ],
    );
    // exibe o dialog
    showCupertinoDialog(
      barrierDismissible: true,

      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    // String deviceId = await getDeviceId();
    // print('Device ID: $deviceId');
    // if(deviceId!=''){
    //   LocalStorage.DEVICEID=deviceId;
    // }
    socketController.socket.on('sentToRcvr' + LocalStorage.ADMINID ,(data) {
      var msgType = data['Type'];
      var chatType = data['ChatType'];
      var id = data['_id'];
      var rmvTmStmp = data['DateTime'];
      var messageText = data['Message'];
      var dataSender = data['SenderID'];
      var groupId = data['GroupID'];
      var receiver = data['ReceiverId'];
      if (chatType == 'Group') {
        if (groupId != selectedId.value) {
          var data = [
            {
              "UserId": LocalStorage.ADMINID,
              "SelectId": groupId,
              "UserType": selectedType.value
            }
          ];
          socketController.socket.emit('clearNotification', data);
          //  socketController.socket.emit('messageSeenByUser', data);
        }
        if (groupId == selectedId.value) {
          if (msgType.contains("Image")) {
            if (msgType.contains("Multi-Image")) {
              isRuntimeMsg = true;
              for (var i = 1; i < messageText.length; i++) {
              //  checkImageSave(messageText[i]['FileName'], "Image");
              }
            }
            else {
              isRuntimeMsg = true;
            //  checkImageSave(messageText, msgType);
            }
          }
          else if (msgType.contains("Audio")) {
            isRuntimeMsg = true;
          //  checkImageSave(messageText, msgType);
          }
          else if (msgType.contains("Video")) {
            isRuntimeMsg = true;
           // checkImageSave(messageText, msgType);
          }
          else if (msgType.contains("File")) {
            //print('hit file');
            isRuntimeMsg = true;
            //checkImageSave(messageText, msgType);
          }
          loadReceiveData(data, false);

        }
        else {
        }
      }
      else {
        if (dataSender != selectedId.value) {
          var data = [
            {
              "UserId": LocalStorage.ADMINID,
              "SelectId": groupId,
              "UserType": selectedType.value
            }
          ];
          socketController.socket.emit('clearNotification', data);
          var SeenData = [
            {
              "UserId": LocalStorage.ADMINID,
              "SelectId": dataSender,
              "UserType": selectedType.value
            }
          ];
          // socketController.socket.emit('messageSeenByUser', SeenData);
        }
        if (dataSender == selectedId.value) {
          if (msgType.contains("Image")) {
            if (msgType.contains("Multi-Image")) {
              isRuntimeMsg = true;
              var groupImage = messageText.split(",");
              for (var i = 1; i < groupImage.length; i++) {
               // checkImageSave(groupImage[i], "Image");
              }
            }
            else {
              isRuntimeMsg = true;
              //checkImageSave(messageText, msgType);
            }
          }
          else if (msgType.contains("Audio")) {
            isRuntimeMsg = true;
           // checkImageSave(messageText, msgType);
          }
          else if (msgType.contains("Video")) {
            isRuntimeMsg = true;
           // checkImageSave(messageText, msgType);
          }
          else if (msgType == "File") {
            isRuntimeMsg = true;
          //  checkImageSave(messageText, msgType);
          }
          loadReceiveData(data, false);

          var SeenData = [
            {
              "UserId": LocalStorage.ADMINID,
              "SelectId": dataSender,
              "UserType": selectedType.value
            }
          ];
          //  socketController.socket.emit('messageSeenByUser', SeenData);

        }
        else {
          // //print("Avoid msg rcv");
          //  TestTestChatState().loadrecentchatlist();
        }
      }
    }
    );
    socketController.socket.off('rcvOwnMsg' + LocalStorage.ADMINID);
    socketController.socket.on('rcvOwnMsg' + LocalStorage.ADMINID, (data) {
      //  print('hit receive own message socket ${data}');
      // print('own user ID:${localStorage.ownUserId}');
      print('selected Id:${selectedId.value}');
      // //print(data);
      var receiver;
      var msgType;
      var msgId;
      var rmvTmStmp;
      var messageText;
      var msgSeenStatus;
      var msgChatType;
      var replyMessageId;
      var replyMessage;
      var replyMesssageType;

      var chatType ;
      for (var i = 0; i < data.length; i++) {
        receiver = data["ReceiverId"];
        msgType = data["Type"];
        msgId = data["_id"];
        rmvTmStmp = data["DateTime"];
        messageText = data["Message"];
        chatType= data['ChatType'];
      }
      if(chatType=="Private"){
        loadReceiveData(data, false);

      }else{
        //print('Group chat ');
      }
    });
  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
   // socketController.socket.off("loadAllChat");
  //  socketController.socket.off("loadData");
  }
}