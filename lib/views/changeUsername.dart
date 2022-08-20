import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/views_initial/errorScreen.dart';
import 'package:project/views_initial/waitingScreen.dart';

import '../classes/firestoreFunctions.dart';
import '../classes/userClass.dart';
import '../util/colors.dart';
import '../util/styles.dart';

class ChangeUsername extends StatelessWidget {
  final UserData user;
  const ChangeUsername({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final _formKey = GlobalKey<FormState>();
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
                    child: const Text('OK'),
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
                    child: const Text('OK'),
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

    String usernamer='';
    final usernameController =TextEditingController();
    return StreamBuilder<List<UserData>>(
      stream: readAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final usersList = snapshot.data!;
          return Scaffold(
            appBar: AppBar(title: const Text("Changing Username"),),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.account_circle_rounded),
                      label: Text('Username', style: kBoldLabelStyle),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide()
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: kBoldLabelStyle,
                      fillColor: AppColors.textFieldFillColor,
                      filled: true,
                      hintText: 'Enter Username',
                      suffixIcon: IconButton(
                          onPressed: () => usernameController.clear(),
                          icon: const Icon(Icons.close)
                      ),
                    ),
                    validator: (value) {
                      if(value != null){
                        if(value.isEmpty) {
                          return 'Cannot leave username empty';
                        }
                      }
                      return null;
                    },
                    onSaved: (value) {
                      usernamer = value ?? '';
                    },
                  ),
                  OutlinedButton(
                    child: Text('Change My username', style: kButtonLightTextStyle),
                    style: OutlinedButton.styleFrom(
                        fixedSize: const Size.fromWidth(250),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        side: const BorderSide(width: 2, color: Colors.green),
                        backgroundColor: Colors.grey
                    ),
                    onPressed: () async {
                      final usernamer = usernameController.text;
                      if(usernamer != '' && !(usersList.any((element) => element.username == usernamer))) {
                        await updateUsername(user: user, username: usernamer);
                        Navigator.pushNamedAndRemoveUntil(context, '/profileView', (route) => false);
                      } else if (usernamer != '' && (usersList.any((element) => element.username == usernamer))){
                        _showDialog('Error', 'Username is taken');
                      } else {
                        _showDialog('Error', 'Username can not be empty');
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return ErrorScreen(message: snapshot.error.toString());
        } else {
          return const WaitingScreen();
        }
      }
    );
  }
}