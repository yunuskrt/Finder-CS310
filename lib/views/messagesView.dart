import 'package:flutter/material.dart';
import 'package:project/classes/navigationBar.dart';
import 'package:project/util/dimensions.dart';
import 'package:project/util/screenSizes.dart';
import 'package:project/util/colors.dart';
import 'package:project/util/styles.dart';
import 'package:project/classes/messageClass.dart';
import 'package:project/views_initial/waitingScreen.dart';

import '../classes/firestoreFunctions.dart';
import '../classes/userClass.dart';
import '../views_initial/errorScreen.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({Key? key}) : super(key: key);

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  List<Messages> messages = [
    Messages(user: UserData(name: 'Ahmet', photo: 'assets/img1.jpg', username: 'robot96',
        password: 'impossible', surname: 'Gardas', email: 'nice@gmail.com'),
        content: "he wrote smth brada", date: "10 min ago"),
    Messages(user: UserData(name: 'Ahmet', photo: 'assets/img1.jpg', username: 'robot96',
        password: 'impossible', surname: 'Gardas', email: 'nice@gmail.com'),
        content: "he wrote smth brada", date: "10 min ago"),
    Messages(user: UserData(name: 'Ahmet', photo: 'assets/img1.jpg', username: 'robot96',
        password: 'impossible', surname: 'Gardas', email: 'nice@gmail.com'),
        content: "he wrote smth brada", date: "10 min ago"),
    Messages(user: UserData(name: 'Ahmet', photo: 'assets/img1.jpg', username: 'robot96',
        password: 'impossible', surname: 'Gardas', email: 'nice@gmail.com'),
        content: "he wrote smth brada", date: "10 min ago"),
    Messages(user: UserData(name: 'Ahmet', photo: 'assets/img1.jpg', username: 'robot96',
        password: 'impossible', surname: 'Gardas', email: 'nice@gmail.com'),
        content: "he wrote smth brada", date: "10 min ago"),
    Messages(user: UserData(name: 'Ahmet', photo: 'assets/img1.jpg', username: 'robot96',
        password: 'impossible', surname: 'Gardas', email: 'nice@gmail.com'),
        content: "he wrote smth brada", date: "10 min ago"),
    Messages(user: UserData(name: 'Ahmet', photo: 'assets/img1.jpg', username: 'robot96',
        password: 'impossible', surname: 'Gardas', email: 'nice@gmail.com'),
        content: "he wrote smth brada", date: "10 min ago"),
  ];

  void deleteMessage(Messages msgs) {
    setState(() {
      messages.remove(msgs);
    });
  }

  late Stream<UserData> streamer;

  @override
  void initState() {
    streamer = readUser();
    super.initState();
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
                  title: const Text('Messages'),
                  centerTitle: true,
                  elevation: 10,
                ),
                body: SafeArea(
                  child: Material(
                    elevation: 10,
                    child: Container(
                      margin: EdgeInsets.zero,
                      child: Row(children: [
                        const NavBar(),
                        Container(
                          margin: const EdgeInsets.only(
                              top: Dimen.parentMargin, left: Dimen.parentMargin),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: messages.map((msgs) => MessagesCard(
                                  msgs: msgs,
                                  delete: (){deleteMessage(msgs);}
                              ),
                              ).toList(),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                )
            );
          }
        }
        );
  }
}

class MessagesCard extends StatelessWidget {
  final Messages msgs;
  final VoidCallback delete;
  const MessagesCard({required this.msgs, required this.delete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      height: screenHeight(context) * 0.115,
      width: screenWidth(context) * 0.8,
      //padding: const EdgeInsets.all(Dimen.regularMargin),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.navigatorBarColor, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: AppColors.notificationText,
      ),
      child: Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
              height: 60,
              width: 60,
              child: ClipOval(child: Image.asset(msgs.user.photo))),
          Column( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(msgs.user.username, style: kMessagesTextStyle),
              Text(msgs.content, style: kNotificationStyle)
            ],
          ),
          Text(msgs.date, style: kNotificationDateStyle)
        ],
      ),
    );
  }
}