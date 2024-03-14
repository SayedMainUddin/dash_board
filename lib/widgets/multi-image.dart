import 'dart:io';

import 'package:dash_board/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
List<String> grpPreviewsharedGalleryList =[];

class ImageItemFourPlus extends StatefulWidget {

  final String? image;
  final String? showRunTime;
  final String? groupImageStatus;
  final String? imageNetwork;
  final int? index;
  BuildContext? context;
  final int? length;
  var groupImage = [];

  ImageItemFourPlus(this.image, this.imageNetwork, this.index, this.length,
      this.groupImage, this.showRunTime, this.groupImageStatus);

  @override
  State<StatefulWidget> createState() {
    return ImageItemFourPlus2();
  }
}
//==================================== ====1: Four plus Image show  widget shows in chats ===========================================

class ImageItemFourPlus2 extends State<ImageItemFourPlus> {
  List<String> groupImageList = [];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  var isFourPlusImageDownload = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (widget.index == 3)
          ? () {
        print("show all clicked");
        groupImageList = [];
        //print(widget.groupImage.length);
        for (var i = 1; i < widget.groupImage.length; i++) {
          groupImageList.add(widget.groupImage[i]);
        }
        print("Length: ${groupImageList.length}");
        // print(image);
        Navigator.push(
          context,
          // MaterialPageRoute(builder: (context)=>MyBottomBarDemo()),
          MaterialPageRoute(
              builder: (context) =>
                  AllImageFromChat(
                    groupImage: groupImageList,
                  )),
          // MaterialPageRoute(builder: (context)=>FancyFab()),
        );
      }
          : () {
        print("image clicked");
        groupImageList = [];
        //print(widget.groupImage.length);
        for (var i = 1; i < widget.groupImage.length; i++) {
          groupImageList.add(widget.groupImage[i]);
        }

        Navigator.push(
          context,
          // MaterialPageRoute(builder: (context)=>MyBottomBarDemo()),
          MaterialPageRoute(
              builder: (context) =>
                  AllImageFromChat(
                    groupImage: groupImageList,
                  )),
          // MaterialPageRoute(builder: (context)=>FancyFab()),
        );
      },
      child: widget.groupImageStatus == "RunTimeImage"
          ? Container(
        width: Get.width*0.05,
        height: Get.height*0.05,
        child: (widget.index == 3)
            ? Center(
          child: Text(
            "+" + (widget.length! - 4).toString(),
            style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        )
            : null,
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
              image: NetworkImage(widget.imageNetwork!),
              fit: BoxFit.cover,
              colorFilter: (widget.index == 3)
                  ? ColorFilter.mode(
                  Colors.grey.withOpacity(0.25), BlendMode.dstATop)
                  : null),
        ),
      )
          : widget.groupImageStatus == "ImageExist"
          ?

      Container(
        width: Get.width*0.05,
        height: Get.height*0.05,

        child: (widget.index == 3)
            ? Center(
          child: Text(
            "+" + (widget.length! - 4).toString(),
            style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        )
            : null,
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
              image: FileImage(File('/storage/emulated/0/AslChat/' +
                  widget.image.toString().substring(
                      widget.image.toString().indexOf('ImageData/') +
                          10))),
              // image: NetworkImage(imageNetwork),
              fit: BoxFit.cover,
              colorFilter: (widget.index == 3)
                  ? ColorFilter.mode(Colors.grey.withOpacity(0.25),
                  BlendMode.dstATop)
                  : null),
        ),
      )
          : Container(),
    );
  }
}
class AllImageFromChat extends StatefulWidget {
  var groupImage;

  AllImageFromChat({Key? key, this.groupImage}) : super(key: key);

  @override
  AllImageFromChatState createState() => AllImageFromChatState();
}
class AllImageFromChatState extends State<AllImageFromChat> {
  var ImageList = [];

  @override
  void initState() {
    print("Gallery hit");
    print(ImageList.length);
    print(widget.groupImage.length);
    setState(() {
      ImageList = widget.groupImage;
    });
    // TODO: implement initState

    super.initState();
  }

  var isImageDownload=false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          foregroundColor: Colors.black,
          title: Row(
            children: <Widget>[
              Text(
                'Shared Gallery',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
          backgroundColor: Color(0xff8ededfb),
        ),
        body: Center(

            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(10),
                child: PageView.builder(
                  itemCount: ImageList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    // print("main via lend : ${ImageList.length}");
                    return ImageItemForGallery('${WebApi.basesUrl}/'+ImageList[index].toString().substring(1),index,
                    );
                  },
                )
            )
        )
    ), onWillPop: () async{
      Navigator.of(context).pop();
      return true;
    });
  }
}
class ImageItemForGallery extends StatelessWidget {
  final String? image;
  final int? index;
  BuildContext? context;

  ImageItemForGallery(this.image, this.index);

  Widget imageDialog(BuildContext context) {
    return Dialog(
      child: Container(
        height: 400,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image:
                DecorationImage(image: NetworkImage(image!), fit: BoxFit.fill),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.clear),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return (index == 5)
        ? InkWell(
        onTap: () {
          print('gallery clicked');
          Navigator.push(
            context,
            // MaterialPageRoute(builder: (context)=>MyBottomBarDemo()),
            MaterialPageRoute(builder: (context)=>GalleryDemo(groupImage: grpPreviewsharedGalleryList,)),
            // MaterialPageRoute(builder: (context)=>FancyFab()),

          );
        },
        child: Container(
          child: Center(
              child: Text("See more",style: TextStyle(color: Colors.white,fontSize: 20),)
          ),
          margin: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.grey,
            image: DecorationImage(
                image: NetworkImage(image!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.grey.withOpacity(0.15), BlendMode.dstATop)),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
                bottomLeft: Radius.circular(7),
                bottomRight: Radius.circular(7)),
            border: Border.all(color: Colors.grey, width: 0.4),
          ),
        )
    )
        : InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            // Future.delayed(Duration(seconds: 1)).then((_) {}
            // Navigator.pop(context);
            return imageDialog(context);
          },
        );
      },
      child: Container(
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
                bottomLeft: Radius.circular(7),
                bottomRight: Radius.circular(7)),
            border: Border.all(color: Colors.grey, width: 0.4),
            image: DecorationImage(
              image:NetworkImage(image!),
              fit: BoxFit.cover,
            )),
      ),
    );
  }
  bool imagePlaceholder=false;
}
class GalleryDemo extends StatefulWidget {
  var groupImage;

  GalleryDemo({Key? key, this.groupImage}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<GalleryDemo> {
  var ImageList = [];

  @override
  void initState() {
    print("Gallery hit");
    print(ImageList.length);
    print(widget.groupImage.length);
    setState(() {
      ImageList = widget.groupImage;
    });
    // TODO: implement initState

    super.initState();
  }

  var isImageDownload=false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          foregroundColor: Colors.black,
          title: Row(
            children: <Widget>[
              Text(
                'Shared Gallery',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
          backgroundColor: Color(0xff8ededfb),
        ),
        body: Center(

            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(10),
                child: PageView.builder(
                  itemCount: ImageList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    // print("main via lend : ${ImageList.length}");
                    return ImageItemForGallery('${WebApi.basesUrl}/'+ImageList[index].toString().substring(2),index,
                    );
                  },
                )
            )
        )
    ), onWillPop: () async{
      Navigator.of(context).pop();
      return true;
    });
  }
}
