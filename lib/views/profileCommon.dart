import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project/classes/userClass.dart';
import 'package:project/util/colors.dart';
import 'package:project/util/screenSizes.dart';
import 'package:project/util/styles.dart';
import 'package:project/views/followView.dart';

class ProfileCommon extends StatelessWidget {
  final UserData user;
  const ProfileCommon({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () {
                  zoomProfilePicture(context, user);
                },
                child: CircleAvatar(
                  backgroundColor: AppColors.transparent,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl:
                      user.photo,
                      fit: BoxFit.fill,
                      placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          Image.asset("assets/img1.jpg"),
                    ),
                  ),
                  radius: 55,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Name: ",
                      style: kBoldLabelStyle,
                    ),
                    Text(
                      user.name + ' ' + user.surname,
                      style: kLabelStyle,
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Text(
                          "Topics: ",
                          style: kBoldLabelStyle,
                        ),
                        Text(
                          user.topicList.length.toString(),
                          style: kLabelStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FollowView(
                          user: user,
                          initialTab: 0,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        "Followers: ",
                        style: kBoldLabelStyle,
                      ),
                      Text(
                        user.followers.length.toString(),
                        style: kLabelStyle,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FollowView(
                          user: user,
                          initialTab: 1,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Text(
                          "Following: ",
                          style: kBoldLabelStyle,
                        ),
                        Text(
                          user.following.length.toString(),
                          style: kLabelStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(user.bio),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          child: const Divider(
            color: AppColors.primary,
            thickness: 2,
            height: 10,
          ),
        ),
      ],
    );
  }
}

Future<void> zoomProfilePicture(BuildContext context, UserData user) async {
  showDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierColor: AppColors.transparent,
    builder: (BuildContext context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: GestureDetector(
        onTap: Navigator.of(context).pop,
        child: CircleAvatar(
          backgroundColor: AppColors.transparent,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl:
              user.photo,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  Image.asset("assets/img1.jpg"),
            ),
          ),
        ),
      ),
    ),
  );
}