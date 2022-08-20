import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/util/sizeConfig.dart';
import 'package:project/util/styles.dart';
import 'package:project/util/colors.dart';

import '../classes/firestoreFunctions.dart';



// userDatas!['isDeactivated'] = true;
// var date = DateTime.now();
// date = date.add(const Duration(days:7));
// print(date);
// userDatas['deactivatedUntil'] = date;
// await user.update(userDatas);

class Deactivated extends StatelessWidget {
  final DateTime? date;
  const Deactivated({Key? key, required this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar:AppBar( title:Text("Deactive"), centerTitle: true, elevation: 18,),
    body:  Container(
    color: Colors.white,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column( crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your account"),
            Text("will be"),
            Text("deactivated untill"),
            Text(date.toString()),
            Container(
              child:
              IconButton(onPressed: (){
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
                }, icon: Icon(Icons.logout)),
            )
        ],
    ),
      ),
  ),
);

  }
}
