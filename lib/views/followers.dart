import 'package:flutter/material.dart';
import 'package:project/classes/followCard.dart';
import 'package:project/classes/postImage.dart';
import 'package:project/classes/userClass.dart';
import 'package:project/util/screenSizes.dart';
import 'package:project/util/styles.dart';
import 'package:project/views/profileCommon.dart';

class Followers extends StatelessWidget {
  final UserData user;
  const Followers({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              itemCount: user.followers.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: screenWidth(context, dividedBy: 2),
                  child: FollowCard(
                    currentUser: user,
                    follower: user.followers[index],
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}