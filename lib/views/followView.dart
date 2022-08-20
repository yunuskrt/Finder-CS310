import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project/classes/userClass.dart';
import 'package:project/util/colors.dart';
import 'package:project/views/followers.dart';
import 'package:project/views/following.dart';

class FollowView extends StatelessWidget {
  final UserData user;
  final int initialTab;

  const FollowView({Key? key, required this.user, required this.initialTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialTab,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(user.username),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Followers"),
              Tab(text: "Following"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Followers(user: user),
            Following(user: user),
          ],
        ),
      ),
    );
  }
}
