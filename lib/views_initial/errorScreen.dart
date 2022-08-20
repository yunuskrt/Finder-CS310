import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  ErrorScreen({Key? key, required this.message}) : super(key: key);

  String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.exit_to_app_sharp),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(
                context, '/welcome', (route) => false);
          },
      ),
      appBar: AppBar(
        title: Text('CS310 Spring'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}