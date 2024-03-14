import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/MyFiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../constants.dart';

class FileInfoCard extends StatelessWidget {
  const FileInfoCard({
    Key? key,
    required this.info,
    required this.title
  }) : super(key: key);

  final int info;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: Color(0xff1B3F4BFF),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  //  padding: EdgeInsets.all(defaultPadding * 0.75),
                    height: 70,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode?Colors.white:Colors.grey,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                        Icons.people_outline,
                        color: Get.isDarkMode?Colors.black:Colors.white
                    )
                ),
                //  Icon(Icons.more_vert, color: Colors.white54)
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${title} : ",
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  color: Get.isDarkMode?Colors.white:Colors.black54
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "${info.toString()}",
              style: TextStyle(
                  color: Get.isDarkMode?Colors.white:Colors.black,
                  fontSize: 22
              ),
            ),
          ],
        ),
      ),
    );
  }
}

