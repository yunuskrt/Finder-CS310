import 'package:flutter/material.dart';
import 'package:project/util/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/util/sizeConfig.dart';

TextStyle? kHeadingTextStyle = GoogleFonts.montserrat(
  color: AppColors.headingColor,
  fontWeight: FontWeight.w700,
  fontSize: 50.0,
  letterSpacing: -0.7,
);

final kGreyTextStyle = GoogleFonts.montserrat(
  color: Colors.blueGrey,
  fontSize: 18.0,
  letterSpacing: -0.5,
);

final kTextButtonTextStyle = GoogleFonts.montserrat(
  color: AppColors.headingColor,
  fontSize: 18.0,
  letterSpacing: -0.5,
  decoration: TextDecoration.underline,
);

final kButtonLightTextStyle = GoogleFonts.montserrat(
  color: AppColors.textColor,
  fontSize: 20.0,
  letterSpacing: -0.7,
);

final kButtonDarkTextStyle = GoogleFonts.montserrat(
  color: AppColors.darkButtonTextColor,
  fontSize: 20.0,
  letterSpacing: -0.7,
);

final kAppBarTitleTextStyle = GoogleFonts.montserrat(
  color: AppColors.appBarTitleTextColor,
  fontSize: 24.0,
  fontWeight: FontWeight.w500,
  letterSpacing: -0.7,
);

final kWalkthroughTextStyle = GoogleFonts.montserrat(
  color: AppColors.walkthroughText,
  fontSize: SizeConfig.screenWidth * 0.05,
  fontWeight: FontWeight.w600,
  letterSpacing: -0.7,
);

final kBoldLabelStyle = GoogleFonts.montserrat(
  fontSize: 17.0,
  color: AppColors.textColor,
  fontWeight: FontWeight.w600,
);

final kLabelStyle = GoogleFonts.montserrat(
  fontSize: 14.0,
  color: AppColors.textColor,
);

final kNotificationStyle = GoogleFonts.montserrat(
  fontSize: 12.0,
  color: AppColors.textColor,
);

final kNotificationDateStyle = GoogleFonts.montserrat(
  color: Colors.black38,
  fontSize: 10.0,
  fontWeight: FontWeight.bold,
);

final kMessagesTextStyle = GoogleFonts.montserrat(
  color: Colors.black,
  fontSize: 13.0,
  fontWeight: FontWeight.bold,
);

const kEditProfileHintTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

final kEditProfileTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  color: Colors.grey[600],
);

final kTopicStyle = GoogleFonts.montserrat(
  color: AppColors.primary,
  fontSize: 13.0,
  fontStyle: FontStyle.italic,
);

final kPostTextStyle = GoogleFonts.montserrat(
  fontSize: 13.0,
  fontStyle: FontStyle.italic,
);

final likeCount = GoogleFonts.montserrat(
  color: AppColors.likeButton,
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  letterSpacing: -0.7,
);
final dislikeCount = GoogleFonts.montserrat(
  color: AppColors.dislikeButton,
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  letterSpacing: -0.7,
);
final repostCount = GoogleFonts.montserrat(
  color: AppColors.primary,
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  letterSpacing: -0.7,
);
final commentCount = GoogleFonts.montserrat(
  color: AppColors.commentButton,
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  letterSpacing: -0.7,
);