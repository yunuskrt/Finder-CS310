import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/classes/firestoreFunctions.dart';
import 'package:project/util/analytics.dart';
import 'package:project/util/colors.dart';
import 'package:project/util/styles.dart';
import 'package:project/classes/postImage.dart';
import 'package:project/util/colors.dart';
import 'package:project/views/bookmarksView.dart';
import 'package:project/views/createPostView.dart';
import 'package:project/views/locationsProfileView.dart';
import 'package:project/views/mediaProfileView.dart';
import 'package:project/views/postsProfileView.dart';
import 'package:project/views_initial/waitingScreen.dart';

import '../classes/postClass.dart';
import '../classes/userClass.dart';
import '../views_initial/errorScreen.dart';

class ProfileView extends StatefulWidget {
  ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Stream<UserData> streamer;

  @override
  void initState() {
    streamer = readUser();
    setProfileScreen();
    super.initState();
  }
  void setProfileScreen() async {
    await AnalyticsService.setScreenName('Profile Screen');
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
            return DefaultTabController(
              animationDuration: const Duration(seconds: 1),
              length: 3,
              child: Scaffold(
                appBar: AppBar(
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookmarksView(
                              user: user,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.bookmark),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/editProfileView');
                      },
                      icon: const Icon(Icons.edit),
                    )
                  ],
                ),
                body: TabBarView(
                  children: [
                    PostsProfileView(user: user, isPrivateProfile: false, isExternalProf: false),
                    LocationsProfileView(user: user, isPrivateProfile: false),
                    MediaProfileView(user: user, isPrivateProfile: false),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreatePost(user: user),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            );
          }
        });
  }
}
