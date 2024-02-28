import 'dart:convert';
import 'dart:typed_data';
import 'package:dash_board/screens/dashboard/group/group_controllers/group_controller.dart';
import 'package:dash_board/screens/dashboard/group/group_widgets/create_poll.dart';
import 'package:dash_board/screens/dashboard/user/user_controller/user_chat_controller.dart';
import 'package:dash_board/utils/urls.dart';
import 'package:dash_board/widgets/message_bubble.dart';
import 'package:dash_board/widgets/popup.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show kIsWeb;
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:dash_board/constants.dart';
import 'package:dash_board/models/ChatMessage.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/socket.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:mime/mime.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show kIsWeb;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';



class GroupChatModal extends StatefulWidget {
  final String? selectedId;
  final String? receiverName;
  final String? receiverType;


  GroupChatModal({ this.receiverName,this.receiverType,this.selectedId});

  @override
  _ChatModalState createState() => _ChatModalState();
}

class _ChatModalState extends State<GroupChatModal> {
  SocketController socketController=Get.put(SocketController());
  final TextEditingController messageController = TextEditingController();
  final UserChatController userChatController=Get.put(UserChatController());
  GroupController groupController=Get.put(GroupController());
  Future<void> sendMsgtoServer(String selectedId,String message,String receiverType,String receiverName) async {
    String datetime = DateFormat('dd/MM/yyyy hh:mm a').format(d);
    message = messageController.text;
    messageController.text = '';
    print(selectedId);
    print(receiverType);
    print(receiverName);
    print(message);
    if (message != "" || message != null) {
      messageController.clear();

      var sntData = {
        "UserId": LocalStorage.ADMINID,
        "SelectId": selectedId,
        "Message": message,
        "MsgType": "text",
        "FileName": "",
        "UserType": "group",
        "ReceiverName":receiverName,
        "SenderName":LocalStorage.ADMINNAME
      };
      socketController.socket.emit('sendMessage', sntData);
    } else {
      //print("Are You Crazy");
    }
  }

  List<ChatMessage> messages = [];
  List<XFile>? _imageFileList;

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  DateTime d = DateTime.now();
  dynamic _pickImageError;
  bool isVideo = false;
  //VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  Uint8List? fileBytes;
  bool isImage = false;
  bool isPdf = false;
  FilePickerResult? selectedFileResult;
  var typeFile='';
  bool isSentFile=false;
  bool isSentImage=false;
  var fileType;
  checkFileType(fileData) {
    // if(type=="Image"){
    //   setState(() {
    //     isSentImage=true;
    //   });
    // }else{
    //   setState(() {
    //     isSentFile=true;
    //   });
    // }

    var dlFileName = fileData;
    // var dlFileName = 'Filenamefordelfilename';


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
    return  Card(
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
                Container(
                  //   alignment: Alignment.center,
                  height: 20,
                  width: 150,
                  decoration: BoxDecoration(

                    shape: BoxShape.rectangle,
                    color: Colors.transparent,
                  ),
                  child: Text("[.${selectedFileResult!.names.toString().split(".").last}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.black
                    ),
                  ),
                ),
              ],
            )));
  }
  Future<void> pickAndPreviewFile(type) async {
    if(type=="Image"){
      setState(() {
        isSentImage=true;
        typeFile="Image";
      });
    }else{
      setState(() {
        isSentFile=true;
        typeFile="File";

      });
    }
    if (kIsWeb) {
      // On web, use FilePickerResult.fromResultUrl to get the file
      selectedFileResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg','png','jpeg', 'pdf', 'doc','docx','txt','mp3','wav','zip','aab','mp4','mov','aac','mkv','wmv','flv','webm','xls','xlss'],
      );
    } else {
      selectedFileResult = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );
    }

    if (selectedFileResult != null) {
      var file = selectedFileResult!.files.first;

      // Determine MIME type based on file extension
      String mimeType = lookupMimeType(file.name) ?? 'application/octet-stream';

      // Update preview based on MIME type
      setState(() {
        fileBytes = file.bytes;
        isImage = mimeType.startsWith('image');
        isPdf = mimeType == 'application/pdf';
      });
    }
  }
  Future<void> sendFileToServer() async {
    if (selectedFileResult != null) {
      var fileList = selectedFileResult!.files;

      for (var file in fileList) {
        if (file.size! > 26214400) {
          showAlerDialog(
            "Overflow!",
            "File Size is too large. Max file size is 25 MB",
          );
        } else {
          String pathOfImage = file.name!;

          var multipartFile = http.MultipartFile.fromBytes(
            'file',
            file.bytes!,
            filename: pathOfImage,
          );

          var request = http.MultipartRequest(
            "POST",
            Uri.parse('${WebApi.basesUrl}/AttachmentSend'),
          );

          request.headers.addAll({
            "Authorization": "Bearer ${LocalStorage.BearerTOKEN}",
          });
          request.files.add(multipartFile);
          request.fields["UserId"] = LocalStorage.ADMINID;
          request.fields["SelectId"] = widget.selectedId!;
          request.fields["MsgType"] = 'File';

          request.fields["FileName"] = pathOfImage;
          request.fields["UserType"] = "group";

          await request.send().then((response) async {
            // Listen for response
            response.stream.transform(utf8.decoder).listen((value) {});
          }).catchError((e) {
            // Handle error
            // print(e);
          });



          setState(() {
            isSentFile=false;
            fileBytes=null;
          });

          //   Get.back();
          //  toggleSuccess(context, "File sent successfully!");
        }
      }
    }
  }
  Future<void> sendImageToServer() async {
    if (selectedFileResult != null) {
      var fileList = selectedFileResult!.files;

      for (var file in fileList) {
        if (file.size! > 26214400) {
          showAlerDialog(
            "Overflow!",
            "File Size is too large. Max file size is 25 MB",
          );
        } else {
          String pathOfImage = file.name!;

          var multipartFile = http.MultipartFile.fromBytes(
            'file',
            file.bytes!,
            filename: pathOfImage,
          );

          var request = http.MultipartRequest(
            "POST",
            Uri.parse('${WebApi.basesUrl}/AttachmentSend'),
          );

          request.headers.addAll({
            "Authorization": "Bearer ${LocalStorage.BearerTOKEN}",
          });
          request.files.add(multipartFile);
          request.fields["UserId"] = LocalStorage.ADMINID;
          request.fields["SelectId"] = widget.selectedId!;
          request.fields["MsgType"] = 'Image';
          request.fields["FileName"] = pathOfImage;
          request.fields["UserType"] = "group";

          await request.send().then((response) async {
            // Listen for response
            response.stream.transform(utf8.decoder).listen((value) {});
          }).catchError((e) {
            // Handle error
            // print(e);
          });


          setState(() {
            isSentImage=false;
            fileBytes=null;
          });

          //   Get.back();
          //  toggleSuccess(context, "File sent successfully!");
        }
      }
    }
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    userChatController.selectedId.value=widget.selectedId!;
    //userChatController.selectedType.value="group";
    groupController.selectedType.value="Group";
    groupController.selectedName.value=widget.receiverName!;
    groupController.selectedId.value=widget.selectedId!;

    userChatController.ChatScreenPageReady(widget.selectedId!,"Group");
  }
  @override
  Widget build(BuildContext context) {
    // Get.lazyPut(()=>UserChatController());
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width*0.40,
        height: MediaQuery.of(context).size.width*0.40,
        //  height:          _imageFileList!.length>0 ?MediaQuery.of(context).size.height*0.70: MediaQuery.of(context).size.height*0.40,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Text(
                  'Send message to: ${widget.receiverName}',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                ),
                IconButton(onPressed: (){
                  //Get.to(()=>MyApp());
                  Navigator.pop(Get.context!);
                  userChatController.dataProcessed.value=false;
                }, icon: Icon(Icons.disabled_by_default_outlined))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_open,size: 20,),
                Text("End-to-end-encrypted",
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey
                  ),),
              ],
            ),
            Obx(() =>    Expanded(
              child: ListView.builder(
                  itemCount: userChatController.messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    if (index < userChatController.messages.length ) {
                      return InkWell(
                        onLongPress: (){
                          userChatController.showMultitaskPOPUPDialog('',index,context);
                        },
                        child: MessageWidget(
                          i: index,
                          scrollController: userChatController.scrollController,
                        ),
                      );
                    }
                    // You might want to return an empty container or null if the condition is not met.
                    return Container();

                  }
              ),
            ),),
            if(isSentFile==true||isSentImage==true)

              if (isImage)
                Container(
                  height: 200,
                  width: 300,
                  child:  Image.memory(fileBytes!),
                )

              else if (isPdf)
                Container(
                  height: 200,
                  width: 300,
                  child: SfPdfViewer.memory(
                      fileBytes!),
                ),
            Row(
              children: [
                IconButton(onPressed: (){
                  Get.dialog(CreatePollDialog(receiverType: widget.receiverType,selectedId: widget.selectedId,receiverName: widget.receiverName,));

                }, icon: Icon(Icons.playlist_add_circle_rounded)),
                IconButton(
                  icon: Icon(Icons.attach_file,color: Colors.teal,),
                  onPressed: () {
                    // pickImage();
                    pickAndPreviewFile('File');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.image,color: Colors.teal,),
                  onPressed: () {
                    pickAndPreviewFile('Image');

                    //  onImageButtonPressed(
                    //    ImageSource.gallery, "Image", "", "", "",
                    //    context: context,);
                  },
                ),
                fileBytes != null?
                Expanded(
                    child: Text("Send file to group",
                      style: TextStyle(
                          color: Colors.green
                      ),)
                ):
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
                fileBytes != null?
                IconButton(
                  icon: Icon(Icons.send,color: Colors.teal,),
                  onPressed: () {
                    if(typeFile=="Image"){
                      sendImageToServer();

                    }else{
                      sendFileToServer();

                    }
                  },
                ):
                IconButton(
                  icon: Icon(Icons.send,color: Colors.teal,),
                  onPressed: () {
                    sendMessage();
                    sendMsgtoServer(widget.selectedId!,messageController.text,widget.receiverName!,widget.receiverType!);
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

void showGroupChatModal(BuildContext context, String receiverName,String receiverId,String receiverType ) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return GroupChatModal(receiverName:  receiverName,selectedId: receiverId,receiverType: receiverType,);
    },
  );
}


