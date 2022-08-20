import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'userClass.dart';
import 'commentClass.dart';

class Post {
  late String text, img, id, path, repostId;
  File? image;
  late UserData owner, originalOwner;
  int likeCount = 0;
  int dislikeCount = 0;
  int repostCount = 0;
  DateTime date = DateTime.now();
  List<UserData> usersLiked = [];
  List<UserData> usersDisliked = [];
  List<UserData> usersReposted = [];
  List<Comment> commentList = [];
  List<String> topics = [];

  Post({
    this.image,
    this.id = '',
    this.text = '',
    this.img = '',
    this.path = '',
    this.repostId = '',
    required this.owner,
    required this.originalOwner,
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.repostCount = 0,
    required this.date,
  });

  static Post fromJson(Map<String, dynamic> json) => Post(
        id: json['id'],
        text: json['text'],
        img: json['img'],
        path: json['path'],
        repostId: json['repostId'],
        likeCount: json['likeCount'],
        dislikeCount: json['dislikeCount'],
        repostCount: json['repostCount'],
        date: (json['date'] as Timestamp).toDate(),
        owner: UserData.fromJson(json['owner']),
        originalOwner: UserData.fromJson(json['originalOwner']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'img': img,
        'path': path,
        'repostId': repostId,
        'likeCount': likeCount,
        'dislikeCount': dislikeCount,
        'repostCount': repostCount,
        'date': Timestamp.fromDate(date),
        'owner': owner.toJson(),
        'originalOwner': originalOwner.toJson()
      };

  Post.fromSnapshot(snapshot) {
    id = snapshot.data()['id'];
    text = snapshot.data()['text'];
    img = snapshot.data()['img'];
    path = snapshot.data()['path'];
    repostId = snapshot.data()['repostId'];
    likeCount = snapshot.data()['likeCount'];
    dislikeCount = snapshot.data()['dislikeCount'];
    repostCount = snapshot.data()['repostCount'];
    date = (snapshot.data()['date'] as Timestamp).toDate();
    owner = UserData.fromJson(snapshot.data()['owner']);
    originalOwner = UserData.fromJson(snapshot.data()['originalOwner']);
  }

  void addComment(Comment newComment) {
    commentList.insert(0, newComment);
  }

  void addTopic(String topicName) {
    topics.add(topicName);
  }

  void likePost(UserData user) {
    if (usersLiked.contains(user)) {
      usersLiked.remove(user);
      likeCount--;
    } else {
      usersLiked.add(user);
      likeCount++;
      if (usersDisliked.contains(user)) {
        usersDisliked.remove(user);
      }
    }
  }

  bool isLikedBy(UserData user) {
    if (usersLiked.contains(user)) {
      return true;
    }
    return false;
  }

  void dislikePost(UserData user) {
    if (usersDisliked.contains(user)) {
      usersDisliked.remove(user);
      dislikeCount--;
    } else {
      usersDisliked.add(user);
      dislikeCount++;
      if (usersLiked.contains(user)) {
        usersLiked.remove(user);
      }
    }
  }

  bool isDislikedBy(UserData user) {
    if (usersDisliked.contains(user)) {
      return true;
    }
    return false;
  }

  void bookmarkPost(UserData user) {
    if (user.bookmarks.contains(this)) {
      user.bookmarks.remove(this);
    } else {
      user.bookmarks.add(this);
    }
  }

  bool isBookmarkedBy(UserData user) {
    if (user.bookmarks.contains(this)) {
      return true;
    }
    return false;
  }

  void repost(UserData user) {
    if (usersReposted.contains(user)) {
      user.postList.remove(this);
      usersReposted.remove(user);
      repostCount--;
    } else {
      user.postList.add(this);
      usersReposted.add(user);
      repostCount--;
    }
  }
}
