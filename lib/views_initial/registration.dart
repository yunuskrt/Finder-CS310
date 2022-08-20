import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/util/analytics.dart';
import 'package:project/classes/postClass.dart';
import 'package:project/util/colors.dart';
import 'package:project/util/styles.dart';
import 'package:project/util/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/views_initial/waitingScreen.dart';
import '../classes/firestoreFunctions.dart';
import '../classes/userClass.dart';
import 'dart:io' show Platform;

import 'errorScreen.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final usernameController = TextEditingController();
  final birthdayController = TextEditingController();
  late String s;
  final AuthService _auth = AuthService();
  late Stream<List<UserData>> streamer;


  Future registerUser({required UserData user}) async {
    dynamic result = await _auth.registerUserWithEmailPass(emailController.text.trim(),passController.text.trim());
    if (result is String) {
      _showDialog('Error', result.toString());
    } else if (result is User){
      final String UID = result.uid;
      await createUser(user: user, UID: UID);
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      print('Login Error return value not string');
    }
  }

  Future<void> _showDialog(String title, String message) async {
    bool isAndroid = Platform.isAndroid;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          if(isAndroid) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(message),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          } else {
            return CupertinoAlertDialog(
              title: Text(title, style: kBoldLabelStyle),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(message, style: kLabelStyle),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
        }
    );
  }

  @override
  void initState() {
    setRegistrationScreen();
    streamer = readAllUsers();
    super.initState();
    s = '';
  }

  void setRegistrationScreen() async {
    await AnalyticsService.setScreenName('Registration Screen');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserData>>(
        stream: streamer,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreen(message: snapshot.toString());
          }
          if (!snapshot.hasData) {
            return const WaitingScreen();
          } else {
            final usersList = snapshot.data!;
            return Scaffold(
              body: SafeArea(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Spacer(flex: 2),
                          Text('Finder',
                              style: kHeadingTextStyle),
                          const Spacer(flex: 4),
                          TextFormField(
                            controller: usernameController,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.account_circle_rounded),
                                label: Text('Username', style: kBoldLabelStyle),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    borderSide: BorderSide()
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelStyle: kBoldLabelStyle,
                                fillColor: AppColors.textFieldFillColor,
                                filled: true,
                                hintText: 'Enter Username'
                            ),

                          ),
                          const Spacer(flex: 2),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email),
                                label: Text('Email', style: kBoldLabelStyle),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    borderSide: BorderSide()
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelStyle: kBoldLabelStyle,
                                fillColor: AppColors.textFieldFillColor,
                                filled: true,
                                hintText: 'Enter Email'
                            ),
                            controller: emailController,
                          ),
                          const Spacer(flex: 2),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.vpn_key,),
                                label: Text('Password', style: kBoldLabelStyle),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    borderSide: BorderSide()
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelStyle: kBoldLabelStyle,
                                fillColor: AppColors.textFieldFillColor,
                                filled: true,
                                hintText: 'Enter Password'
                            ),
                            controller: passController,
                          ),
                          const Spacer(flex: 2),
                          TextFormField(
                            controller: birthdayController,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.web),
                                label: Text('Birthday', style: kBoldLabelStyle),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelStyle: kBoldLabelStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    borderSide: BorderSide()
                                ),
                                fillColor: AppColors.textFieldFillColor,
                                filled: true,
                                hintText: 'Enter Birthday'
                            ),
                          ),
                          const Spacer(flex:4),
                          OutlinedButton(
                              child: Text('Register', style: kButtonLightTextStyle),
                              style: OutlinedButton.styleFrom(
                                  fixedSize: Size.fromWidth(150),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  side: const BorderSide(width: 2, color: Colors.green),
                                  backgroundColor: Colors.grey
                              ),
                              onPressed: () async{
                                final user = UserData(
                                  username: usernameController.text,
                                  email: emailController.text,
                                  password:  passController.text,
                                );
                                if (!(usersList.any((element) => element.username == user.username))) {
                                  await registerUser(user: user);
                                } else {
                                  _showDialog("username occupied", "Reenter username");
                                  setState(() {
                                  });
                                }
                              }
                          ),
                          const Spacer(flex:10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Already have an account? Press to', style: kGreyTextStyle),
                                TextButton(
                                    child: Text('Login', style: kTextButtonTextStyle),
                                    style: TextButton.styleFrom(
                                      primary: Colors.blue,
                                      //padding: EdgeInsets.zero,
                                    ),
                                    onPressed: (){Navigator.pushNamed(context, '/login');}
                                ),
                              ]
                          ),
                          const Spacer(flex: 4)
                        ]
                    ),
                  )
              ),
            );
          }
        }
    );
  }
}