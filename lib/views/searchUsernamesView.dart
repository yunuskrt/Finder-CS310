import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project/classes/firestoreFunctions.dart';
import 'package:project/util/colors.dart';
import 'package:project/classes/navigationBar.dart';
import 'package:project/util/styles.dart';
import 'package:project/classes/postImage.dart';
import '../classes/userClass.dart';
import '../util/dimensions.dart';
import '../util/screenSizes.dart';
import '../views_initial/errorScreen.dart';
import '../views_initial/waitingScreen.dart';
import 'externalProfileView.dart';

class SearchUsernames extends StatefulWidget {
  final String username;
  const SearchUsernames({Key? key, this.username = ''}) : super(key: key);
  @override
  State<SearchUsernames> createState() => _SearchUsernamesState();
}

class _SearchUsernamesState extends State<SearchUsernames> {
  late Stream<List<UserData>> streamer;

  @override
  void initState() {
    streamer = readAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserData>>(
        stream: streamer,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreen(message: snapshot.toString());
          }
          if (!snapshot.hasData) {
            return const WaitingScreen();
          } else {
            final users = snapshot.data!;
            final user = users.firstWhere((element) =>
            element.username == widget.username, orElse: ()=>UserData()); //gives match user to given id
            return Scaffold(
              appBar: AppBar(
                elevation: 10,
                title: const Text("Search Results"),
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
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: const Divider(
                              color: AppColors.primary,
                              thickness: 2,
                              height: 10,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    user.id != ''?
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
                                      child: TextButton(
                                        child: Text( user.username ),
                                        onPressed: () =>
                                        user.id == getUserID()
                                            ? Navigator.pushNamed(context, '/profileView')
                                            : Navigator.push(
                                          context,MaterialPageRoute(builder: (context) =>  ExternalProfileView(userID: user.id)),
                                        ),
                                      )
                                    )
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
                                        child: const Text('There is no one with this username')
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