import 'dart:io';

import 'package:dash_board/utils/urls.dart';
import 'package:flutter/material.dart';

List<String> grpPreviewsharedGalleryList =[];
class ImageItem extends StatefulWidget {

  final String? image;
  final String? imageNetwork;
  final int? index;
  BuildContext? context;
  final int? length;
  final String? showRunTime;
  var groupImage = [];

  ImageItem(this.image, this.imageNetwork, this.index, this.length,
      this.showRunTime, this.groupImage);

  @override
  State<StatefulWidget> createState() {
    return ImageItem2();
  }
}
//==================================== ====1: Two Image show  widget shows in chats ===========================================

class ImageItem2 extends State<ImageItem> {
  List<String> groupImageList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool? isFourImageDownload;

  @override
  Widget build(BuildContext context) {
    return InkWell(

        onTap: (widget.index == widget.index)
            ? () {
          print("show all clicked");
          groupImageList = [];
          //print(widget.groupImage.length);
          for (var i = 1; i < widget.groupImage.length; i++) {
            groupImageList.add(widget.groupImage[i]);
          }
          print("Length: ${groupImageList.length}");
          // print(image);
          /*   Navigator.push(
            context,
            // MaterialPageRoute(builder: (context)=>MyBottomBarDemo()),
            MaterialPageRoute(
                builder: (context) =>
                    GalleryDemo(
                      groupImage: groupImageList,
                    )),
            // MaterialPageRoute(builder: (context)=>FancyFab()),
          );*/
        }
            : () {
          print("image clicked");

          var imagelistSingle = [];
          imagelistSingle.add(widget.image.toString());
          /*   Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      GalleryDemo(groupImage: imagelistSingle)));*/
        },
        child:
        // loadNetworkImage()=="Yes"?
        widget.showRunTime == "Yes"
            ? Container(

          margin: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
                bottomLeft: Radius.circular(7),
                bottomRight: Radius.circular(7)),
            border: Border.all(color: Colors.grey, width: 0.4),
            image: DecorationImage(
              image: NetworkImage(widget.imageNetwork!),
              fit: BoxFit.cover,
            ),
          ),
        )
            : loadNetworkImage(widget.image) == true
            ? Container(

          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
                bottomLeft: Radius.circular(7),
                bottomRight: Radius.circular(7)),
            border: Border.all(color: Colors.grey, width: 0.4),
            image: DecorationImage(
              // image: AssetImage(image),
              image: FileImage(File(
                '/storage/emulated/0/AslChat/' +
                    widget.image.toString().substring(widget
                        .image
                        .toString()
                        .indexOf('ImageData/') +
                        10),)),
              // image: NetworkImage(imageNetwork),
              fit: BoxFit.cover,
            ),
          ),
        )
            : Container(
            child: InkWell(
              onTap: () {
                isFourImageDownload = true;
                setState(() {
                  isFourImageDownload = isFourImageDownload;
                });
                print('hit network ');
                checkImageSave(widget.image, "Image");
              },
              child: Container(

                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                      bottomLeft: Radius.circular(7),
                      bottomRight: Radius.circular(7)),
                  border: Border.all(color: Colors.grey, width: 0.4),
                  image: DecorationImage(
                    // image: AssetImage(image),
                    image: NetworkImage(widget.imageNetwork!)
                    ,
                    fit: BoxFit.cover,
                  ),
                ),
                child: isFourImageDownload == true
                    ? Container()
                    : Icon(
                  Icons.arrow_circle_down,
                  size: 20,
                  color: Colors.black54,
                ),
              ),
            )));
  }
  checkImageSave(normalImage, msgType) {
    print(normalImage);
    var fileNameDemo;
    if (msgType == "Image") {
      fileNameDemo = normalImage
          .toString()
          .substring(normalImage.toString().indexOf('ImageData/') + 10);
      var imgUrl =
          "${WebApi.basesUrl}" + normalImage.toString().substring(2);
      saveMediaToLocalStorage(imgUrl, fileNameDemo, msgType);
    }
    else if (msgType == "Audio") {
      fileNameDemo = normalImage
          .toString()
          .substring(normalImage.toString().indexOf('VoiceData/') + 10);
      var imgUrl =
          "${WebApi.basesUrl}" + normalImage.toString().substring(2);
      saveMediaToLocalStorage(imgUrl, fileNameDemo, msgType);
    }
    else if (msgType == "File") {
      fileNameDemo = normalImage
          .toString()
          .substring(normalImage.toString().indexOf('File/') + 10);
      var imgUrl =
          "${WebApi.basesUrl}" + normalImage.toString().substring(2);
      saveMediaToLocalStorage(imgUrl, fileNameDemo, msgType);
    }
  }

  void saveMediaToLocalStorage(imgUrl, name, msgType) async {
    // bool downloaded = await saveMedia(imgUrl, name, msgType);
    // if (downloaded) {
    //   //print('image successfully downloaded');
    // } else {
    //   //print("Problem Downloading File");
    // }
  }
}
loadNetworkImage(value) {
  String path =
  value.toString().substring(value.toString().indexOf('ImageData/') + 10);
  bool fileExists = File('/storage/emulated/0/AslChat/' + path).existsSync();
  return fileExists;
}
