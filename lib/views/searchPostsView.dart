import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project/classes/firestoreFunctions.dart';
import 'package:project/classes/postCard.dart';
import 'package:project/util/colors.dart';
import 'package:project/classes/navigationBar.dart';
import 'package:project/util/styles.dart';
import 'package:project/classes/postImage.dart';
import '../classes/postClass.dart';
import '../classes/userClass.dart';
import '../util/dimensions.dart';
import '../util/screenSizes.dart';
import '../views_initial/errorScreen.dart';
import '../views_initial/waitingScreen.dart';
import 'externalProfileView.dart';

class SearchPosts extends StatefulWidget {
  final String postContent;
  const SearchPosts({Key? key, this.postContent = ''}) : super(key: key);
  @override
  State<SearchPosts> createState() => _SearchPostsState();
}

class _SearchPostsState extends State<SearchPosts> {
  late Stream<List<Post>> streamer;
  late Future<UserData> currentUserFromFuture;
  @override
  void initState() {
    streamer = readAllPosts();
    currentUserFromFuture = readUserByIDFuture(ID: getUserID()!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late UserData currentUser = UserData();
    currentUserFromFuture.then((value) => currentUser = value);
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
            final post = postList.firstWhere((element) =>
            element.text == widget.postContent, orElse: ()=>Post(owner: UserData(), originalOwner: UserData(), date: DateTime(0)));
            return Scaffold(
              appBar: AppBar(
                elevation: 10,
                title: const Text("Search Result for Posts"),
              ),
              body: SafeArea(
                child: Row(children: [
                  const NavBar(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    post.id != ''?
                                    PostCard(post: post, user: currentUser)
                                        :
                                    Container(
                                        margin: const EdgeInsets.only(bottom: 8.0),
                                        height: 50,
                                        width: screenWidth(context) * 0.8,
                                        padding:
                                        const EdgeInsets.all(Dimen.regularMargin),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.primary, width: 1.0),
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.blueGrey.withOpacity(0.2),
                                        ),
                                        child: const Text('There is no post with this content')
                                    )
                                  ],
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            );
          }
        }
    );
  }
}