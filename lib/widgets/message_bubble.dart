import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;

import 'dart:typed_data';
import 'package:dash_board/models/message.dart';
import 'package:dash_board/screens/dashboard/group/group_controllers/group_controller.dart';
import 'package:dash_board/screens/dashboard/user/user_controller/user_chat_controller.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/urls.dart';
import 'package:dash_board/widgets/multi-image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:io' show kIsWeb;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../screens/dashboard/group/group_widgets/poll.dart';
import 'four_image.dart';

class MessageWidget extends StatefulWidget {
  final int i;
  final ScrollController scrollController;

  const MessageWidget({required this.i, required this.scrollController});

  @override
  State<StatefulWidget> createState() {
    return _MessageWidget();
  }
}

class _MessageWidget extends State<MessageWidget> {
  UserChatController userChatController = Get.put(
      UserChatController());
  GroupController groupController=Get.put(GroupController());

  String? previousDate;
  var multipleImageList;
  @override
  Widget build(BuildContext context) {
    double screenHeight = Get.height;
    double screenWidth = Get.width;
    final newmessageforchat = userChatController.messages.reversed.toList();
    final currentMessage = userChatController.messages[widget.i];
    final previousMessage = widget.i > 0 ? userChatController
        .messages[widget.i - 1] : null;
    final isDifferentSender = currentMessage.senderId !=
        (previousMessage?.senderId);
    final isDifferentType = currentMessage.msgType !=
        (previousMessage?.msgType);
    final isFirstInGroup = isDifferentSender || isDifferentType;
    final isLastMessage = widget.i ==
        userChatController.messages.length - 1;


    return InkWell(
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2.0),
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                userChatController.messages[widget.i].isVisible == true ?
                Row(
                  mainAxisAlignment: userChatController.messages[widget.i]
                      .msgType == "Activity"
                      ? MainAxisAlignment.center
                      : userChatController.messages[widget.i].senderId ==
                      LocalStorage.ADMINID
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: <Widget>[

                    Column(
                        crossAxisAlignment: userChatController
                            .messages[widget.i].senderId ==
                            LocalStorage.ADMINID
                            ?
                        CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          // userChatController.messages[widget.i]
                          //     .dateHeading == true ?
                          // // buildMessage(widget.i),
                          //
                          //
                          // Container(
                          //   margin: userChatController.messages[widget.i]
                          //       .senderId == LocalStorage.ADMINID ?
                          //   EdgeInsets.fromLTRB(0, 0, 50, 0) : EdgeInsets
                          //       .fromLTRB(50, 0, 0, 0),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       Container(
                          //         height: 20,
                          //       ),
                          //       Container(
                          //         child: Text(
                          //           userChatController.messages[widget.i]
                          //               .dateMsg!, style: TextStyle(
                          //             color: Get.isDarkMode
                          //                 ? Colors.white
                          //                 : Colors.black,
                          //             fontSize: 12
                          //         ),),
                          //       ),
                          //       Container(
                          //
                          //         width: MediaQuery
                          //             .of(context)
                          //             .size
                          //             .width * 0.7,
                          //         height: 1.50, color: Colors.black45
                          //           .withOpacity(0.10),
                          //         // child: Text( userChatController.messages[widget.i].dateMsg!),
                          //       ),
                          //       Container(
                          //         height: 20,
                          //       )
                          //
                          //     ],
                          //   ),
                          // )
                          //
                          //     : Container(),

                          Row(
                            children: [
                              SizedBox(width: 2,),
                              userChatController.selectedType == 'Group'
                                  ? userChatController.messages[widget.i]
                                  .senderId == LocalStorage.ADMINID ||
                                  userChatController.messages[widget.i]
                                      .msgType == "Activity"
                                  ? Container()
                                  : Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: userChatController
                                        .messages[widget.i].msgType != "Video" ?
                                    BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15)) :
                                    BorderRadius.circular(0),
                                    border: Border.all(
                                        color: Colors.grey, width: 0.2),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          userChatController.messages[widget
                                              .i].profileIcon!),
                                    )),
                              )
                                  : Container(),
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width * .6,
                                ),

                                decoration: userChatController
                                    .messages[widget.i].msgType ==
                                    "Activity" ?
                                BoxDecoration(
                                  color: Get.isDarkMode ? Colors.white : Colors
                                      .grey.withOpacity(0.10),
                                  borderRadius: userChatController
                                      .messages[widget.i].msgType != "Video" ?
                                  BorderRadius.only(
                                    topRight: Radius.circular(25),
                                    topLeft: Radius.circular(25),
                                    bottomLeft: Radius.circular(25),
                                    bottomRight: Radius.circular(25),
                                  ) : BorderRadius.circular(0),
                                ) :
                                userChatController.messages[widget.i]
                                    .senderId == LocalStorage.ADMINID
                                    ? BoxDecoration(
                                  color: userChatController.messages[widget
                                      .i].msgType ==
                                      "Four Image" ||
                                      userChatController.messages[widget.i]
                                          .msgType ==
                                          "Audio"
                                      ? Colors.transparent
                                      : userChatController.messages[widget
                                      .i].msgType!.contains(
                                      "Reply") ?
                                       Color(0xff4a4a7d)
                                      : Color(0xFF188D1E),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    bottomLeft: Radius.circular(25),
                                    bottomRight: Radius.circular(25),
                                  ),
                                )
                                    : BoxDecoration(
                                    color: userChatController
                                        .messages[widget.i].msgType ==
                                        "Four Image" ||
                                        userChatController.messages[widget
                                            .i].msgType ==
                                            "Audio"
                                        ? Colors.transparent
                                        : Color(0xff18181c),
                                    /*  : userChatController.messages[widget.i].msgType.contains("Reply")?
                                          Colors.transparent: Color(0xffe8eaf6),*/
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(25),
                                      bottomLeft: Radius.circular(25),
                                      bottomRight: Radius.circular(25),
                                    )
                                ),
                                child: userChatController.messages[widget.i]
                                    .msgType == "text"
                                    ? ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.7,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: currentMessage.senderId ==
                                          LocalStorage.ADMINID
                                          ? Colors.blue
                                          : Colors.green,
                                      borderRadius: currentMessage.senderId ==
                                          LocalStorage.ADMINID ?
                                      BorderRadius.only(
                                        topLeft: isFirstInGroup ? Radius
                                            .circular(8) : Radius.circular(8),
                                        topRight: isFirstInGroup ? Radius
                                            .circular(0) : Radius.circular(0),
                                        bottomLeft: isFirstInGroup ? Radius
                                            .circular(8) : Radius.circular(8),
                                        bottomRight: isFirstInGroup ? Radius
                                            .circular(8) : Radius.circular(8),
                                      ) :
                                      BorderRadius.only(
                                        topLeft: isFirstInGroup ? Radius
                                            .circular(0) : Radius.circular(0),
                                        topRight: isFirstInGroup ? Radius
                                            .circular(8) : Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: currentMessage.messageText!,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " ${currentMessage.hr}",
                                            style: TextStyle(
                                              color: Get.isDarkMode ? Colors
                                                  .white : Colors.black54,
                                              fontSize: 10,
                                            ),
                                          ),
                                          if (currentMessage.senderId ==
                                              LocalStorage.ADMINID)
                                            WidgetSpan(
                                              child: Icon(
                                                currentMessage.seenStatus == "Seen"
                                                    ? Icons.done_all
                                                    : Icons.done,
                                                color: currentMessage.seenStatus == "Seen"
                                                    ? Colors.yellow
                                                    : Colors.grey,
                                                size: 15,
                                              ),
                                            ),
                                        ],
                                      ),
                                    )
                                    ,
                                  ),
                                )
                                    : userChatController.messages[widget.i]
                                    .msgType == "Poll"
                                    ? showPollAsMessage(userChatController.messages[widget.i].messageText,userChatController.messages[widget.i].id!)
                                    : userChatController.messages[widget.i]
                                    .msgType ==
                                    "Image" ?
                                    InkWell(
                                  onTap: () {
                                    print('${WebApi.basesUrl}' +
                                        userChatController
                                            .messages[widget.i]
                                            .messageText
                                            .toString()
                                            .substring(2));
                                    _downloadImage('${WebApi.basesUrl}' +
                                        userChatController
                                            .messages[widget.i]
                                            .messageText
                                            .toString()
                                            .substring(2));

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content:Container(
                                            height: 200,
                                            width: 150,
                                            child: Image.network(
                                                '${WebApi.basesUrl}' +
                                                    userChatController
                                                        .messages[widget.i]
                                                        .messageText
                                                        .toString()
                                                        .substring(2)),
                                          )

                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                      child:InkWell(
                                          child:
                                          Container(
                                            width: 200.0,
                                            height: 200.0,
                                            margin:
                                            EdgeInsets
                                                .all(
                                                3),
                                            child:

                              // For web, use Image.network for network images
                               Image.network('${WebApi.basesUrl}' +
                              userChatController
                                  .messages[widget.i]
                                  .messageText
                                  .toString()
                                  .substring(2))
                                          ))

                                  ),
                                )
                                    : userChatController.messages[widget.i]
                                    .msgType ==
                                    "Multi-Image"
                                    ? Container(
                                  height: Get.height*0.30,
                                  width: Get.width*0.15,
                                  child: userChatController.messages[widget
                                      .i].showRunTime == "Yes"
                                      ? InkWell(
                                    onTap: () {

                                    },
                                    child:
                                    // isFourPlusImageDownload2==false?
                                    Container(
                                        height: Get.height*0.20,
                                        width: Get.width*0.15,
                                        child: GridView
                                            .builder(
                                            itemCount: (userChatController
                                                .messages.length >= 4)
                                                ? 4
                                                : userChatController
                                                .messages
                                                .length,
                                            shrinkWrap:
                                            true,
                                            scrollDirection: Axis
                                                .vertical,
                                            physics:
                                            NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                              2,
                                            ),
                                            itemBuilder:
                                                (ctx, index) {
                                              multipleImageList =
                                                  userChatController
                                                      .messages[widget.i]
                                                      .messageText;
                                              var groupImage =
                                              userChatController
                                                  .messages[widget.i]
                                                  .messageText!
                                                  .split(
                                                  ",");
                                              return ImageItemFourPlus(
                                                  "${groupImage[index + 1]
                                                      .toString()}",
                                                  '${WebApi.basesUrl}' +
                                                      groupImage[index + 1],
                                                  index,
                                                  groupImage.length,
                                                  groupImage,
                                                  userChatController
                                                      .messages[widget.i]
                                                      .showRunTime!,
                                                  "RunTimeImage");
                                            })),
                                  )
                                      : userChatController.loadNetworkImageForGroup(
                                      userChatController.messages[widget.i]
                                          .messageText) == true
                                      ? Container(
                                      height: Get.height*0.30,
                                      width: Get.width*0.15,
                                      child: GridView.builder(
                                          itemCount: (userChatController
                                              .messages.length > 4)
                                              ? 4
                                              : userChatController.messages
                                              .length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          physics: NeverScrollableScrollPhysics(),
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                            2,
                                          ),
                                          itemBuilder: (ctx, index) {
                                            multipleImageList =
                                                userChatController
                                                    .messages[widget.i]
                                                    .messageText;
                                            var groupImage = userChatController
                                                .messages[
                                            widget
                                                .i]
                                                .messageText!
                                                .split(
                                                ",");
                                            return ImageItemFourPlus(
                                                "${groupImage[index + 1]
                                                    .toString()}",
                                                '${WebApi.basesUrl}' +
                                                    groupImage[index + 1]
                                                        .toString()
                                                        .substring(
                                                        2),
                                                index,
                                                groupImage
                                                    .length,
                                                groupImage,
                                                userChatController
                                                    .messages[widget.i]
                                                    .showRunTime!,
                                                "ImageExist");
                                          }))
                                      : InkWell(
                                      onTap: () {

                                        userChatController.saveGroupImage(
                                            userChatController
                                                .messages[widget
                                                .i]
                                                .messageText);

                                      },
                                      child: Container(
                                          height: Get.height*0.20,
                                          width: Get.width*0.15,

                                          child: GridView.builder(
                                              itemCount: (userChatController
                                                  .messages.length >
                                                  4)
                                                  ? 4
                                                  : userChatController
                                                  .messages.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis
                                                  .vertical,
                                              physics: NeverScrollableScrollPhysics(),
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                              ),
                                              itemBuilder: (ctx, index) {
                                                multipleImageList =
                                                    userChatController
                                                        .messages[widget.i]
                                                        .messageText;
                                                var groupImage = userChatController
                                                    .messages[widget
                                                    .i].messageText!.split(
                                                    ",");
                                                return ImageItemFourPlus(
                                                    "${groupImage[index + 1]
                                                        .toString()}",
                                                    '${WebApi.basesUrl}' +
                                                        groupImage[index +
                                                            1],
                                                    index,
                                                    groupImage.length,
                                                    groupImage,
                                                    userChatController
                                                        .messages[widget.i]
                                                        .showRunTime!,
                                                    "RunTimeImage");
                                              }))
                                  ),
                                )
                                    : userChatController.messages[widget.i]
                                    .msgType ==
                                    "Four Image"
                                    ? InkWell(
                                  child: Container(
                                      height: Get.height*0.30,
                                      width: Get.width*0.15,
                                      child: GridView.builder(
                                          itemCount:
                                          (userChatController.messages
                                              .length > 4)
                                              ? 4
                                              : userChatController.messages
                                              .length,
                                          shrinkWrap: true,
                                          scrollDirection:
                                          Axis.vertical,
                                          physics:
                                          NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                          ),
                                          itemBuilder:
                                              (ctx, index) {
                                            multipleImageList =
                                                userChatController
                                                    .messages[widget.i]
                                                    .messageText;
                                            var groupImage = userChatController
                                                .messages[
                                            widget.i]
                                                .messageText!
                                                .split(
                                                ",");
                                            return ImageItem(
                                                "${groupImage[index + 1]
                                                    .toString()}",
                                                '${WebApi.basesUrl}' +
                                                    groupImage[
                                                    index +
                                                        1]
                                                        .toString()
                                                        .substring(
                                                        2),
                                                index,
                                                groupImage.length,
                                                userChatController
                                                    .messages[widget.i]
                                                    .showRunTime,
                                                groupImage);
                                          })),
                                )
                                    : userChatController.messages[widget.i]
                                    .msgType ==
                                    "Audio"
                                    ? Container(
                                  
                                  child: Text('An audio message. Use app for hearing'),
                                )
                                    : userChatController.messages[widget.i].msgType == "File" ?
                                InkWell(
                                  onTap: () async {
                                    downloadFile('${WebApi.basesUrl}' +
                                        userChatController
                                            .messages[widget.i]
                                            .messageText
                                            .toString()
                                            .substring(2));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*0.20,
                                    child: checkFileType(
                                        userChatController.messages[
                                        widget
                                            .i]),
                                  ),
                                )
                                    : userChatController.messages[widget.i]
                                    .msgType!.contains(
                                    "forward text") ?
                                userChatController.messages[widget.i]
                                    .senderId ==
                                    LocalStorage.ADMINID ?
                                Container(
                                  width: Get.width*0.15,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(width: 5,),

                                          Icon(Icons.forward_5,
                                              color: Get.isDarkMode
                                                  ? Colors.white
                                                  : Colors.white),
                                          Text('Forwarded', style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Get.isDarkMode
                                                  ? Colors.white
                                                  : Colors.white

                                          ),),
                                        ],
                                      ),
                                      Divider(
                                        color: Get.isDarkMode
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      Container(
                                        width: Get.width*0.15,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.only(
                                            top: 7.0,
                                            left: 20,
                                            bottom: 7,
                                            right: 7),
                                        child: Text(
                                          "${userChatController
                                              .messages[widget.i].messageText}",
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .bodyText1!
                                              .apply(
                                            color: (userChatController
                                                .messages[widget.i]
                                                .senderId ==
                                                LocalStorage.ADMINID)
                                                ? Colors.white
                                                : Colors.black87,
                                          ), textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                                ) :
                                Container(
                                  width: Get.width*0.15,
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.circular(15.0),
                                  // ),
                                  child: Column(
                                    children: [



                                      userChatController.messages[widget.i]
                                          .msgType ==
                                          'forward reply text' ?
                                      Container(

                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "${userChatController
                                              .messages[widget.i].messageText}",
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .bodyText1!
                                              .apply(
                                            color: (userChatController
                                                .messages[widget.i]
                                                .senderId ==
                                                LocalStorage.ADMINID)
                                                ? Colors.white
                                                : Colors.white,
                                          ), textAlign: TextAlign.left,
                                        ),
                                      )
                                          :
                                      userChatController.messages[widget.i]
                                          .msgType ==
                                          'forward text' ?
                                      Container(
                                        width: Get.width*0.15,
                                        padding: EdgeInsets.all(5),
                                        child: Container(
                                          width: Get.width*0.15,
                                          child: Card(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.forward_5),
                                                    Text('Forwarded',
                                                      style: TextStyle(
                                                          color: Get.isDarkMode
                                                              ? Colors.white
                                                              : Colors.black
                                                      ),)
                                                  ],
                                                ),
                                                Text(
                                                  "${userChatController
                                                      .messages[widget.i]
                                                      .messageText}",
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .apply(
                                                    color: (userChatController
                                                        .messages[widget.i]
                                                        .senderId ==
                                                        LocalStorage.ADMINID)
                                                        ? Colors.white
                                                        : Get.isDarkMode?Colors.white:Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ) :
                                      userChatController.messages[widget.i]
                                          .msgType ==
                                          'forward Image' ?
                                      InkWell(
                                        onTap: () {
                                          var imagelistSingle =
                                          [];
                                          imagelistSingle.add(
                                              userChatController
                                                  .messages[widget.i]
                                                  .messageText
                                                  .toString());
                                          /*       Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    GalleryDemo(
                                                        groupImage:
                                                        imagelistSingle)));*/
                                        },
                                        child: Container(
                                            child: userChatController
                                                .messages[widget
                                                .i]
                                                .showRunTime ==
                                                "Yes"
                                                ? InkWell(
                                                child:
                                                Container(
                                                  width: 200.0,
                                                  height: 200.0,
                                                  margin:
                                                  EdgeInsets
                                                      .all(
                                                      3),
                                                  decoration:
                                                  BoxDecoration(
                                                    borderRadius: (userChatController
                                                        .messages[widget
                                                        .i].senderId !=
                                                        LocalStorage.ADMINID)
                                                        ? BorderRadius
                                                        .only(
                                                      topRight:
                                                      Radius.circular(25),
                                                      bottomLeft:
                                                      Radius.circular(25),
                                                      bottomRight:
                                                      Radius.circular(25),
                                                    )
                                                        : BorderRadius
                                                        .only(
                                                      topLeft:
                                                      Radius.circular(25),
                                                      bottomLeft:
                                                      Radius.circular(25),
                                                      bottomRight:
                                                      Radius.circular(25),
                                                    ),
                                                    //color: Colors.redAccent,

                                                    image:
                                                    DecorationImage(
                                                      // image: AssetImage(image),
                                                      image: NetworkImage(
                                                          '${WebApi.basesUrl}' +
                                                              userChatController
                                                                  .messages[widget
                                                                  .i]
                                                                  .messageText
                                                                  .toString()
                                                                  .substring(
                                                                  2)),

                                                      fit: BoxFit
                                                          .cover,
                                                    ),
                                                  ),
                                                ))
                                                : loadNetworkImage(
                                                userChatController
                                                    .messages[widget.i]
                                                    .messageText) ==
                                                true
                                                ? Container(
                                              width:
                                              200.0,
                                              height:
                                              200.0,
                                              decoration:
                                              BoxDecoration(
                                                borderRadius: (userChatController
                                                    .messages[widget
                                                    .i]
                                                    .senderId !=
                                                    LocalStorage.ADMINID)
                                                    ? BorderRadius.only(
                                                  topRight: Radius.circular(25),
                                                  bottomLeft: Radius.circular(
                                                      25),
                                                  bottomRight: Radius.circular(
                                                      25),
                                                )
                                                    : BorderRadius.only(
                                                  topLeft: Radius.circular(25),
                                                  bottomLeft: Radius.circular(
                                                      25),
                                                  bottomRight: Radius.circular(
                                                      25),
                                                ),
                                                image:
                                                DecorationImage(
                                                  image:
                                                  FileImage(File(
                                                      '/storage/emulated/0/AslChat/' +
                                                          userChatController
                                                              .messages[widget
                                                              .i]
                                                              .messageText
                                                              .toString()
                                                              .substring(
                                                              userChatController
                                                                  .messages[widget
                                                                  .i]
                                                                  .messageText
                                                                  .toString()
                                                                  .indexOf(
                                                                  'ImageData/') +
                                                                  10))),
                                                  fit: BoxFit
                                                      .cover,
                                                  // colorFilter: ColorFilter.mode(
                                                  //     Colors.grey.withOpacity(0.25),
                                                  //     BlendMode.dstATop)
                                                ),
                                              ),
                                            )
                                                : Container(
                                                child:
                                                InkWell(
                                                  onTap:
                                                      () {
                                                    print(
                                                        'hit network ');
                                                    userChatController.checkImageSave(
                                                        userChatController
                                                            .messages[widget.i]
                                                            .messageText,
                                                        userChatController
                                                            .messages[widget.i]
                                                            .msgType);
                                                  },
                                                  child:
                                                  Container(
                                                    width:
                                                    200.0,
                                                    height:
                                                    200.0,
                                                    margin:
                                                    EdgeInsets.all(3),
                                                    decoration:
                                                    BoxDecoration(
                                                      borderRadius: (userChatController
                                                          .messages[widget
                                                          .i].senderId !=
                                                          LocalStorage.ADMINID)
                                                          ? BorderRadius.only(
                                                        topRight: Radius
                                                            .circular(
                                                            25),
                                                        bottomLeft: Radius
                                                            .circular(
                                                            25),
                                                        bottomRight: Radius
                                                            .circular(25),
                                                      )
                                                          : BorderRadius.only(
                                                        topLeft: Radius
                                                            .circular(
                                                            25),
                                                        bottomLeft: Radius
                                                            .circular(
                                                            25),
                                                        bottomRight: Radius
                                                            .circular(25),
                                                      ),
                                                      // color: Colors.redAccent,

                                                      image:
                                                      DecorationImage(
                                                        // image: AssetImage(image),
                                                        image: NetworkImage(
                                                            '${WebApi.basesUrl}' +
                                                                userChatController
                                                                    .messages[widget
                                                                    .i]
                                                                    .messageText
                                                                    .toString()
                                                                    .substring(
                                                                    2)),

                                                        fit:
                                                        BoxFit.cover,
                                                      ),
                                                    ),

                                                  ),
                                                ))),
                                      )
                                          : userChatController
                                          .messages[widget.i].msgType ==
                                          'forward Four Image' ?
                                      InkWell(

                                        child: Container(
                                            child: GridView.builder(
                                                itemCount:
                                                (userChatController.messages
                                                    .length > 4)
                                                    ? 4
                                                    : userChatController
                                                    .messages.length,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                Axis.vertical,
                                                physics:
                                                NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                ),
                                                itemBuilder:
                                                    (ctx, index) {
                                                  multipleImageList =
                                                      userChatController
                                                          .messages[widget.i]
                                                          .messageText;
                                                  var groupImage = userChatController
                                                      .messages[
                                                  widget.i]
                                                      .messageText!
                                                      .split(
                                                      ",");
                                                  return ImageItem(
                                                      "${groupImage[index + 1]
                                                          .toString()}",
                                                      '${WebApi.basesUrl}' +
                                                          groupImage[
                                                          index +
                                                              1]
                                                              .toString()
                                                              .substring(
                                                              2),
                                                      index,
                                                      groupImage.length,
                                                      userChatController
                                                          .messages[widget.i]
                                                          .showRunTime,
                                                      groupImage);
                                                })),
                                      )
                                          : userChatController
                                          .messages[widget.i].msgType ==
                                          'forward Multi-Image' ?
                                      Container(
                                        child: userChatController
                                            .messages[widget.i].showRunTime ==
                                            "Yes"
                                            ? InkWell(
                                          child:
                                          // isFourPlusImageDownload2==false?
                                          Container(
                                              child: GridView
                                                  .builder(
                                                  itemCount: (userChatController
                                                      .messages.length >
                                                      4)
                                                      ? 4
                                                      : userChatController
                                                      .messages
                                                      .length,
                                                  shrinkWrap:
                                                  true,
                                                  scrollDirection: Axis
                                                      .vertical,
                                                  physics:
                                                  NeverScrollableScrollPhysics(),
                                                  gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount:
                                                    2,
                                                  ),
                                                  itemBuilder:
                                                      (ctx, index) {
                                                    multipleImageList =
                                                        userChatController
                                                            .messages[widget.i]
                                                            .messageText;
                                                    var groupImage =
                                                    userChatController
                                                        .messages[widget.i]
                                                        .messageText!
                                                        .split(",");
                                                    return ImageItemFourPlus(
                                                        "${groupImage[index + 1]
                                                            .toString()}",
                                                        '${WebApi.basesUrl}' +
                                                            groupImage[index +
                                                                1]
                                                                .toString()
                                                                .substring(2),
                                                        index,
                                                        groupImage.length,
                                                        groupImage,
                                                        userChatController
                                                            .messages[widget.i]
                                                            .showRunTime!,
                                                        "RunTimeImage");
                                                  })),
                                        )
                                            : userChatController.loadNetworkImageForGroup(
                                            userChatController
                                                .messages[widget.i]
                                                .messageText) ==
                                            true
                                            ? Container(
                                            child: GridView.builder(
                                                itemCount: (userChatController
                                                    .messages.length > 4)
                                                    ? 4
                                                    : userChatController
                                                    .messages.length,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                physics: NeverScrollableScrollPhysics(),
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount:
                                                  2,
                                                ),
                                                itemBuilder: (ctx, index) {
                                                  multipleImageList =
                                                      userChatController
                                                          .messages[widget.i]
                                                          .messageText;
                                                  var groupImage = userChatController
                                                      .messages[
                                                  widget
                                                      .i]
                                                      .messageText!
                                                      .split(
                                                      ",");
                                                  return ImageItemFourPlus(
                                                      "${groupImage[index + 1]
                                                          .toString()}",
                                                      '${WebApi.basesUrl}' +
                                                          groupImage[index + 1]
                                                              .toString()
                                                              .substring(
                                                              2),
                                                      index,
                                                      groupImage
                                                          .length,
                                                      groupImage,
                                                      userChatController
                                                          .messages[widget.i]
                                                          .showRunTime!,
                                                      "ImageExist");
                                                }))
                                            : InkWell(
                                            onTap: () {

                                              userChatController.saveGroupImage(
                                                  userChatController
                                                      .messages[widget
                                                      .i]
                                                      .messageText);
                                              // checkImageSave(widget.image,"Image")
                                            },
                                            child: Container(
                                                child: Container(
                                                    child: GridView.builder(
                                                        itemCount: (userChatController
                                                            .messages
                                                            .length > 4)
                                                            ? 4
                                                            : userChatController
                                                            .messages.length,
                                                        shrinkWrap: true,
                                                        scrollDirection: Axis
                                                            .vertical,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                        ),
                                                        itemBuilder: (ctx,
                                                            index) {
                                                          multipleImageList =
                                                              userChatController
                                                                  .messages[widget
                                                                  .i]
                                                                  .messageText;
                                                          var groupImage = userChatController
                                                              .messages[widget
                                                              .i].messageText!
                                                              .split(
                                                              ",");
                                                          return ImageItemFourPlus(
                                                              "${groupImage[index +
                                                                  1]
                                                                  .toString()}",
                                                              '${WebApi.basesUrl}' +
                                                                  groupImage[index +
                                                                      1]
                                                                      .toString()
                                                                      .substring(
                                                                      2),
                                                              index,
                                                              groupImage.length,
                                                              groupImage,
                                                              userChatController
                                                                  .messages[widget
                                                                  .i]
                                                                  .showRunTime!,
                                                              "RunTimeImage");
                                                        })))
                                        ),
                                      )
                                          : userChatController
                                          .messages[widget.i].msgType ==
                                          'forward Audio' ?
                                      Container(
                                        child: Text('One audio forwarded. See in app version'),
                                      )

                                          : userChatController
                                          .messages[widget.i].msgType ==
                                          'forward File' ?
                                      Container(
                                        child: checkFileType(
                                            userChatController.messages[
                                            widget
                                                .i]),
                                      )
                                          : Container()
                                    ],
                                  ),
                                )
                                    : userChatController.messages[widget.i]
                                    .msgType!.contains(
                                    "reply") ?
                                replyDesign()
                                    : userChatController.messages[widget.i]
                                    .msgType == "Activity"
                                    ? Container(
                                  width: Get.width*0.20,
                                  alignment: Alignment.center,
                                  constraints: BoxConstraints(
                                      maxWidth: MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          .6),
                                  padding: const EdgeInsets.only(
                                      top: 7.0,
                                      left: 15,
                                      bottom: 7,
                                      right: 10),
                                  child: Text(
                                      "${userChatController.messages[widget
                                          .i].messageText}",
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText1!
                                          .apply(
                                        color: Colors.black87,
                                      )),
                                )
                                    : Container(
                                  child: Text('You have no chat!'),
                                ),
                              ),

                            ],
                          ),
                          // userChatController.messages[widget.i].senderId == LocalStorage.ADMINID ?
                          // Container(
                          //     child:
                          //     userChatController.messages[widget.i].seenStatus == "Unseen"
                          //         ? Text(
                          //       "Delivered",
                          //       style: TextStyle(
                          //           color: Colors.grey,
                          //           fontSize: 10
                          //       ),
                          //     ) :
                          //     Text(
                          //       "Seen",
                          //       style: TextStyle(
                          //           color: Colors.grey,
                          //           fontSize: 10
                          //       ),
                          //     )
                          //
                          // ) :
                          // Container(),
                        ])
                  ],
                ) :
                Container(
                  height: 0,
                ),
              ],
            ))


    );
  }

  // Function to extract votes from the votes line
  Map<String, dynamic> extractVotes(String votesLine) {
    return jsonDecode(votesLine);
  }

// Function to extract voter IDs from the votersId line
  List<String> extractVoterIds(String votersIdLine) {
    return jsonDecode(votersIdLine);
  }

  Widget showPollAsMessage(String? messageText, String messageId) {

    if (messageText == null) return Container();

    // Split the message into lines
    List<String> lines = messageText.split('\n');

    // Extract the question from the first line
    String question = lines[0].substring('Question: '.length);

    // Extract the options from the second line
    List<String> options = lines[1].substring('Options: '.length).split(', ');

    // Initialize votes and voters' IDs maps
    Map<String, dynamic> votes = {};
    List<String> votersId = [];

    // Extract the votes and voters' IDs if available
    if (lines.length > 2) {
      String votesLine = lines[2].substring('Votes: '.length);
      votes = extractVotes(votesLine);
    }

    // Extract the voter IDs if available
    if (lines.length > 3) {
      String votersIdLine = lines[3].substring('VotersId: '.length);
      votersId = extractVoterIds(votersIdLine);
    }

    // Create a Poll object
    Poll poll = Poll(
      question: question,
      options: options,
      votes: votes,
      votersId: votersId,
    );

    void handleVote(String selectedOption) {
      // Handle the vote, for example, by sending it to the server
      print('Voted for option: $selectedOption');
      // Call the function to update the poll message
      groupController.updatePollMessage(
        messageText,
        selectedOption,
        LocalStorage.ADMINID,
        messageId,
      );
    }

    // Determine the voted option (if any)
    String? votedOption;
    if (votes.isNotEmpty) {
      votedOption = votes.entries.firstWhere((entry) => entry.value['voterIds'].contains(LocalStorage.ADMINID),
          orElse: () => MapEntry('', {'voterIds': [], 'count': 0})).key;
    }

    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.30,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.30,
      ),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: Offset(0, -1),
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 7.0, left: 15, bottom: 7, right: 10),
      child: PollOptionsContainer(
        poll: poll,
        votedOption: votedOption,
        onVote: handleVote,
      ),
    );
  }
  var typeFile;
  checkFileType(fileData) {
    print(userChatController.messages[widget.i].fileSize);
    var dlFileName = userChatController.messages[widget.i].messageText;
    // var dlFileName = 'Filenamefordelfilename';
    var fileSize = userChatController.messages[widget.i].fileSize;

    // print("file name length : ${dlFileName.toString().length}");
    var name = dlFileName.toString();
    if (name.contains('.zip')) {
      typeFile = "assets/fileType/zip.png";
    } else if (name.contains('.pdf')) {
      //typeFile = 'assets/ImageData/myFiles-Image1614767099012.png';
      typeFile = "assets/fileType/pdf.png";
    }
    else if (name.contains('.mp4')) {
      //typeFile = 'assets/ImageData/myFiles-Image1614767099012.png';
      typeFile = "assets/fileType/defaultFile.png";
    }
    else if (name.contains('.jpg')) {
      //typeFile = 'assets/ImageData/myFiles-Image1614767099012.png';
      typeFile = "assets/fileType/defaultFile.png";
    } else if (name.contains('.docx') || name.contains('.doc')) {
      typeFile = "assets/fileType/doc.png";
      // typeFile = 'assets/ImageData/file-Image1607323306786.png';
    } else if (name.contains('.rar')) {
      typeFile = 'image/SVG/RAR-file-format.svg';
    } else if (name.contains('.xls') || name.contains('.xlsx')) {
      typeFile = 'image/SVG/XLSX-file-format.svg';
    } else if (name.contains('.pptx') || name.contains('.ppt')) {
      // typeFile = 'image/SVG/PPTX-file-format.svg';
      typeFile = "assets/fileType/ppt.png";
    } else if (name.contains('.txt')) {
      // typeFile = 'assets/ImageData/file-Image1609841783794.png';
      typeFile = "assets/fileType/txt.png";
    } else if (name.contains('.apk')) {
      typeFile = 'image/SVG/apk-file-format.svg';
    } else if (name.contains('.html')) {
      typeFile = 'image/SVG/HTML-file-format.svg';
    } else if (name.contains('.psd')) {
      typeFile = 'image/SVG/ps-file-format.svg';
    } else {
      // typeFile = 'image/SVG/file-file-format.svg';
      typeFile = "assets/fileType/defaultFile.png";
    }
    return userChatController.messages[widget.i].senderId == LocalStorage.ADMINID ?

    Card(
        color: Colors.white38,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child:
        Container(

            decoration: BoxDecoration(

                borderRadius: BorderRadius.all(Radius.circular(20))
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Stack(
                //   children: [
                //     Container(
                //       width: 40,
                //       height: 40,
                //       child: SfPdfViewer.network("https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf"),
                //     ),
                //     Container(
                //       width: 50.0,
                //       height: 50.0,
                //       decoration: BoxDecoration(
                //         image: DecorationImage(
                //             fit: BoxFit.cover, image: AssetImage(typeFile)),
                //         borderRadius:
                //         BorderRadius.only(
                //           topLeft: Radius.circular(15),
                //           bottomLeft: Radius.circular(15),
                //           bottomRight: Radius.circular(15),
                //         ),
                //         color: Colors.white70,
                //       ),
                //     ),
                //   ],
                // ),

                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover, image: AssetImage(typeFile)),
                        borderRadius:
                        BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        color: Colors.white70,
                      ),
                      child: Icon(Icons.download_for_offline,color: Colors.brown,),
                    ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 20,
                      width: 150,
                      decoration: BoxDecoration(

                        shape: BoxShape.rectangle,
                        color: Colors.transparent,
                      ),
                      child: Text(
                        dlFileName
                            .toString()
                            .split('/')
                            .last
                            .substring(dlFileName!.length - 30),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 20,
                          width: 100,
                          decoration: BoxDecoration(

                            shape: BoxShape.rectangle,
                            color: Colors.transparent,
                          ),
                          child: Text(
                            fileSize!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.white

                            ),
                          ),
                        ),
                        Text('.'),
                        Container(
                          alignment: Alignment.center,
                          height: 20,
                          width: 50,
                          decoration: BoxDecoration(

                            shape: BoxShape.rectangle,
                            color: Colors.transparent,
                          ),
                          child: Text(
                            dlFileName
                                .toString()
                                .split('.')
                                .last
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.white

                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ))


    ) :
    Card(
        color: Colors.white60,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(

            decoration: BoxDecoration(

                borderRadius: BorderRadius.all(Radius.circular(20))
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, image: AssetImage(typeFile)),
                    borderRadius:
                    BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    color: Colors.white70,
                  ),
                ),

                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 20,
                      width: 150,
                      decoration: BoxDecoration(

                        shape: BoxShape.rectangle,
                        color: Colors.transparent,
                      ),
                      child: Text(
                        dlFileName
                            .toString()
                            .split('/')
                            .last
                            .substring(dlFileName!.length - 30),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 20,
                          width: 100,
                          decoration: BoxDecoration(

                            shape: BoxShape.rectangle,
                            color: Colors.transparent,
                          ),
                          child: Text(
                            fileSize!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black

                            ),
                          ),
                        ),
                        Text('.'),
                        Container(
                          alignment: Alignment.center,
                          height: 20,
                          width: 50,
                          decoration: BoxDecoration(

                            shape: BoxShape.rectangle,
                            color: Colors.transparent,
                          ),
                          child: Text(
                            dlFileName
                                .toString()
                                .split('.')
                                .last
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black

                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )));
  }
  void downloadFile(String url) {
    html.AnchorElement anchorElement =  new html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
  }
  Future<void> _downloadImage(url) async {
    print(url);
    await WebImageDownloader.downloadImageFromWeb(url);
  }
  var dlFileNameForTest;

  checkFileTypeForReply(fileData) {
    var dlFileName = userChatController.messages[widget.i].msgReply!;
    // var dlFileName = 'Filenamefordelfilename';
    var fileSize = fileData.fileSize;
    // print("file name length : ${dlFileName.toString().length}");
    var name = dlFileName.toString()
        .substring(dlFileName
        .toString()
        .length - 5, dlFileName
        .toString()
        .length)
        .toString();
    if (name.contains('.zip')) {
      typeFile = "assets/image/zip.png";
    } else if (name.contains('.pdf')) {
      //typeFile = 'assets/ImageData/myFiles-Image1614767099012.png';
      typeFile = "assets/image/pdf.png";
    }
    else if (name.contains('.mp4')) {
      //typeFile = 'assets/ImageData/myFiles-Image1614767099012.png';
      typeFile = "assets/image/defaultFile.png";
    }
    else if (name.contains('.jpg')) {
      //typeFile = 'assets/ImageData/myFiles-Image1614767099012.png';
      typeFile = "assets/image/defaultFile.png";
    } else if (name.contains('.docx') || name.contains('.doc')) {
      typeFile = "assets/image/doc.png";
      // typeFile = 'assets/ImageData/file-Image1607323306786.png';
    } else if (name.contains('.rar')) {
      typeFile = 'image/SVG/RAR-file-format.svg';
    } else if (name.contains('.xls') || name.contains('.xlsx')) {
      typeFile = 'image/SVG/XLSX-file-format.svg';
    } else if (name.contains('.pptx') || name.contains('.ppt')) {
      // typeFile = 'image/SVG/PPTX-file-format.svg';
      typeFile = "assets/image/ppt.png";
    } else if (name.contains('.txt')) {
      // typeFile = 'assets/ImageData/file-Image1609841783794.png';
      typeFile = "assets/image/txt.png";
    } else if (name.contains('.apk')) {
      typeFile = 'image/SVG/apk-file-format.svg';
    } else if (name.contains('.html')) {
      typeFile = 'image/SVG/HTML-file-format.svg';
    } else if (name.contains('.psd')) {
      typeFile = 'image/SVG/ps-file-format.svg';
    } else {
      // typeFile = 'image/SVG/file-file-format.svg';
      typeFile = "assets/image/defaultFile.png";
    }
    return Container(

        color: Colors.tealAccent,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage(typeFile)),
                borderRadius:
                BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: Colors.orangeAccent,
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 50,
              width: 150,
              decoration: BoxDecoration(

                shape: BoxShape.rectangle,
                color: Colors.transparent,
              ),
              child: Text(
                dlFileName
                    .toString()
                    .split('-')
                    .last,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ));
  }
  final List<double> messageHeights = [];
  void scrollToMainChatMessage(int mainChatIndex) {
    // Calculate the total height of preceding messages
    // double totalHeight = 0;
    // for (int i = 0; i < mainChatIndex; i++) {
    //   totalHeight += messageHeights[i];
    // }
    double totalHeight = 0;
    for (int i = userChatController.messages.length - 1; i >
        mainChatIndex; i--) {
      totalHeight += messageHeights[i];
    }
    userChatController.scrollController.animateTo(
      totalHeight,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
  Widget replyDesign() {
    return Card(
      color: Colors.green,
      shape: userChatController.messages[widget.i].senderId == LocalStorage.ADMINID ?
      RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          //  topRight: Radius.circular(20),
        ),
      ) :
      RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          // topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),


      child: Container(
        width: Get.width*0.20,
        child: Column(
            crossAxisAlignment:
            userChatController.messages[widget.i].senderId == LocalStorage.ADMINID ?
            CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [

              Row(

                mainAxisAlignment: userChatController.messages[widget.i]
                    .senderId == LocalStorage.ADMINID ?
                MainAxisAlignment
                    .start
                    : MainAxisAlignment
                    .end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  userChatController.messages[widget.i].senderId == LocalStorage.ADMINID
                      ?
                  Row(
                    children: [
                      Icon(Icons.reply),
                      Text('Replied'),
                    ],
                  )
                      :
                  Row(
                    children: [
                      Text('Replied'),
                      Icon(Icons.reply)

                    ],
                  )
                ],
              ),
              userChatController.messages[widget.i].replyMsgType == "Poll"
                  ?
              InkWell(
                  onTap: () {
                    var replyInx = 0,
                        totalHeight = 0.0;

                    for (int inx = 0; inx <
                        userChatController.messages.length; inx++) {
                      scrollToMainChatMessage(inx);

                    }
                    totalHeight = totalHeight - itemHeights2[0];

                    print("Total: $totalHeight");
                  },
                  child: Card(
                    // padding: EdgeInsets.only(left: 250),
                    child: Container(
                      //width: MediaQuery.of(context).size.width*0.40,
                      alignment: userChatController.messages[widget.i]
                          .senderId == LocalStorage.ADMINID ?
                      Alignment.centerRight : Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: userChatController.messages[widget.i]
                            .senderId == LocalStorage.ADMINID ?
                        Color(0x61C2B7B7) :
                        Color(0xFACFD5D2),


                      ),


                      padding: const EdgeInsets.only(
                          top: 7.0,
                          left: 15,
                          bottom: 7,
                          right: 10),
                      child: Container(
                        width: Get.width*0.15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            Column(
                              children: [
                                userChatController.messages[widget.i]
                                    .senderId ==
                                    LocalStorage.ADMINID ?
                                Row(
                                  children: [
                                    Text('You', style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500
                                    ),),

                                  ],
                                ) :
                                Container(),
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.15,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${userChatController.messages[widget.i]
                                        .msgReply}",
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyText1!
                                        .apply(
                                      color: userChatController.messages[widget
                                          .i].senderId ==
                                          LocalStorage.ADMINID
                                          ? Color(0xFF797777)
                                          : Colors.black87,
                                    ), overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              )
                  : userChatController.messages[widget.i].replyMsgType == "text"
                  ?
              InkWell(
                  onTap: () {
                    var replyInx = 0,
                        totalHeight = 0.0;

                    for (int inx = 0; inx <
                        userChatController.messages.length; inx++) {
                      scrollToMainChatMessage(inx);

                    }
                    totalHeight = totalHeight - itemHeights2[0];

                    print("Total: $totalHeight");
                    // widget.scrollController.animateTo(totalHeight, duration: new Duration(seconds: 2), curve: Curves.fastOutSlowIn);


                    //widget.scrollController.jumpTo(widget.i);
                  },
                  child: Container(
                    width: Get.width*0.20,
                    //width: MediaQuery.of(context).size.width*0.40,
                    alignment: userChatController.messages[widget.i]
                        .senderId == LocalStorage.ADMINID ?
                    Alignment.centerRight : Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: userChatController.messages[widget.i]
                          .senderId == LocalStorage.ADMINID ?
                      Color(0xff194529) :
                      Color(0xFACFD5D2),


                    ),


                    padding: const EdgeInsets.only(
                        top: 7.0,
                        left: 0,
                        bottom: 7,
                        right: 10),
                    child: Container(
                      width: Get.width*0.15,
                      child: Row(
                        mainAxisAlignment:  userChatController.messages[widget.i]
                            .senderId == LocalStorage.ADMINID ?MainAxisAlignment.start:MainAxisAlignment.end,
                        children: [

                          Column(
                            crossAxisAlignment: userChatController.messages[widget.i]
                                .senderId == LocalStorage.ADMINID ?
                            CrossAxisAlignment
                                .start
                                : CrossAxisAlignment
                                .end,
                            children: [
                              userChatController.messages[widget.i]
                                  .senderId ==
                                  LocalStorage.ADMINID ?
                              Row(
                                children: [
                                  Text('You', style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500
                                  ),),

                                ],
                              ) :
                              Container(),
                              Container(
                                width: Get.width*0.10,

                                child: Text(
                                  "${userChatController.messages[widget.i]
                                      .msgReply}",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyText1!
                                      .apply(
                                    color: userChatController.messages[widget
                                        .i].senderId ==
                                        LocalStorage.ADMINID
                                        ? Colors.grey
                                        : Colors.black87,
                                  ), overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              )
                  : userChatController.messages[widget.i].replyMsgType ==
                  'Image'
                  ?
              Container(

                child: InkWell(
                  onTap: () {
                    var imagelistSingle =
                    [];
                    imagelistSingle.add(
                        userChatController.messages[widget.i]
                            .msgReply
                            .toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                GalleryDemo(
                                    groupImage:
                                    imagelistSingle)));
                  },
                  child: Row(
                    children: [
                      Container(
                          child: userChatController.messages[widget.i]
                              .showRunTime ==
                              "Yes"
                              ? InkWell(
                              child:
                              Container(
                                width: 50.0,
                                height: 50.0,
                                /*margin:
                                                          EdgeInsets
                                                              .all(
                                                              3),*/
                                decoration:
                                BoxDecoration(
                                  borderRadius: (userChatController
                                      .messages[widget.i].senderId != LocalStorage.ADMINID)
                                      ? BorderRadius
                                      .only(
                                    topRight:
                                    Radius.circular(15),
                                    bottomLeft:
                                    Radius.circular(15),
                                    bottomRight:
                                    Radius.circular(15),
                                  )
                                      : BorderRadius
                                      .only(
                                    topLeft:
                                    Radius.circular(15),
                                    bottomLeft:
                                    Radius.circular(15),
                                    bottomRight:
                                    Radius.circular(0),
                                  ),
                                  // color: Colors.redAccent,

                                  image:
                                  DecorationImage(

                                    image: NetworkImage(
                                        '${WebApi.basesUrl +
                                            userChatController.messages[widget
                                                .i].msgReply!.substring(2)}'),

                                    fit: BoxFit
                                        .cover,
                                  ),
                                ),
                              )
                          )
                              : loadNetworkImage(
                              userChatController.messages[widget.i]
                                  .msgReply) ==
                              true
                              ? Container(
                            width:
                            50.0,
                            height:
                            50.0,
                            decoration:
                            BoxDecoration(
                              borderRadius: (userChatController
                                  .messages[widget
                                  .i].senderId !=
                                  LocalStorage.ADMINID)
                                  ? BorderRadius.only(
                                topRight: Radius.circular(
                                    15),
                                bottomLeft: Radius.circular(
                                    15),
                                bottomRight: Radius
                                    .circular(15),
                              )
                                  : BorderRadius.only(
                                topLeft: Radius.circular(
                                    15),
                                bottomLeft: Radius.circular(
                                    15),
                                bottomRight: Radius
                                    .circular(0),
                              ),
                              image:
                              DecorationImage(
                                image:
                                FileImage(File(
                                    '/storage/emulated/0/AslChat/' +
                                        userChatController.messages[widget.i]
                                            .msgReply
                                            .toString()
                                            .substring(
                                            userChatController.messages[widget
                                                .i].msgReply
                                                .toString()
                                                .indexOf(
                                                'ImageData/') +
                                                10))),
                                fit: BoxFit
                                    .cover,
                                // colorFilter: ColorFilter.mode(
                                //     Colors.grey.withOpacity(0.25),
                                //     BlendMode.dstATop)
                              ),
                            ),
                          )
                              : Container(
                              child:
                              InkWell(
                                onTap:
                                    () {

                                  print(
                                      'hit network ');
                                  userChatController.checkImageSave(
                                      userChatController.messages[widget.i]
                                          .msgReply,
                                      userChatController.messages[widget.i]
                                          .msgType);
                                },
                                child:
                                Card(

                                  child: Container(
                                    width:
                                    50.0,
                                    height:
                                    50.0,
                                    /*  margin:
                                                              EdgeInsets.all(3),*/
                                    decoration:
                                    BoxDecoration(


                                      image:
                                      DecorationImage(
                                        // image: AssetImage(image),
                                        image: NetworkImage(
                                            '${WebApi.basesUrl +
                                                userChatController
                                                    .messages[widget
                                                    .i].msgReply!.substring(2)}'),
                                        fit:
                                        BoxFit.cover,
                                      ),
                                    ),

                                  ),
                                ),
                              ))),
                      Icon(Icons.image),
                      Text('Image')
                    ],
                  ),
                ),
              )
                  : userChatController.messages[widget.i].replyMsgType ==
                  "File"
                  ?
              Container(

                decoration: userChatController.messages[widget.i].senderId ==
                    LocalStorage.ADMINID ?
                BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(22),
                    topLeft: Radius.circular(22),
                  ),
                  border: Border.all(color: Colors.white),
                ) : BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                  border: Border.all(color: Colors.white),
                ),
                // child: Text(userChatController.messages[widget.i].msgReply!),
                child: checkFileTypeForReply(
                    userChatController.messages[
                    widget
                        .i]),
              )
                  : userChatController.messages[widget.i].replyMsgType ==
                  "Audio"
                  ?
              InkWell(
                  onTap: () {
                    // print(userChatController.messages[widget.i].msgReplyId);

                    var replyInx = 0,
                        totalHeight = 0.0;

                    for (int inx = 0; inx <
                        userChatController.messages.length; inx++) {
                      totalHeight = totalHeight + itemHeights2[inx];
                      print(
                          "$inx Total in loop: $totalHeight Actual: ${itemHeights2[inx]}");
                      if (userChatController.messages[inx].id ==
                          userChatController.messages[widget.i].msgReplyId) {
                        replyInx = inx;
                        /*  print("pai");
                                                              print(inx);
                                                              print(userChatController.messages[widget.i].msgReply);*/
                        break;
                      } else {
                        //print("no pai");
                      }
                    }

                    //print("Total: $totalHeight");
                    widget.scrollController.animateTo(
                        totalHeight, duration: new Duration(seconds: 2),
                        curve: Curves.fastOutSlowIn);
                    // widget.scrollController.jumpTo(totalHeight);

                    //widget.scrollController.jumpTo(20.00);
                  },
                  child: Container(
                    // padding: EdgeInsets.only(left: 250),
                    child: Container(
                        width: 130,
                        alignment: userChatController.messages[widget.i]
                            .senderId == LocalStorage.ADMINID ?
                        Alignment.centerRight : Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Color(0x61C2B7B7),
                          borderRadius: userChatController.messages[widget.i]
                              .senderId ==
                              LocalStorage.ADMINID ?
                          BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(
                                  0))
                              :
                          BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(
                                  15))
                          ,),

                        constraints: BoxConstraints(
                          maxWidth: double.infinity,
                          /*MediaQuery.of(context).size.width *
                                                .9,*/
                          maxHeight: double.infinity,
                          /*MediaQuery.of(context).size.height *
                                                .40,*/
                        ),
                        padding: const EdgeInsets.only(
                            top: 7.0,
                            left: 7,
                            bottom: 7,
                            right: 7),
                        child: Row(
                          children: [
                            Text(
                              "Attachment",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText1!
                                  .apply(
                                color: (userChatController.messages[widget.i]
                                    .senderId ==
                                    LocalStorage.ADMINID)
                                    ? Color(0xFF797777)
                                    : Colors.black87,
                              ), overflow: TextOverflow.ellipsis,
                            ),
                            Icon(Icons.attach_file)
                          ],
                        )
                    ),
                  )
              )

                  : userChatController.messages[widget.i].replyMsgType ==
                  "Multi-Image"
                  ?
              InkWell(
                child: Container(
                    width: 100,
                    height: 100,
                    padding: EdgeInsets.only(left: 20),
                    foregroundDecoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                    ),
                    child: GridView.builder(
                        itemCount:
                        (userChatController.messages.length > 4)
                            ? 4
                            : userChatController.messages.length,
                        shrinkWrap: true,
                        scrollDirection:
                        Axis.vertical,
                        physics:
                        NeverScrollableScrollPhysics(),
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder:
                            (ctx, index) {
                          multipleImageList =
                              userChatController.messages[widget.i]
                                  .msgReply;
                          var groupImage = userChatController.messages[
                          widget.i]
                              .msgReply!
                              .split(
                              ",");
                          return ImageItem(
                            "${groupImage[index + 1]
                                .toString()}",
                            '${WebApi.basesUrl}' +
                                groupImage[
                                index +
                                    1]
                                    .toString(),
                            index,
                            groupImage.length,
                            userChatController.messages[widget.i]
                                .showRunTime,
                            groupImage,);
                        })),
              ) :

              Container(),

              Container(

                alignment: Alignment.centerLeft,
                width: Get.width*0.10,
                //   color: Colors.black12,

                padding: const EdgeInsets.only(
                    top: 7.0,
                    left: 7.0,
                    bottom: 7.0,
                    right: 7.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20)
                      )
                  ),
                  child:RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: userChatController.messages[widget.i].messageText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: " ${userChatController.messages[widget.i].hr}",
                          style: TextStyle(
                            color: Get.isDarkMode ? Colors
                                .white : Colors.black54,
                            fontSize: 10,
                          ),
                        ),
                        if (userChatController.messages[widget.i].senderId ==
                            LocalStorage.ADMINID)
                          WidgetSpan(
                            child: Icon(
                              userChatController.messages[widget.i].seenStatus == "Seen"
                                  ? Icons.done_all
                                  : Icons.done,
                              color: userChatController.messages[widget.i].seenStatus == "Seen"
                                  ? Colors.yellow
                                  : Colors.grey,
                              size: 15,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),


            ]
        ),
      ),
    );
  }
}