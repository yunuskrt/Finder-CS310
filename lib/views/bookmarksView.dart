import 'package:flutter/material.dart';
import 'package:project/classes/firestoreFunctions.dart';
import 'package:project/classes/postImage.dart';
import 'package:project/classes/userClass.dart';
import 'package:project/views_initial/waitingScreen.dart';
import '../classes/postClass.dart';
import '../views_initial/errorScreen.dart';

class BookmarksView extends StatefulWidget {
  final UserData user;

  const BookmarksView({Key? key, required this.user}) : super(key: key);

  @override
  State<BookmarksView> createState() => _BookmarksViewState();
}

class _BookmarksViewState extends State<BookmarksView> {
  late Stream<List<Post>> streamer;

  @override
  void initState() {
    streamer = readCurrentUserBookmarks();
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
          return Scaffold(
            appBar: AppBar(
              title: const Text("Bookmarks"),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.builder(
                itemCount: postList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0),
                itemBuilder: (BuildContext context, int index) {
                  return PostImage(post: postList[index]);
                },
              ),
            ),
          );
        }
      });

  }
}
