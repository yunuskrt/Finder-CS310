import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/views/feedView.dart';
import 'login.dart';

class IsUserLoggedIn extends StatelessWidget {
  const IsUserLoggedIn({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const FeedView();
            } else {
              return const Login();
            }
          },
        )
    );
  }
}