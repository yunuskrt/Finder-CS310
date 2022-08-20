import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/views_initial/errorScreen.dart';
import 'package:project/views_initial/waitingScreen.dart';

import '../classes/firestoreFunctions.dart';
import '../classes/userClass.dart';
import '../util/colors.dart';
import '../util/styles.dart';

class ChangeNameSurname extends StatelessWidget {
  final UserData user;
  const ChangeNameSurname({Key? key, required this.user}) : super(key: key);

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

    String name='', surname = '';
    final nameController =TextEditingController();
    final surnameController =TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Changing Username"),),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.account_circle_rounded),
                label: Text('Name', style: kBoldLabelStyle),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide()
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelStyle: kBoldLabelStyle,
                fillColor: AppColors.textFieldFillColor,
                filled: true,
                hintText: 'Enter name',
                suffixIcon: IconButton(
                    onPressed: () => nameController.clear(),
                    icon: const Icon(Icons.close)
                ),
              ),
              validator: (value) {
                if(value != null){
                  if(value.isEmpty) {
                    return 'Cannot leave name empty';
                  }
                }
                return null;
              },
              onSaved: (value) {
                name = value ?? '';
              },
            ),
            TextFormField(
              controller: surnameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.account_circle_rounded),
                label: Text('Surname', style: kBoldLabelStyle),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide()
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelStyle: kBoldLabelStyle,
                fillColor: AppColors.textFieldFillColor,
                filled: true,
                hintText: 'Enter Surname',
                suffixIcon: IconButton(
                    onPressed: () => surnameController.clear(),
                    icon: const Icon(Icons.close)
                ),
              ),
              validator: (value) {
                if(value != null){
                  if(value.isEmpty) {
                    return 'Cannot leave Surname empty';
                  }
                }
                return null;
              },
              onSaved: (value) {
                surname = value ?? '';
              },
            ),
            OutlinedButton(
              child: Text('Change My Name & Surname', style: kButtonLightTextStyle),
              style: OutlinedButton.styleFrom(
                  fixedSize: const Size.fromWidth(350),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  side: const BorderSide(width: 2, color: Colors.green),
                  backgroundColor: Colors.grey
              ),
              onPressed: () async {
                final name = nameController.text;
                final surname = surnameController.text;
                print (name);
                print (surname);
                if(name != '' && surname != '') {
                  await updateNameSurname(user: user, name: name, surname: surname);
                  Navigator.pushNamedAndRemoveUntil(context, '/profileView', (route) => false);
                } else {
                  _showDialog('Error', 'Name or Surname can not be empty');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}