import 'package:cloud_firestore/cloud_firestore.dart';

import 'userClass.dart';

class Comment{
  String content, id;
  DateTime date = DateTime.now();
  UserData user;
  Comment({
    required this.content,
    required this.user,
    required this.date,
    this.id = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'user': user.toJson(),
    'date': Timestamp.fromDate(date),
  };

  static Comment fromJson(Map<String, dynamic> json) => Comment(
      id: json['id'],
      content: json['content'],
      user: UserData.fromJson(json['user']),
      date: (json['date'] as Timestamp).toDate(),
  );
}
