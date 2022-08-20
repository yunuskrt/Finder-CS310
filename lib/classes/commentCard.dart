import 'package:project/classes/commentClass.dart';
import 'package:project/util/colors.dart';
import 'package:project/util/styles.dart';
import 'userClass.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  Comment comment;

  CommentCard({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            border: Border.all(width: 0.25),
            borderRadius: BorderRadius.circular(10),
            color: AppColors.darkButtonTextColor),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(children: [
              ClipOval(
                  child: CircleAvatar(
                      child: Image.network(
                          "https://iptc.org/wp-content/uploads/2018/05/avatar-anonymous-300x300.png"),
                      radius: 10)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  comment.user.username,
                  style: kBoldLabelStyle,
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32,6,6,6),
            child: Text(
              comment.content,
              style: kPostTextStyle,
            ),
          )
        ]),
      ),
    );
  }
}
