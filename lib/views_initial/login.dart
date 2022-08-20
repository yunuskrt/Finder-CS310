import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:project/classes/userClass.dart';
import 'package:project/util/analytics.dart';
import 'package:project/util/auth.dart';
import 'package:project/util/colors.dart';
import 'package:project/util/sizeConfig.dart';
import 'package:project/util/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../classes/firestoreFunctions.dart';
import '../util/screenSizes.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
class Login extends StatefulWidget
{
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>
{
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String pass = '';
  late User _user;
  final emailController = TextEditingController();
  final passController = TextEditingController();
  late String s;
  final AuthService _auth = AuthService();
  final FirebaseAuth _auth2 = FirebaseAuth.instance;
  final AnalyticsService _analytics = AnalyticsService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future signInWithFacebook() async {
    var loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider
        .credential(loginResult.accessToken!.token);
    FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
  Future loginGoogle() async{
    var user = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
    await user!.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
    );

    UserCredential authResult = await _auth2.signInWithCredential(credential);
    _user = authResult.user!;
    assert(!_user.isAnonymous);
    assert(await _user.getIdToken() != null);
    User currentUser = await _auth2.currentUser!;
    assert(_user.uid == currentUser.uid);
    var y = await FirebaseFirestore.instance.collection('users').doc(_user.uid);
    var z = await y.get();
    if (z.data() == null){
      final UserData x = UserData(
          email: _user.email!, name: _user.displayName!, id: _user.uid,username: _user.displayName!);
      await createUser(user: x, UID: _user.uid);
    }
  }
  Future loginAnon() async {
    dynamic result = await _auth.signInAnon();
    if(result is String) {
      _showDialog('Login Error', result);
    } else if (result is User) {
      //User signed in
      Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
    } else {
      _showDialog('Login Error', result.toString());
    }
  }

  Future loginUser() async {
    dynamic result = await _auth.signInWithEmailPass(email,pass);
    if (result is String) {
      _showDialog('Login Error', result);
    } else if (result is User){
      Navigator.pushNamedAndRemoveUntil(context, '/feedView', (route) => false);
    } else {
      _showDialog('Login Error', result.toString());
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
    // TODO: implement initState
    setLoginScreen();
    super.initState();
    s = '';
  }
  void setLoginScreen() async {
    await AnalyticsService.setScreenName('Login Screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Spacer(flex: 2),
                  Text('Finder',
                      style: kHeadingTextStyle),
                  Spacer(flex: 3),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.account_circle_rounded),
                      label: Text('Email', style: kBoldLabelStyle),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide()
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: kBoldLabelStyle,
                      fillColor: AppColors.textFieldFillColor,
                      filled: true,
                      hintText: 'Enter Email',
                      suffixIcon: IconButton(
                          onPressed: () => emailController.clear(),
                          icon: const Icon(Icons.close)
                      ),
                    ),
                    validator: (value) {
                      if(value != null){
                        if(value.isEmpty) {
                          return 'Cannot leave e-mail empty';
                        }
                        if(!EmailValidator.validate(value)) {
                          return 'Please enter a valid e-mail address';
                        }
                      }
                    },
                    onSaved: (value) {
                      email = value ?? '';
                    },
                  ),
                  const Spacer(flex: 3),
                  TextFormField(
                    controller: passController,
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.vpn_key,),
                      label: Text('Password', style: kBoldLabelStyle),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide()
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: kBoldLabelStyle,
                      fillColor: AppColors.textFieldFillColor,
                      filled: true,
                      hintText: 'Enter Password',
                      suffixIcon: IconButton(
                          onPressed: () => passController.clear(),
                          icon: const Icon(Icons.clear)
                      ),
                    ),
                    validator: (value) {
                      if(value != null){
                        if(value.isEmpty) {
                          return 'Cannot leave password empty';
                        }
                        if(value.length < 6) {
                          return 'Password too short';
                        }
                      }
                    },
                    onSaved: (value) {
                      pass = value ?? '';
                    },
                  ),
                  Spacer(flex:3),
                  OutlinedButton(
                    child: Text('Login', style: kButtonLightTextStyle),
                    style: OutlinedButton.styleFrom(
                        fixedSize: Size.fromWidth(160),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        side: const BorderSide(width: 2, color: Colors.green),
                        backgroundColor: Colors.grey
                    ),
                    onPressed: () async {
                      if(_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        await loginUser();

                      } else {
                        _showDialog('Form Error', 'Your form is invalid');
                      }
                    },
                  ),
                  Spacer(flex:4),
                  Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          loginGoogle();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(" Sign in with  "),
                              SizedBox(
                                  child: Image.asset('assets/google_icon.jpg'),
                                height: screenHeight(context) * 0.06,
                                width: screenWidth(context) * 0.06
                              ),
                            ],
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                            fixedSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            side: const BorderSide(width: 1.5),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: (){signInWithFacebook();},
                          child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(" Sign in with  "),
                              SizedBox(
                                  child: Image.asset('assets/facebook_icon.png'),
                                  height: screenHeight(context) * 0.06,
                                  width: screenWidth(context) * 0.06
                              ),
                            ],
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          fixedSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          side: const BorderSide(width: 1.5),
                        ),
                      ),

                    ],
                  ),
                  Spacer(flex:10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account? Press to ',
                          style: kGreyTextStyle,
                        ),
                        TextButton(
                            child: Text('Register', style: kTextButtonTextStyle),
                            style: TextButton.styleFrom(
                              primary: Colors.blue,
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: (){Navigator.pushNamed(context, '/registration');}
                        ),
                      ]
                  ),
                  Spacer(flex: 3)
                ],
              ),
            ),
          ),
        )
    );
  }
}