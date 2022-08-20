import 'package:flutter/material.dart';
import 'package:project/util/colors.dart';
import 'package:project/util/styles.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:project/util/sizeConfig.dart';

class WalkThrough extends StatefulWidget {
  const WalkThrough({Key? key}) : super(key: key);

  @override
  _WalkThroughState createState() => _WalkThroughState();
}

class _WalkThroughState extends State<WalkThrough> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: AppColors.walkthroughBackground,
      body: Container(
        padding: EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.10),
        child: PageView(
          onPageChanged: (index){setState(() {isLastPage = index == 3;});},
          controller: controller,
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: SizeConfig.screenHeight*0.135),
                  height: SizeConfig.screenHeight * 0.2,
                  child: Text('Welcome to walk-through of Finder!',
                      style: kWalkthroughTextStyle),
                ),
                Image.asset('assets/lets_get_started.jpg',
                  fit: BoxFit.cover,
                  height: SizeConfig.screenHeight * 0.6,
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.1,
                  child: AnimatedTextKit(
                      totalRepeatCount: 50,
                      animatedTexts: [
                        ScaleAnimatedText (
                            "You can swipe",
                            textStyle: kWalkthroughTextStyle,
                            duration: const Duration(seconds: 3)
                        )
                      ]
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: SizeConfig.screenHeight*0.135),
                  height: SizeConfig.screenHeight * 0.2,
                  child: Text('In Finder You can meet people',
                      style: kWalkthroughTextStyle),
                ),
                Image.asset('assets/connect_to_people.png',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.7,
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: SizeConfig.screenHeight*0.135),
                  height: SizeConfig.screenHeight * 0.2,
                  child: Text('In Finder You Can Follow Others',
                      style: kWalkthroughTextStyle),
                ),
                Image.asset('assets/feed.jpg',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.7,
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: SizeConfig.screenHeight*0.135),
                  height: SizeConfig.screenHeight * 0.2,
                  child: Text('In Finder You Can Share Your Thoughts',
                      style: kWalkthroughTextStyle),
                ),
                Image.asset('assets/share_and_message.jpg',
                  fit: BoxFit.cover,
                  height: SizeConfig.screenHeight * 0.7,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage?
      TextButton(
          onPressed: (){ Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);},
          child: Text("Let's Start!", style: kWalkthroughTextStyle,),
          style: TextButton.styleFrom(
              backgroundColor: AppColors.walkthroughBackground,
            minimumSize: Size.fromHeight(SizeConfig.screenHeight * 0.10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))
          )
      )
          :
      Container(
        color: AppColors.walkthroughBackground,
        height: SizeConfig.screenHeight * 0.10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              child: Text("Skip", style: kWalkthroughTextStyle),
                onPressed: (){
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Do you want to skip walk-through?'),
                      content: const Text('Walk-through will be skipped. (irreversible)'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'No'),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false),
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                }
            ),
            Center(
                child: SmoothPageIndicator(
                    controller: controller,
                    count: 4,
                    effect: const ScrollingDotsEffect(
                      dotWidth: 9,
                      dotHeight: 9,
                      activeDotColor: AppColors.walkthroughText
                    )
              )
            ),
            TextButton(
                child: Text('Next', style: kWalkthroughTextStyle),
                onPressed: (){ controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut );
                }
            )
          ],
        ),
      ),
    );
  }
}