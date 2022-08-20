import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:project/util/styles.dart';
import 'package:project/util/colors.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(// <-- STACK AS THE SCAFFOLD PARENT
        children: [
      Image.asset(
        'assets/background.jpg',
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height,
      ),
      Scaffold(
        backgroundColor:
            AppColors.transparent, // <-- SCAFFOLD WITH TRANSPARENT BG
        body: SafeArea(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Spacer(flex: 10),
              AnimatedTextKit(
                totalRepeatCount: 1,
                animatedTexts: [
                  ColorizeAnimatedText(
                    'Welcome to',
                    colors: AppColors.colorizeColors,
                    textStyle: kHeadingTextStyle!,
                    speed: const Duration(seconds: 2),
                  ),
                ],
              ),
              const Spacer(flex: 1),
              AnimatedTextKit(
                totalRepeatCount: 1,
                animatedTexts: [
                  ColorizeAnimatedText(
                    'Finder',
                    colors: AppColors.colorizeColors,
                    textStyle: kHeadingTextStyle!,
                    speed: const Duration(seconds: 2),
                  ),
                ],
              ),
              const Spacer(flex: 15),
              SizedBox(
                height: 50,
                child: AnimatedTextKit(totalRepeatCount: 50, animatedTexts: [
                  ScaleAnimatedText("Please tap anywhere to continue!",
                      duration: const Duration(seconds: 3))
                ]),
              ),
              const Spacer(flex: 5),
            ]),
          ]),
        ),
      ),
      GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/isUserLoggedIn'),
          child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Text(''))),
    ]);
  }
}
