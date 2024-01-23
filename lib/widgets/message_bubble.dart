import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;

import 'dart:typed_data';
import 'package:dash_board/models/message.dart';
import 'package:dash_board/screens/dashboard/user/user_controller/user_chat_controller.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/urls.dart';
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

  String? previousDate;

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
                          userChatController.messages[widget.i]
                              .dateHeading == true ?
                          // buildMessage(widget.i),


                          Container(
                            margin: userChatController.messages[widget.i]
                                .senderId == LocalStorage.ADMINID ?
                            EdgeInsets.fromLTRB(0, 0, 50, 0) : EdgeInsets
                                .fromLTRB(50, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 20,
                                ),
                                Container(
                                  child: Text(
                                    userChatController.messages[widget.i]
                                        .dateMsg!, style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 12
                                  ),),
                                ),
                                Container(

                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.7,
                                  height: 1.50, color: Colors.black45
                                    .withOpacity(0.10),
                                  // child: Text( userChatController.messages[widget.i].dateMsg!),
                                ),
                                Container(
                                  height: 20,
                                )

                              ],
                            ),
                          )

                              : Container(),

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
                                  Color(0xff0f0f10) : Color(0xFF190B5C),
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
                                    "File"
                                    ?
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
}