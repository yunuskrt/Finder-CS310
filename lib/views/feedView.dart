import 'package:flutter/material.dart';
import 'package:project/classes/navigationBar.dart';
import 'package:project/util/analytics.dart';
import 'package:project/views/deactivated.dart';
import '../classes/firestoreFunctions.dart';
import '../classes/postCard.dart';
import '../classes/postClass.dart';
import '../classes/postImage.dart';
import '../classes/userClass.dart';
import '../views_initial/errorScreen.dart';
import '../views_initial/waitingScreen.dart';


class FeedView extends StatefulWidget {
  const FeedView({Key? key}) : super(key: key);
  @override
  _FeedViewState createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView>
{
  //final Stream<List<Post>> postsF = createFeedPage();

  final AnalyticsService _analytics = AnalyticsService();
  late Stream<UserData> streamer;
  late Stream<List<Post>> streamer2;


  @override
  void initState() {
    streamer = readUser();
    streamer2 = readAllPosts();
    setFeedScreen();
    super.initState();
  }

  void setFeedScreen() async{
    await AnalyticsService.setScreenName('Feed Screen');
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
            if(user.isDeactivated && user.deactivatedUntil > DateTime.now().millisecondsSinceEpoch) {
              return Deactivated(date: DateTime.fromMillisecondsSinceEpoch(user.deactivatedUntil));
            }
            else if(user.isDeactivated && user.deactivatedUntil < DateTime.now().millisecondsSinceEpoch) {
              activate();
            }
            return StreamBuilder<List<Post>>(
              stream: streamer2,
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
                        elevation: 10,
                        title: const Text("Home"),
                        centerTitle: true,
                      ),
                      body: SafeArea(
                        child: Row(children: [
                          const NavBar(),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: postList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return PostCard(
                                  post: postList[index], user: user,);
                              },
                            ),
                          )
                        ],
                        ),
                      )
                  );
                }
              });
          }
      }
      );
  }
}