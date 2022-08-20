
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> setUserId(String userID) async {
    await _analytics.setUserId(
      id: userID,
    );
  }

  static Future<void> setScreenName(String screenName) async {
    await _analytics.setCurrentScreen(
        screenName: screenName,
    );
  }

  static Future<void> logCustomEvent(String logName, Map<String,dynamic> map) async {
    await _analytics.logEvent(
      name: logName,
      parameters: map,
    );
  }
}
