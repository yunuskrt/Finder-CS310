import 'package:flutter/material.dart';
import 'package:project/util/colors.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      color: AppColors.primary,
      child: Container(
        margin: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  ModalRoute.of(context)?.settings.name != '/searchExploreView'
                      ? Navigator.pushNamedAndRemoveUntil(context,
                          '/searchExploreView', (Route<dynamic> route) => false)
                      : null;
                }),
            IconButton(
                icon: const Icon(Icons.account_circle_rounded),
                onPressed: () {
                  ModalRoute.of(context)?.settings.name != '/profileView'
                      ? Navigator.pushNamedAndRemoveUntil(context,
                          '/profileView', (Route<dynamic> route) => false)
                      : null;
                }),
            IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  ModalRoute.of(context)?.settings.name != '/feedView'
                      ? Navigator.pushNamedAndRemoveUntil(
                          context, '/feedView', (Route<dynamic> route) => false)
                      : null;
                }),
            IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  ModalRoute.of(context)?.settings.name != '/notificationView'
                      ? Navigator.pushNamedAndRemoveUntil(context,
                          '/notificationView', (Route<dynamic> route) => false)
                      : null;
                }),
            IconButton(
                icon: const Icon(Icons.message),
                onPressed: () {
                  ModalRoute.of(context)?.settings.name != '/messagesView'
                      ? Navigator.pushNamedAndRemoveUntil(context,
                          '/messagesView', (Route<dynamic> route) => false)
                      : null;
                }),
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  ModalRoute.of(context)?.settings.name != '/editProfileView'
                      ? Navigator.pushNamed(context, '/editProfileView')
                      : null;
                }),
          ],
        ),
      ),
    );
  }
}
