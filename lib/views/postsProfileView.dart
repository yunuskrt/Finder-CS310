import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project/classes/navigationBar.dart';
import 'package:project/classes/postImage.dart';
import 'package:project/classes/userClass.dart';
import 'package:project/util/colors.dart';
import 'package:project/util/styles.dart';
import 'package:project/views/profileCommon.dart';

import '../classes/firestoreFunctions.dart';
import '../classes/postClass.dart';
import '../views_initial/errorScreen.dart';
import '../views_initial/waitingScreen.dart';

class PostsProfileView extends StatefulWidget {
  final UserData user;
  final bool isPrivateProfile;
  final bool isExternalProf; //isExternalProfile

  const PostsProfileView(
      {Key? key, required this.user,
        required this.isPrivateProfile, required this.isExternalProf})
      : super(key: key);

  @override
  State<PostsProfileView> createState() => _PostsProfileViewState();
}

class _PostsProfileViewState extends State<PostsProfileView> {
  late Stream<List<Post>> streamer;

  @override
  void initState() {
    if (widget.isExternalProf == false) {
      streamer = readCurrentUserPosts();
    } else {
      streamer = readUserPostsByID(userID: widget.user.id);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Post>>(
        stream: streamer,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreen(message: snapshot.toString());
          }
          if (!snapshot.hasData) {
            return const WaitingScreen();
          } else {
            final postList = snapshot.data!;
            return SafeArea(
              child: Row(children: [
                const NavBar(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ProfileCommon(user: widget.user),
                      !widget.isPrivateProfile
                          ? Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: GridView.builder(
                                  itemCount: postList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 2.0,
                                          mainAxisSpacing: 2.0),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return PostImage(
                                        post: postList[index]);
                                  },
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                              "\nThis profile is private",
                              style: kAppBarTitleTextStyle,
                            )),
                    ],
                  ),
                ),
              ]),
            );
          }
        });
  }
}