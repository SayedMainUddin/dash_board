import 'dart:ui';

import 'package:dash_board/constants.dart';
import 'package:dash_board/controllers/MenuAppController.dart';
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/models/departments.dart';
import 'package:dash_board/responsive.dart';
import 'package:dash_board/screens/dashboard/department/components/callback.dart';
import 'package:dash_board/screens/dashboard/department/components/departmentHeadModal.dart';
import 'package:dash_board/screens/dashboard/department/components/userList.dart';
import 'package:dash_board/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../../models/Users.dart';



class DepartmentPage extends StatefulWidget {

  @override
  State<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  //List<Department> departments = []; // Your list of categories
  final MenuAppController menuAppController=Get.put(MenuAppController());

  final ApiController apiController=Get.put(ApiController());

  late TutorialCoachMark tutorialCoachMark;

  GlobalKey keyButton = GlobalKey();

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }
  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: createTargets(),
      colorShadow: Colors.red,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        print("finish");
       // tutorialCoachMark.finish();
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
        return true;
      },
    );
  }

  List<TargetFocus> createTargets() {
    List<TargetFocus> targets = [];



    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyButton,
        color: Colors.purple,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Hi Admin",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "First create department for creating user.\nThank you.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.previous();
                    },
                    child: const Icon(Icons.chevron_left),
                  ),
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );


    return targets;
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
   createTutorial();

  Future.delayed(Duration(seconds: 2),() {
    apiController.departmentList.length==0?
    showTutorial():null;
  },);
//
  }
  @override
  Widget build(BuildContext context) {
    return Container(

        child:GetBuilder<ApiController>(builder: (controller){
      // final filteredUsers = apiController.getFilteredUsers();

      return       SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child:Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Departments",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                        onPressed: (){
                      apiController.getAllDepartments();

                    }, icon: Icon(Icons.refresh))
                  ],
                ),

                ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                    ),
                  ),
                  key: keyButton,
                  onPressed: () {
                    showCreateDepartmentModal(context);
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add Department"),
                ),

              ],
            ),

            FutureBuilder<List<Department>>(
              future: apiController.getAllDepartments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // If the Future is still running, show a loading indicator
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // If there is an error with the Future, display an error message
                  return Text('Error: ${snapshot.error}');
                } else {
                  // If the Future is complete, display the list of departments
                  final List<Department> departments = snapshot.data ?? [];
                  return DepartmentListTable(
                      departmentList:departments
                  );

                }
              },
            ),
          ],
        ),
      );}),


    );
  }
}








