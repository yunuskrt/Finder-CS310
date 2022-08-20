import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:project/util/auth.dart';
import 'package:project/views/deactivated.dart';
import 'package:project/views/externalProfileView.dart';
import 'package:project/views/searchUsernamesView.dart';
import 'package:project/views_initial/AuthStatus.dart';
import 'package:project/views_initial/errorScreen.dart';
import 'package:project/views_initial/isUserLoggedIn.dart';
import 'package:project/views_initial/waitingScreen.dart';
import 'package:project/views_initial/welcome.dart';
import 'package:project/views_initial/login.dart';
import 'package:project/views_initial/registration.dart';
import 'package:project/views/feedView.dart';
import 'package:project/views/editProfileView.dart';
import 'package:project/views/notificationView.dart';
import 'package:project/views/profileView.dart';
import 'package:project/views/searchExploreView.dart';
import 'package:project/views/messagesView.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyApp(),
      routes: {
        '/welcome': (context) => const Welcome(),
        '/isUserLoggedIn': (context) => const IsUserLoggedIn(),
        '/login': (context) => const Login(),
        '/registration': (context) => const Registration(),
        '/feedView': (context) => const FeedView(),
        '/editProfileView': (context) => const EditProfileView(),
        '/notificationView': (context) => const NotificationView(),
        '/profileView': (context) => ProfileView(),
        '/externalProfileView': (context) => const ExternalProfileView(userID: '',),
        '/searchExploreView': (context) => const SearchExploreView(),
        '/messagesView': (context) => const MessagesView(),
        '/searchSecond': (context) => const SearchUsernames(),
        '/deactivated': (context) => const Deactivated(date: null,),
      }));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _init = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _init,
        builder: (context, snapshot) {
          FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

          if (snapshot.hasError) {
            return ErrorScreen(message: snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamProvider<User?>.value(
              value: AuthService().user,
              initialData: null,
              child: const AuthenticationStatus(),
            );
          }
          return const WaitingScreen();
        });
  }
}