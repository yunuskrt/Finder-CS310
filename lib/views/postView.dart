import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project/classes/commentCard.dart';
import 'package:project/classes/commentClass.dart';
import 'package:project/classes/notificationClass.dart';
import 'package:project/util/colors.dart';
import 'package:project/util/screenSizes.dart';
import 'package:project/util/styles.dart';
import 'package:project/views/createPostView.dart';
import 'package:project/views/editPostView.dart';
import 'package:uuid/uuid.dart';

import '../classes/firestoreFunctions.dart';
import '../classes/postClass.dart';
import '../classes/userClass.dart';
import '../views_initial/errorScreen.dart';
import '../views_initial/waitingScreen.dart';

class PostView extends StatefulWidget {
  final Post post;

  PostView({Key? key, required this.post}) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  late Stream<UserData> streamer;
  //late Stream<List<Post>> streamer2; --> readAllPosts

  late UserData currentUser;
  bool liked = false;
  bool disliked = false;
  bool reposted = false;
  bool saved = false;
  List<Comment> comments = [];
  @override
  void initState() {
    currentUser = widget.post.owner;
    /*
    widget.post.commentList = [
      Comment(
        content:
            "I wish I was there with you but I have this CS310 assignment I have to complete.",
        user: currentUser,
        id: 'abc',
        date: DateTime.now()
      ),
      Comment(
        content: "Hey, is that a shark on the left?",
        user: currentUser,
          id: 'abc',
          date: DateTime.now()
      ),
      Comment(
        content: "Enjoy!",
        user: currentUser,
          id: 'abc',
          date: DateTime.now()
      ),
      Comment(
        content: "I got tired!",
        user: currentUser,
          id: 'abc',
          date: DateTime.now()
      ),
      Comment(
        content: "Looks nice!",
        user: currentUser,
          id: 'abc',
          date: DateTime.now()
      )
    ];
     */
    streamer = readUser();
    setPostStatus();
    super.initState();
  }
  void setPostStatus() async{
    bool like = await LikedByCurrUser(userID: widget.post.originalOwner.id, postID: widget.post.id);
    bool dislike = await DislikedByCurrUser(userID: widget.post.originalOwner.id, postID: widget.post.id);
    bool save = await SavedByCurrUser(postID: widget.post.id);
    bool repost = await RepostedByCurrUser(userID: widget.post.originalOwner.id, postID: widget.post.id);
    List<Comment> cmntList = await getCommentsOfPost(userID: widget.post.originalOwner.id, postID: widget.post.id);
    setState(() {
      liked = like;
      disliked = dislike;
      saved = save;
      reposted = repost;
      comments = cmntList;
    });
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
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  widget.post.owner.username,
                  style: kButtonDarkTextStyle,
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        if (user.username != widget.post.owner.username) {
                          reportPost(context); // TODO: Notify Admin
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPost(
                                user: user,
                                editPost: widget.post,
                              ),
                            ),
                          );
                        }
                      },
                      icon: user.username != widget.post.owner.username
                          ? const Icon(
                              Icons.flag_outlined,
                            )
                          : const Icon(Icons.edit)),
                  user.username == widget.post.owner.username
                      ? IconButton(
                          icon: const Icon(
                            Icons.delete,
                          ),
                          onPressed: () async {
                            await deletePost(context, user, widget.post);
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                        )
                      : const Text("")
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Istanbul"),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                            children: widget.post.topics
                                .map((e) => Text(
                                      e + " ",
                                      style: kTopicStyle,
                                    ))
                                .toList()),
                      ),
                    ],
                  ),
                  Container(
                    decoration: const BoxDecoration(color: Colors.black),
                    height: screenHeight(context, dividedBy: 2.5),
                    width: screenHeight(context, dividedBy: 2.5),
                    child: InkWell(
                      onDoubleTap: () {
                        setState(() {
                          widget.post.likePost(currentUser);
                        });
                      },
                      child: CachedNetworkImage(
                        imageUrl: widget.post.img,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.post.text,
                      style: kPostTextStyle,
                    ),
                  ),
                  Card(
                    child: Row(children: [

                      // Like Button Function
                      IconButton(
                        onPressed: () async {
                          await toggleLike(userID: widget.post.originalOwner.id, postID: widget.post.id);
                          setState(() {
                            liked = !liked;
                            //widget.post.likePost(currentUser);
                          });
                          if (liked) {
                            AppNotification LikedNtfc = AppNotification(
                                username: user.username,
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

                      // Dislike Button Function
                      IconButton(
                        onPressed: () async {
                          await toggleDislike(userID: widget.post.originalOwner.id, postID: widget.post.id);
                          setState(() {
                            disliked = !disliked;
                            // widget.post.dislikePost(currentUser);
                          });
                          if (disliked) {
                            AppNotification DislikedNtfc = AppNotification(
                                username: user.username,
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

                      // Repost Button Function
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
                                username: user.username,
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
                      IconButton(
                        onPressed: () async {
                          await commentDialog(context, user, widget.post);
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.add_comment,
                        ),
                      ),

                      // Save Button Function
                      IconButton(
                        onPressed: () async {
                          await toggleSave(post: widget.post);
                          setState(() {
                            saved = !saved;
                            //widget.post.bookmarkPost(currentUser);
                          });
                          if(saved) {
                            AppNotification SavedNtfc = AppNotification(
                                username: user.username,
                                action: 'saved your post',
                                date: DateFormat('MMMMEEEEd')
                                    .format(DateTime.now()));
                            await pushNotification(
                                ntfc: SavedNtfc,
                                ownerID: widget.post.originalOwner.id);
                          }
                        },
                        icon: saved//currentUser.bookmarks.contains(widget.post)
                            ? const Icon(Icons.bookmark_added,
                                color: AppColors.bookmarkButton)
                            : const Icon(
                                Icons.bookmark_add_outlined,
                              ),
                      ),
                      const Spacer(),
                      Text(
                        widget.post.date.day.toString() +
                            "/" +
                            widget.post.date.month.toString() +
                            "/" +
                            widget.post.date.year.toString() +
                            " ",
                        style: kGreyTextStyle,
                      )
                    ]),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                          children: comments
                              .map((e) => CommentCard(comment: e))
                              .toList()),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}

Future<void> reportPost(BuildContext context) async {
  showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => AlertDialog(
      scrollable: true,
      content: Column(children: [
        Center(
          child: Text(
            "Are you sure you want to report this post?\n",
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

Future<void> commentDialog(
    BuildContext context, UserData user, Post post) async {
  final commentController = TextEditingController();

  await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => AlertDialog(
      scrollable: true,
      content: Column(children: [
        TextFormField(
          minLines: 1,
          maxLines: 10,
          keyboardType: TextInputType.multiline,
          controller: commentController,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.comment),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: const BorderSide()),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: kBoldLabelStyle,
              fillColor: AppColors.textFieldFillColor,
              filled: true,
              hintText: "Enter comment"),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () async{
                  // add comment to firebase
                  UserData myUser = await readUserFuture();
                  Comment newCmnt = Comment(
                      id: Uuid().v4(),
                      content: commentController.text,
                      user: myUser,
                      date: DateTime.now());
                  //print(newCmnt.toJson());
                  await addComment(
                      userID: post.originalOwner.id,
                      postID: post.id,
                      cmnt: newCmnt
                  );
                  AppNotification CommentNtfc = AppNotification(
                      username: user.username,
                      action: 'commented to your post',
                      date: DateFormat('MMMMEEEEd')
                          .format(DateTime.now()));
                  await pushNotification(
                      ntfc: CommentNtfc,
                      ownerID: post.originalOwner.id);
                  /*
                  post.addComment(
                      Comment(content: commentController.text, user: user));

                   */
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.check_circle,
                  color: AppColors.likeButton,
                ),
                iconSize: 36,
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
          ),
        )
      ]),
    ),
  );
}

Future<void> deletePost(BuildContext context, UserData user, Post post) async {
  await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => AlertDialog(
      scrollable: true,
      content: Column(children: [
        Center(
          child: Text(
            "Are you sure you want to delete this post?\n",
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
                deleteSinglePost(post: post); // FIREBASE DELETE
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