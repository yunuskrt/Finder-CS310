//import 'dart:html';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:project/classes/commentClass.dart';
import 'package:project/classes/notificationClass.dart';
import 'package:project/views/postView.dart';

import '../util/colors.dart';
import '../util/sizeConfig.dart';
import '../util/styles.dart';
import '../util/dimensions.dart';
import '../util/screenSizes.dart';
import '../classes/userClass.dart';
import '../classes/postClass.dart';
import 'package:flutter/material.dart';
import 'package:project/util/dimensions.dart';
import 'firestoreFunctions.dart';
import '../views/externalProfileView.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final UserData user;
  PostCard({required this.post, required this.user});
  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool liked = false;
  bool disliked = false;
  bool reposted = false;
  String numComments = "";

  @override
  void initState() {
    setPostStatus();
    super.initState();
  }
  void setPostStatus() async{
    bool like = await LikedByCurrUser(userID: widget.post.originalOwner.id, postID: widget.post.id);
    bool dislike = await DislikedByCurrUser(userID: widget.post.originalOwner.id, postID: widget.post.id);
    bool repost = await RepostedByCurrUser(userID: widget.post.originalOwner.id, postID: widget.post.id);
    List<Comment> cmnt_list = await getCommentsOfPost(userID: widget.post.originalOwner.id, postID: widget.post.id);
    setState(() {
      liked = like;
      disliked = dislike;
      reposted = repost;
      numComments = cmnt_list.length.toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostView( post: widget.post )
          ),
        );
      },
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.all(5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      widget.post.owner.username == widget.user.username
                          ? Navigator.pushNamed(context, '/profileView')
                          : Navigator.push(
                          context,MaterialPageRoute(builder: (context) =>  ExternalProfileView(userID: widget.post.originalOwner.id)),
                      );
                    },
                    icon: Image.network(widget.post.owner.photo == "" ? "https://firebasestorage.googleapis.com/v0/b/finder-cs310-project.appspot.com/o/no-profile-image.png?alt=media&token=ce4b4fd6-55d1-4484-bfa8-c783edf8e97a":widget.post.owner.photo),
                    iconSize: 50,
                  ),
                  TextButton(
                    child: Text(
                      widget.post.owner.username,
                      style: kBoldLabelStyle,
                    ),
                    onPressed: () =>
                    widget.post.owner.username == widget.user.username
                        ? Navigator.pushNamed(context, '/profileView')
                        : Navigator.push(
                      context,MaterialPageRoute(builder: (context) =>  ExternalProfileView(userID: widget.post.originalOwner.id)),
                  ),)
                ],
              ),
              CachedNetworkImage(
                imageUrl: widget.post.img,
                fit: BoxFit.fill,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.post.text,
                  style: kPostTextStyle,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        // Like Function
                        IconButton(
                          onPressed: () async {
                            await toggleLike(userID: widget.post.originalOwner.id, postID: widget.post.id);
                            setState(() {
                              liked = !liked;
                              //widget.post.likePost(currentUser);
                            });
                            if (liked) {
                              AppNotification LikedNtfc = AppNotification(
                                  username: widget.user.username,
                                  //FirebaseAuth.instance.currentUser!.uid,
                                  action: 'liked your post',
                                  date: DateFormat('MMMMEEEEd')
                                      .format(DateTime.now()));
                              await pushNotification(
                                  ntfc: LikedNtfc,
                                  ownerID: widget.post.originalOwner.id);
                            }
                          },
                          icon: liked
                              ? const Icon(
                                  Icons.thumb_up,
                                  color: AppColors.likeButton,
                                )
                              : const Icon(
                                  Icons.thumb_up,
                                  color: AppColors.unclickedButton,
                                ),
                        ),
                        Text(
                          widget.post.likeCount.toString(),
                          style: likeCount,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        // Dislike Function
                        IconButton(
                          onPressed: () async {
                            await toggleDislike(userID: widget.post.originalOwner.id, postID: widget.post.id);
                            setState(() {
                              disliked = !disliked;
                              // widget.post.dislikePost(currentUser);
                            });
                            if (disliked) {
                              AppNotification DislikedNtfc = AppNotification(
                                  username: widget.user.username,
                                  action: 'disliked your post',
                                  date: DateFormat('MMMMEEEEd')
                                      .format(DateTime.now()));
                              await pushNotification(
                                  ntfc: DislikedNtfc,
                                  ownerID: widget.post.originalOwner.id);
                            }
                          },
                          icon: disliked
                              ? const Icon(
                                  Icons.thumb_down,
                                  color: AppColors.dislikeButton,
                                )
                              : const Icon(
                                  Icons.thumb_down,
                                  color: AppColors.unclickedButton,
                                ),
                        ),
                        Text(widget.post.dislikeCount.toString(),
                            style: dislikeCount),
                      ],
                    ),
                    Column(
                      children: [
                        //Repost Function
                        IconButton(
                          onPressed: () async {
                            final originalId = widget.post.originalOwner.id;
                            await toggleRepost(post: widget.post);
                            setState(() {
                              reposted = !reposted;
                              //widget.post.repost(currentUser);
                            });
                            if (reposted) {
                              AppNotification RepostNtfc = AppNotification(
                                  username: widget.user.username,
                                  action: 'reposted your post',
                                  date: DateFormat('MMMMEEEEd')
                                      .format(DateTime.now()));
                              await pushNotification(
                                  ntfc: RepostNtfc,
                                  ownerID: originalId);
                            }
                          },
                          icon: reposted
                              ? const Icon(
                                  Icons.autorenew_rounded,
                                  color: AppColors.primary,
                                )
                              : const Icon(
                                  Icons.autorenew_rounded,
                                  color: AppColors.unclickedButton,
                                ),
                        ),
                        Text(
                          widget.post.repostCount.toString(),
                          style: repostCount,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            commentDialog(context, widget.user, widget.post);
                          },
                          icon: const Icon(Icons.add_comment),
                        ),
                        Text(
                          numComments,
                          //widget.post.commentList.length.toString(),
                          style: commentCount,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}