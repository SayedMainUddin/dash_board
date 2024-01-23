import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dash_board/utils/local_storage.dart';
import 'package:dash_board/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
class ImagePreviewPage extends StatefulWidget {

  var  listOfImage;
  final String? uniqueId;
  final String? imageURL;
  final String? selectedUserType;
  final String? TypeOfSend;
  final String? orginalMsg;
  final String? orginalMsgId;
  final String? orginalMsgType;
  var testFileUploadList;
  ImagePreviewPage({Key? key, required this.uniqueId,this.imageURL,this.selectedUserType,this.listOfImage,this.testFileUploadList,this.TypeOfSend,this.orginalMsg,this.orginalMsgId,this.orginalMsgType}) : super(key: key);

  @override
  _ImagePreviewPageState createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {

  //final LocalStorage storage = new LocalStorage('asl_version2');
  ScrollController _scrollController = new ScrollController();
  bool _isVoiceOrSend = true;

  final ownUserId=LocalStorage.ADMINID;
  final user=LocalStorage.ADMINNAME;
  final userUnique=LocalStorage.ADMINID;

  var defaultBinaryMessenger;

  Future<ByteData> load(String key) async {
    final Uint8List encoded = utf8.encoder.convert(Uri(path: Uri.encodeFull(key)).path);
    final ByteData asset =
    await defaultBinaryMessenger.send('flutter/assets', encoded.buffer.asByteData());
    if (asset == null)
      throw FlutterError('Unable to load asset: $key');
    return asset;
  }



  sendMultipleImage() async{
    var imageList1=widget.listOfImage!;
    var header = {
      "Authorization":"Bearer ${LocalStorage.BearerTOKEN}"
    };
    var multipartFileSign;
    var uri = Uri.parse("${WebApi.basesUrl}/MultipleImageMulterSave");
    var request = new http.MultipartRequest("POST", uri);

    for (var file in imageList1) {
      String pathOfImage = file.path.split("/").last;
      // print('Path: ${pathOfImage}');
      //  print(pathOfImage.trim());
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      // get file length
      var length = await file.length(); //imageFile is your image file
      // multipart that takes file
      multipartFileSign = new http.MultipartFile('myFiles', stream, length, filename: pathOfImage.trim());
      request.files.add(multipartFileSign);
    }
    // multipart that takes file
    // print(multipartFileSign);
    request.headers.addAll(header);
    request.fields["UserId"] = LocalStorage.ADMINID;
    request.fields["SelectId"] = widget.uniqueId!;
    request.fields["UserType"] = widget.selectedUserType!;
    //print("${ownUserId}");
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    imageList1=[];
  }
  void sendSingleImage() async{
    var imageList1=widget.listOfImage!;

    var header = {
      "Authorization":"Bearer ${LocalStorage.BearerTOKEN}"
    };
    var multipartFileSign;
    var imagePathList;
    var uri = Uri.parse("${WebApi.basesUrl}/AttachmentSend");
    var  request = new http.MultipartRequest("POST", uri);

    for (var file in imageList1) {
      String pathOfImage = file.path.split("/").last;
      // print('Path: ${pathOfImage}');
      print(pathOfImage.trim());
      if (mounted) {
        setState(() {
          imagePathList=pathOfImage;
        });
      }
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      // get file length
      var length = await file.length(); //imageFile is your image file
      // multipart that takes file
      //multipartFileSign = new http.MultipartFile('file', stream, length, filename: pathOfImage.trim());

      if (widget.listOfImage.toString().split(',').length > 0) {
        for (var i = 0; i < widget.listOfImage
            .toString()
            .split(',')
            .length; i++) {
          multipartFileSign = new http.MultipartFile('file', stream, length, filename: widget.listOfImage[i].path.split("/").last.trim());
          //print('new wra: $multipartFileSign');
        }
      }
      request.files.add(multipartFileSign);
      //print("${ownUserId}");
      request.headers.addAll(header);

      request.fields["UserId"] = ownUserId;
      request.fields["SelectId"] = widget.uniqueId!;
      request.fields["MsgType"] = 'Image';
      request.fields["FileName"] = imagePathList;
      request.fields["UserType"] = widget.selectedUserType!;
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
      imageList1=[];
    }

    // multipart that takes file
    print(multipartFileSign);
  }
  ReplyImageSend() async {
    var imageList1=widget.listOfImage!;
    var header = {
      "Authorization":"Bearer ${LocalStorage.BearerTOKEN}"
    };
    var multipartFileSign;
    var uri = Uri.parse("${WebApi.basesUrl}/MultipleImageMulterSave");
    var request = new http.MultipartRequest("POST", uri);

    for (var file in imageList1) {
      String pathOfImage = file.path.split("/").last;
      // print('Path: ${pathOfImage}');
      //  print(pathOfImage.trim());
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      // get file length
      var length = await file.length(); //imageFile is your image file
      // multipart that takes file
      multipartFileSign = new http.MultipartFile('myFiles', stream, length, filename: pathOfImage.trim());
      request.files.add(multipartFileSign);
    }
    var msgType;
    var replyMediaType=widget.orginalMsgType;
    if (replyMediaType.toString().contains("reply")) {
      var lastFive = replyMediaType.toString().substring(replyMediaType
          .toString()
          .length - 5);
      if (lastFive.contains('text')) {
        msgType = 'reply ' + 'text';
      }
      else if (lastFive.contains('image')) {
        msgType = 'reply ' + 'image';
      }
      else if (lastFive.contains('audio')) {
        msgType = 'reply ' + 'audio';
      }
      else if (lastFive.contains('file')) {
        msgType = 'reply ' + 'file';
      }
      else if (lastFive.contains('video')) {
        msgType = 'reply ' + 'video';
      }
      else {
        msgType ='reply ' + 'text';
      }
    }
    else {
      msgType = 'reply ' + replyMediaType!;
    }
    if(imageList1.length==4){
      msgType=msgType+' Four Image ';
    }else if(imageList1.length>4){
      msgType=msgType+' multi-image';
    }
    else{
      msgType=msgType + ' image ';
    }
    print(msgType);
    request.headers.addAll(header);
    request.fields["ownUserID"] = ownUserId;
    request.fields["SelectUserID"] = widget.uniqueId!;
    request.fields["ReceiverType"] = widget.selectedUserType!;
    request.fields["OrginalMsg"] = widget.orginalMsg!;
    request.fields["replyMsgId"] = widget.orginalMsgId!;
    request.fields["MsgType"] = msgType;
    //print("${ownUserId}");
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    imageList1=[];
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
          backgroundColor: Color(0xff8ededfb),
          appBar: AppBar(
            title: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '     Image Previews',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                      fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            backgroundColor: Color(0xff8ededfb),
          ),
          body: Center(
            child: Container(
              child: PageView.builder(
                itemCount: widget.listOfImage!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Image(image: FileImage(File(widget.listOfImage![index].path.toString())));
                },
              ),
            ),
          ),
          floatingActionButton:
          FloatingActionButton(
              backgroundColor:
              Colors.black,
              child: Icon(Icons.send),
              onPressed:(){
                //    sendMultipleImage();

                if(widget.listOfImage.toString().split(',').length==1){

                  if(widget.TypeOfSend=="ReplyImage"){
                    ReplyImageSend();
                    //    print("Reply Image send");
                  }else{
                    //   print('hit single image');
                    sendSingleImage();

                  }
                }else{
                  if(widget.TypeOfSend=="ReplyImage"){
                    ReplyImageSend();
                    //  print("Reply Image send");
                  }else{
                    //   print('hit multiple image');
                    sendMultipleImage();
                  }
                }
                Navigator.of(context).pop();

              }
          ),
        ));
  }


}