import 'package:flutter/material.dart';
import 'package:project/classes/followCard.dart';
import 'package:project/classes/userClass.dart';
import 'package:project/util/screenSizes.dart';

class Following extends StatelessWidget {
  final UserData user;
  const Following({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              itemCount: user.following.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: screenWidth(context, dividedBy: 2),
                  child: FollowCard(
                    currentUser: user,
                    follower: user.following[index],
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
