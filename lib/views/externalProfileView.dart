import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/classes/firestoreFunctions.dart';
import 'package:project/util/colors.dart';
import 'package:project/util/styles.dart';
import 'package:project/classes/postImage.dart';
import 'package:project/util/colors.dart';
import 'package:project/views/bookmarksView.dart';
import 'package:project/views/locationsProfileView.dart';
import 'package:project/views/mediaProfileView.dart';
import 'package:project/views/postsProfileView.dart';
import 'package:project/views_initial/waitingScreen.dart';

import '../classes/postClass.dart';
import '../classes/userClass.dart';
import '../views_initial/errorScreen.dart';

class ExternalProfileView extends StatefulWidget {
  final String userID;
  final bool privateProfile = true;
  const ExternalProfileView({Key? key, required this.userID}) : super(key: key);

  @override
  _ExternalProfileViewState createState() => _ExternalProfileViewState();
}

class _ExternalProfileViewState extends State<ExternalProfileView> {
  late Stream<UserData> streamer;

  @override
  void initState() {
    streamer = readUserByID(ID: widget.userID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: streamer,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreen(message: snapshot.toString());
          }
          if (!snapshot.hasData) {
            return const WaitingScreen();
          } else {
            final user = snapshot.data!;
            user.followers = [
              UserData(username: "deneme"),
              UserData(username: "deneme"),
              UserData(username: "deneme"),
              UserData(username: "deneme"),
              UserData(username: "deneme"),
              UserData(username: "deneme"),
              UserData(username: "deneme"),
              UserData(username: "deneme"),
            ];
            return DefaultTabController(
              animationDuration: const Duration(seconds: 1),
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {
                      reportUser(context);
                    },
                    icon: const Icon(
                      Icons.flag_outlined,
                    ),
                  ),
                  elevation: 10,
                  title: Text(user.username),
                  centerTitle: true,
                  bottom: const TabBar(
                    tabs: [
                      Tab(
                        icon: Icon(Icons.perm_contact_calendar_sharp),
                      ),
                      Tab(icon: Icon(Icons.location_on)),
                      Tab(icon: Icon(Icons.image)),
                    ],
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.message),
                    ),
                    IconButton(
                      onPressed: () {
                        connect(ID: widget.userID);
                      },
                      icon: user.following.contains(user)
                          ? const Icon(Icons.group_remove)
                          : const Icon(Icons.group_add),
                    ),
                  ],
                ),
                body: TabBarView(
                  children: [
                    PostsProfileView(user: user, isPrivateProfile: user.privateProfile, isExternalProf: true),
                    LocationsProfileView(user: user, isPrivateProfile: user.privateProfile,),
                    MediaProfileView(user: user, isPrivateProfile: user.privateProfile,),
                  ],
                ),
              ),
            );
          }
        });
  }
}

Future<void> reportUser(BuildContext context) async {
  showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => AlertDialog(
      scrollable: true,
      content: Column(children: [
        Center(
          child: Text(
            "Are you sure you want to report this user?",
            textAlign: TextAlign.center,
            style: kBoldLabelStyle,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle),
              color: AppColors.likeButton,
              iconSize: 36,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.cancel,
                color: AppColors.dislikeButton,
              ),
              iconSize: 36,
            ),
          ],
        )
      ]),
    ),
  );
}
