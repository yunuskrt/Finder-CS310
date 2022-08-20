import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project/classes/userClass.dart';
import 'package:project/util/colors.dart';
import 'package:project/util/styles.dart';

class FollowCard extends StatelessWidget {
  final UserData follower;
  final UserData currentUser;

  const FollowCard(
      {Key? key, required this.follower, required this.currentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.transparent,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: follower.photo,
                  fit: BoxFit.fill,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Image.asset("assets/img1.jpg"),
                ),
              ),
              radius: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                follower.username,
                style: kBoldLabelStyle,
              ),
            ),
            const Spacer(),
            follower != currentUser
                ? OutlinedButton(
                    onPressed: () {
                      currentUser.followUnfollow(follower);
                    },
                    child: currentUser.following.contains(follower)
                        ? const Text("Unfollow")
                        : const Text("Follow"),
                  )
                : const SizedBox(width: 0, height: 0)
          ],
        ),
      ),
    );
  }
}
