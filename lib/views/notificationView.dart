import 'package:flutter/material.dart';
import 'package:project/classes/navigationBar.dart';
import 'package:project/util/analytics.dart';
import 'package:project/util/dimensions.dart';
import 'package:project/util/screenSizes.dart';
import 'package:project/util/colors.dart';
import 'package:project/util/styles.dart';
import 'package:project/classes/notificationClass.dart';

import '../classes/firestoreFunctions.dart';
import '../classes/userClass.dart';
import '../views_initial/errorScreen.dart';
import '../views_initial/waitingScreen.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {



  late Stream<List<AppNotification>> streamer;

  @override
  void initState() {
    setNotificationScreen();
    streamer = readCurrentUserNotifications();
    super.initState();
  }
  void setNotificationScreen() async{
    await AnalyticsService.setScreenName('Notification Screen');
  }

  void delNotification(AppNotification ntfc) async{
    await deleteNotification(ntfc.id);
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AppNotification>>(
        stream: streamer,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreen(message: snapshot.toString());
          }
          if (!snapshot.hasData) {
            return const WaitingScreen();
          } else {
            final notifications = snapshot.data!;
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Notifications'),
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
                              children: notifications
                                  .map((ntfc) => Dismissible(
                                background: Container(
                                  padding: const EdgeInsets.only(
                                      right: Dimen.parentMargin),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.colorizeColors[3],
                                  ),
                                  child: const Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.delete,
                                      size: 40,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                ),
                                key: ValueKey<AppNotification>(ntfc),
                                onDismissed: (DismissDirection direction) {
                                  delNotification(ntfc);
                                },
                                child: NotificationCard(
                                  ntfc: ntfc,
                                  delete: () {
                                    delNotification(ntfc);
                                  },
                                ),
                              ))
                                  .toList(),
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

class NotificationCard extends StatelessWidget {
  final AppNotification ntfc;
  final VoidCallback delete;
  NotificationCard({required this.ntfc, required this.delete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      height: 80,
      width: screenWidth(context) * 0.8,
      padding: const EdgeInsets.all(Dimen.regularMargin),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.navigatorBarColor, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: AppColors.notificationText,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            ntfc.action == 'liked your post'
                ? Icons.thumb_up
                : ntfc.action == 'disliked your post'
                ? Icons.thumb_down
                : ntfc.action == 'reposted your post'
                ? Icons.autorenew_rounded
                : ntfc.action == 'saved your post'
                ? Icons.bookmark_added
                : ntfc.action == 'commented to your post'
                ? Icons.comment
                : Icons.person_add,
          ),
          Flexible(
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profileView');
              },
              child: Text(
                '${ntfc.username} ${ntfc.action}',
                maxLines: 4,
                softWrap: true,
                overflow: TextOverflow.fade,
                style: kNotificationStyle,
              ),
            ),
          ),
          Center(
            child: Text(
              '  ${ntfc.date}',
              style: kNotificationDateStyle,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: delete,
              icon: const Icon(Icons.cancel),
              color: AppColors.navigatorBarColor,
            ),
          ),
        ],
      ),
    );
  }
}