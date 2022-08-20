import 'package:flutter/cupertino.dart';


class AppNotification {
  String username;
  String action;
  String id;
  String date;

  // date will be equal to DateFormat('MMMMEEEEd').format(DateTime.now())'
  AppNotification({
    required this.username,
    required this.action,
    required this.date,
    this.id = '',
  });

  static AppNotification fromJson(Map<String, dynamic> json) => AppNotification(
    username: json['username'],
    action: json['action'],
    id: json['id'],
    date: json['date'],
  );


  Map<String,dynamic> toJson() => {
    'id': id,
    'username': username,
    'action': action,
    'date': date,
  };
}
