
import 'package:dash_board/responsive.dart';
import 'package:dash_board/screens/login/login_controller.dart';
import 'package:dash_board/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController loginController=Get.put(LoginController());

  TextEditingController _emailController = new TextEditingController();

  TextEditingController _passwordController = new TextEditingController();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LoginController());
    return WillPopScope(child: StreamBuilder<Object>(builder: (context, snapshot) {
      return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration:
          !Responsive.isMobile(context)?
              BoxDecoration(
                color: Color(0xffeeebeb),
              ):
          BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg.png"),
              fit: BoxFit.fill,
            ),
          ),


          child: Container(
            decoration: BoxDecoration(
              //image: DecorationImage(image: AssetImage("assets/images/bacground.jpeg"),fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(50),
              // color: Color(0xffffffff),

            ),
            child: ListView(
              children: <Widget>[
               !Responsive.isMobile(context)?
                 Container(
                    decoration: BoxDecoration(
                      //image: DecorationImage(image: AssetImage("assets/images/bacground.jpeg"),fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(50),
                      // color: Color(0xffffffff),

                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),

                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            // side: BorderSide(
                            //   //color: Colors.black,
                            //   width: 2.0,
                            // ),

                          ),
                      shadowColor: Colors.blueGrey,
                          child: Container(
                            decoration: BoxDecoration(
                                //image: DecorationImage(image: AssetImage("assets/images/bacground.jpeg"),fit: BoxFit.fill),
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xffffffff),
                              boxShadow: [
                                new BoxShadow(
                                  color: Color(0xff898888),

                                  blurRadius: 03.0,
                                ),
                              ],
                            ),


                            padding: const EdgeInsets.all(30),

                            width: MediaQuery.of(context).size.width*0.30,

                            child: new Column(children: <Widget>[
                              new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 100.0,
                                        height: 100.0,
                                        child: Image.asset(
                                          'assets/images/loto_trans.png',
                                          fit: BoxFit.contain,
                                          //  color: Colors.white,
                                          width: 100.0,
                                          height: 100.0,
                                        ),
                                      ),
                                    ),
                                  ]),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      color: Color(0xff474444),

                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    letterSpacing: 2

                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(splashColor: Colors.transparent),
                                child: TextField(
                                  controller: _emailController,
                                  autofocus: false,
                                  style: TextStyle(
                                      fontSize: 17.0,

                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.account_circle_rounded,
                                        color: Get.isDarkMode?Colors.black:Colors.blueGrey),
                                    filled: true,
                                  //  fillColor: Color(0xffeeebeb),
                                  hintText: 'Email',
                                    hintStyle: TextStyle(
                                        color: Get.isDarkMode?Colors.black:Colors.blueGrey
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 5.0, top: 15.0),
                                    fillColor: Color(0xffeeebeb),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              TextField(
                                controller: _passwordController,
                                obscureText: !_passwordVisible,
                                autofocus: false,
                                style: TextStyle(
                                    fontSize: 17.0,
                                    color: Color(0xFFbdc6cf),
                                    ),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock,
                                      color: Get.isDarkMode?Colors.black:Colors.blueGrey),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;

                                      });

                                      // Update the state i.e. toogle the state of passwordVisible variable

                                    },
                                  ),
                                //  focusColor: Colors.green,
                                  filled: true,
                                  fillColor: Color(0xffeeebeb),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      color: Get.isDarkMode?Colors.black:Colors.blueGrey
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      left: 5.0, bottom: 5.0, top: 15.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),

                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                height: 30.0,
                                width: 100,
                                margin: EdgeInsets.all(0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(      Color(0xff880e4f)),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        // Change your radius here
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  onPressed: (){
                                    if(_emailController.text==''&&_passwordController.text!=''){
                                      showAlerDialog("Waring!", "Username required!");
                                    }
                                    else if(_passwordController.text==''&&_passwordController.text!=''){
                                      showAlerDialog("Waring!", "Password required!");

                                    }else if(_emailController.text==''&&_passwordController.text=='' ){
                                      showAlerDialog("Waring!", "Username and Password required!");

                                    }else{
                                      loginController.loginButton(_emailController.text,_passwordController.text);

                                    }
                                  },
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xff880e4f),
                                            Color(0xff880e4f)
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(5.0)),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: 400.0, minHeight: 50.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Login",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                           ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              SizedBox(height: 20.0),
                              InkWell(
                                onLongPress: (){
                                  // Navigator.push(context, MaterialPageRoute(builder: (_)=>AdimLoginPage()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text.rich(
                                      TextSpan(
                                        text: 'A product of Alchemy software limited.',
                                      ),
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.brown,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),

                      ],
                    ),
                  )
                :
               Padding(
                 padding: const EdgeInsets.all(30),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     SizedBox(
                       height: 80,
                     ),
                     new Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           Padding(
                             padding: const EdgeInsets.all(10.0),
                             child: Container(
                               alignment: Alignment.center,
                               width: 70.0,
                               height: 70.0,
                               child: Image.asset(
                                 'assets/images/loto_trans.png',
                                 fit: BoxFit.contain,
                                 //color: Colors.white,
                                 width: 100.0,
                                 height: 100.0,
                               ),
                             ),
                           ),
                         ]),
                     SizedBox(
                       height: 40,
                     ),
                     new Column(children: <Widget>[
                       Container(
                         alignment: Alignment.center,
                         child: Text(
                           'LOGIN',
                           style: TextStyle(
                               color: Colors.white,
                               fontSize: 24,
                               fontWeight: FontWeight.bold,
                               fontStyle: FontStyle.italic),
                         ),
                       ),
                     ]),
                     SizedBox(
                       height: 15,
                     ),
                     Theme(
                       data: Theme.of(context)
                           .copyWith(splashColor: Colors.transparent),
                       child: TextField(
                         controller: _emailController,
                         autofocus: false,
                         style: TextStyle(
                             fontSize: 17.0,
                             fontStyle: FontStyle.italic,
                             color: Colors.black.withOpacity(0.3)),
                         decoration: InputDecoration(
                           prefixIcon: Icon(Icons.account_circle_rounded,
                               color: Get.isDarkMode?Colors.black:Colors.blueGrey),
                           filled: true,
                           fillColor: Colors.white,
                           hintText: 'Email',
                           hintStyle: TextStyle(
                               color: Get.isDarkMode?Colors.black:Colors.blueGrey
                           ),
                           contentPadding: const EdgeInsets.only(
                               left: 14.0, bottom: 5.0, top: 15.0),
                           focusedBorder: OutlineInputBorder(
                             borderSide: BorderSide(color: Colors.white),
                             borderRadius: BorderRadius.circular(15.0),
                           ),
                           enabledBorder: UnderlineInputBorder(
                             borderSide: BorderSide(color: Colors.white),
                             borderRadius: BorderRadius.circular(15.0),
                           ),
                         ),
                       ),
                     ),
                     SizedBox(
                       height: 12,
                     ),
                     TextField(
                       controller: _passwordController,
                       obscureText: !_passwordVisible,
                       autofocus: false,
                       style: TextStyle(
                           fontSize: 17.0,
                           color: Color(0xFFbdc6cf),
                           fontStyle: FontStyle.italic),
                       decoration: InputDecoration(
                         prefixIcon: Icon(Icons.lock,
                             color: Get.isDarkMode?Colors.black:Colors.blueGrey),
                         suffixIcon: IconButton(
                           icon: Icon(
                             _passwordVisible
                                 ? Icons.visibility
                                 : Icons.visibility_off,
                             color: Theme.of(context).primaryColorDark,
                           ),
                           onPressed: () {
                             // Update the state i.e. toogle the state of passwordVisible variable
                             _passwordVisible = !_passwordVisible;

                           },
                         ),
                         filled: true,
                         fillColor: Colors.white,
                         hintText: 'Password',
                         hintStyle: TextStyle(
                             color: Get.isDarkMode?Colors.black:Colors.blueGrey
                         ),
                         contentPadding: const EdgeInsets.only(
                             left: 5.0, bottom: 5.0, top: 15.0),
                         focusedBorder: OutlineInputBorder(
                           borderSide: BorderSide(color: Colors.white),
                           borderRadius: BorderRadius.circular(15.0),
                         ),
                         enabledBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: Colors.white),
                           borderRadius: BorderRadius.circular(15.0),
                         ),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(0.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                         // crossAxisAlignment: CrossAxisAlignment.baseline,
                         children: [

                           TextButton(
                             onPressed: () {
                               //Get.to(()=>ForgetPassword());
                             },
                             child: Text(
                               'Forgot Password?',
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 15,
                                 fontStyle: FontStyle.italic,
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                     SizedBox(
                       height: 35,
                     ),
                     Container(
                       height: 30.0,
                       width: 100,
                       margin: EdgeInsets.all(0),
                       child: ElevatedButton(
                         style: ButtonStyle(
                           backgroundColor: MaterialStateProperty.all<Color>(      Color(0xff880e4f)),
                           shape: MaterialStateProperty.all(
                             RoundedRectangleBorder(
                               // Change your radius here
                               borderRadius: BorderRadius.circular(10),
                             ),
                           ),
                         ),
                         onPressed: ()=>loginController.loginButton(_emailController.text,_passwordController.text),
                         child: Ink(
                           decoration: BoxDecoration(
                               gradient: LinearGradient(
                                 colors: [
                                   Color(0xff880e4f),
                                   Color(0xff880e4f)
                                 ],
                                 begin: Alignment.centerLeft,
                                 end: Alignment.centerRight,
                               ),
                               borderRadius: BorderRadius.circular(5.0)),
                           child: Container(
                             constraints: BoxConstraints(
                                 maxWidth: 400.0, minHeight: 50.0),
                             alignment: Alignment.center,
                             child: Text(
                               "Login",
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                   color: Colors.white,
                                   fontSize: 17,
                                   fontStyle: FontStyle.italic),
                             ),
                           ),
                         ),
                       ),
                     ),
                     SizedBox(
                       height: 35,
                     ),
                     InkWell(
                       onTap: () {

                         //  showSignUpDialog(context);


                         Future.delayed(Duration(seconds: 1), () async {
                           //  Get.to(()=>RegistrationPage());
                           // Navigator.push(
                           //   context,
                           //   MaterialPageRoute(
                           //       builder: (context) => RegistrationPage()),
                           //
                           // );
                         });


                       },
                       child: Padding(
                         padding: const EdgeInsets.all(10),
                         child: Container(
                           alignment: Alignment.center,
                           child: Text(
                             'Sign Up',
                             style: TextStyle(
                                 fontSize: 17,
                                 color: Colors.white,
                                 fontStyle: FontStyle.italic),
                           ),
                         ),
                       ),
                     ),
                     SizedBox(height: 100.0),
                     InkWell(
                       onLongPress: (){
                         // Navigator.push(context, MaterialPageRoute(builder: (_)=>AdimLoginPage()));
                       },
                       child: Padding(
                         padding: const EdgeInsets.all(10),
                         child: Container(
                           alignment: Alignment.center,
                           child: Text.rich(
                             TextSpan(
                               text: 'A product of Alchemy software limited.',
                             ),
                             style: TextStyle(
                                 fontSize: 15,
                                 color: Colors.white,
                                 fontStyle: FontStyle.italic),
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
              ],
            ),
          ),
        ),
      );
    }, stream: null,),   onWillPop: () async => false,);
  }
}