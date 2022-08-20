
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:project/classes/postClass.dart';
import 'package:project/classes/userClass.dart';
import 'package:project/classes/commentClass.dart';
import 'package:project/classes/notificationClass.dart';

Future deleteUser({required String UID}) async {
  await FirebaseStorage.instance.ref().child(UID).delete();
  await FirebaseFirestore.instance.collection('users').doc(UID).delete();
}

Future deleteSinglePost({required Post post}) async {
  await FirebaseStorage.instance.ref().child(post.path).delete();
  await FirebaseFirestore.instance.collection('users').doc(post.originalOwner.id)
      .collection('posts').doc(post.id).delete();
}

Future createUser({required UserData user, required String UID}) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(UID);
  user.id = docUser.id;
  final json = user.toJson();
  await docUser.set(json);
}

//create changed UserData before updating, Please blyat NEVER! change UID.
Future updateUserData({required UserData user}) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(user.id);
  user.id = docUser.id;
  final json = user.toJson();
  await docUser.update(json);
}

// upload post you have created in createPost view
Future uploadPost({required Post post}) async {
  final userPost = FirebaseFirestore.instance
      .collection('users').doc(post.originalOwner.id)
      .collection('posts').doc();
  post.id = userPost.id;
  final json = post.toJson();
  await userPost.set(json);
}

Future updatePost({required Post post}) async {
  final userPost = FirebaseFirestore.instance
      .collection('users').doc(post.originalOwner.id)
      .collection('posts').doc(post.id);
  final json = post.toJson();
  await userPost.update(json);
}

Future updateUsername({required UserData user,required String username}) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(user.id);
  user.id = docUser.id;
  user.username = username;
  final json = user.toJson();
  await docUser.set(json);

  final postList = readCurrentUserPostsFuture();
  int iterator = 0;
  await postList.then((value) async {
    for (var element in value) {
      element.originalOwner.username = username;
      element.owner.username = username;
      print (++iterator);
      await updatePost(post: element);
    }
  });
}

Future updatePhoto({
  required UserData user,
  required String imageURL,
  required String fileName}) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(user.id);
  user.photo = imageURL;
  user.profilePicturePath = user.id + "/profilePicture/" + fileName;
  final json = user.toJson();
  await docUser.update(json);

  final postList = readCurrentUserPostsFuture();
  int iterator = 0;
  await postList.then((value) async {
    for (var element in value) {
      element.originalOwner.photo = imageURL;
      element.owner.photo = imageURL;
      print (++iterator);
      await updatePost(post: element);
    }
  });
}

Future updateNameSurname({required UserData user,required String name, required String surname}) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(user.id);
  user.id = docUser.id;
  user.name = name;
  user.surname = surname;
  final json = user.toJson();
  await docUser.set(json);

  final postList = readCurrentUserPostsFuture();
  int iterator = 0;
  await postList.then((value) async {
    for (var element in value) {
      element.originalOwner.name = name;
      element.originalOwner.surname = surname;
      element.owner.name = name;
      element.owner.surname = surname;
      print (++iterator);
      await updatePost(post: element);
    }
  });
}

Future updateBio({required UserData user, required String bio}) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(user.id);
  user.id = docUser.id;
  user.bio = bio;
  final json = user.toJson();
  await docUser.set(json);

  final postList = readCurrentUserPostsFuture();
  int iterator = 0;
  await postList.then((value) async {
    for (var element in value) {
      element.originalOwner.bio = bio;
      element.owner.bio = bio;
      print (++iterator);
      await updatePost(post: element);
    }
  });
}
Future subscribe({required UserData content}) async{
  if(!content.privateProfile){
    final user = await FirebaseFirestore.instance
        .collection('users').doc(getUserID());
    final userF = await user.get();
    final folowers = userF.data();
    (folowers!['following'] as List).add(content);
    user.update(folowers);
    content.followers.add(UserData.fromJson(folowers));
    await FirebaseFirestore.instance.collection('user').doc(content.id).update(content.toJson());
  }
}
//Enter post which user is commenting on, and comment object
Future commentOnPost({required Post post, required Comment comment}) async {
  final docComment = FirebaseFirestore.instance
      .collection('users').doc(post.originalOwner.id)
      .collection('posts').doc(post.id)
      .collection('comments').doc();
  comment.id = docComment.id;
  final json = comment.toJson();
  await docComment.set(json);
}

Future<UserData> readUserFuture() async{
  final UID = getUserID();
  final docUser = FirebaseFirestore.instance.collection('users').doc(UID);
  final snapshot = await docUser.get();
  if (snapshot.exists) {
    return UserData.fromJson(snapshot.data()!);
  }
  return UserData();
}

//gives all users in firebase Future
Future<List<UserData>> readAllUsersFuture() async {
  final data = await FirebaseFirestore.instance.collection('users').get();
  final List<UserData> userList = List.from(data.docs.map((e) =>
      UserData.fromJson(e.data())));
  return userList;
}

Stream<List<UserData>> readAllUsers() =>
  FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((event) =>
      event.docs.map((doc) =>
          UserData.fromJson(doc.data())).toList());

Stream<UserData> readUser() {
  final UID = getUserID();
  return FirebaseFirestore.instance
      .collection('users')
      .doc(UID)
      .snapshots()
      .map((event) =>
      UserData.fromJson(event.data()!));
}
Stream<UserData> readUserByID({ required String ID }) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(ID)
      .snapshots()
      .map((event) =>
      UserData.fromJson(event.data()!));
}

Future<UserData> readUserByIDFuture({required String ID}) async{
  final docUser = FirebaseFirestore.instance.collection('users').doc(ID);
  final snapshot = await docUser.get();
  if (snapshot.exists) {
    return UserData.fromJson(snapshot.data()!);
  }
  return UserData();
}

Stream<List<Post>> readCurrentUserPosts() {
  final UID = getUserID();
  return FirebaseFirestore.instance
      .collection('users')
      .doc(UID)
      .collection('posts')
      .snapshots()
      .map((event) =>
      event.docs.map((doc) =>
          Post.fromJson(doc.data())).toList());
}

Stream<List<Post>> readUserPostsByID({required String userID}) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection('posts')
      .snapshots()
      .map((event) =>
      event.docs.map((doc) =>
          Post.fromJson(doc.data())).toList());
}

Future<List<Post>> readCurrentUserPostsFuture() async {
  final UID = getUserID();
  final data = await FirebaseFirestore.instance
      .collection('users')
      .doc(UID)
      .collection('posts')
      .get();
  final List<Post> postList = List.from(data.docs.map((e) => Post.fromSnapshot(e)));
  return postList;
}

// get posts of profile when looking at somebody's profile
Future<List<Post>> readViewedUserPosts({required String UID}) async {
  final data = await FirebaseFirestore.instance
      .collection('users')
      .doc(UID)
      .collection('posts')
      .get();
  final List<Post> postList = List.from(data.docs.map((e) => Post.fromSnapshot(e)));
  return postList;
}

Stream<List<Post>> createFeedPage(){
  final userID = getUserID();
  return FirebaseFirestore.instance
      .collection('users')
      .doc('qY67EOa4W3fjSRcd6W6bZoY7I8t1')
      .collection('posts')
      .snapshots()
      .map((event) =>
      event.docs.map((doc) =>
          Post.fromJson(doc.data())).toList());// return
}
// NOTIFICATIONS

// push notification to subcollection 'notifications'
Future pushNotification({required AppNotification ntfc, required String ownerID}) async {
  try{
    final userNotification = FirebaseFirestore.instance.collection('users').doc(
        ownerID)
        .collection('notifications').doc();
    ntfc.id = userNotification.id;
    final json = ntfc.toJson();
    await userNotification.set(json);
    print("success");
  }catch(err){
    print(err.toString());
  }
}
// delete notification with given id from subcollection 'notifications'
Future deleteNotification(String notificationId) async {
  try {
    final UID = getUserID();
    await FirebaseFirestore.instance.collection('users').doc(UID)
        .collection('notifications').doc(notificationId).delete();
    print("success");
  } catch (err) {
    print(err.toString());
  }
}
//TODO implement here if you want
Future deactive() async{
  var user = await FirebaseFirestore.instance.collection('users').doc(getUserID());
  var userD= await user.get();
  var userDatas = await userD.data();
  userDatas!['isDeactivated'] = true;
  var date = DateTime.now();
  date = date.add(const Duration(days:7));
  userDatas['deactivatedUntil'] = date.millisecondsSinceEpoch;
  await user.update(userDatas);
}

Future activate() async{
  var user = await FirebaseFirestore.instance.collection('users').doc(getUserID());
  var userD= await user.get();
  var userDatas = await userD.data();
  userDatas!['isDeactivated'] = false;
  await user.update(userDatas);
}
Future<bool> doesFollowing (DocumentReference<Map<String, dynamic>> data) async{
  final D = await data.get().then((value) => value.data());
  final id = getUserID();
  int x = 1;
  D!.forEach((key, value) {(value['id']) == id ? x*0 : x*1;});
  if(x == 0){
    return true;
  }
  return false;
}
Future connect({required String ID}) async{
  final docFollowing = FirebaseFirestore.instance
      .collection('users').doc(getUserID())
      .collection('following').doc();
  final sender = FirebaseFirestore.instance
      .collection('users').doc(getUserID());
  final reciver =  FirebaseFirestore.instance
      .collection('users').doc(ID);
  var reciverD = await reciver.get().then((value) => value.data());
  var senderD = await sender.get().then((value) => value.data());
  final docFollower = FirebaseFirestore.instance
      .collection('users').doc(ID).collection('followers').doc();
  print('bisiler oldu');
  if(reciverD!['privateProfile']){
      final docPendingFollower = reciver.collection('notifications').doc();
      final notf = AppNotification(username: senderD!['username'], action: "Tried to follow", date: DateFormat('MMMMEEEEd').format(DateTime.now()));
      notf.id = docPendingFollower.id;
      await docPendingFollower.set(notf.toJson());

  }
  else{
    final docPendingFollower = reciver.collection('notifications').doc();
    final notf = AppNotification(username: senderD!['username'], action: "Followed", date: DateFormat('MMMMEEEEd').format(DateTime.now()));
    notf.id = docPendingFollower.id;
    await docPendingFollower.set(notf.toJson());
    senderD['id'] = sender.id;
    reciverD['id'] = reciver.id;
    await docFollower.set(senderD);
    await docFollowing.set(reciverD);
  }
}
Future<List<List<UserData>>> readAllFollowers(String ID) async{
  return await FirebaseFirestore.instance.collection('users').doc().collection('followers').snapshots()
      .map((event) =>
      event.docs.map((doc) =>
          UserData.fromJson(doc.data())).toList()).toList();
}
// fetch all the notifications of current user
Stream<List<AppNotification>> readCurrentUserNotifications() {
  final UID = getUserID();
  // final user = readUser();
  // UserData userF  = UserData(); user.listen((event) {userF = event;});
  return FirebaseFirestore.instance
      .collection('users')
      .doc(UID)
      .collection('notifications')
      .snapshots()
      .map((event) =>
      event.docs.map((doc) =>
          AppNotification.fromJson(doc.data())).toList());
}

Future<String> getUsername() async{
  var user = await FirebaseFirestore.instance.collection('users').doc(getUserID());
  var userD= await user.get();
  var userDatas = await userD.data();
  return userDatas!['username'];
}

// POST BACKEND

// check from firebase if a post liked by current user
Future<bool> LikedByCurrUser({required userID, required postID}) async {
  try{
    final UID = getUserID();
    var post = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('posts')
        .doc(postID).get();
    var postData = post.data();
    if (postData!['likes'].contains(getUserID())){
      print('liked by Curr User');
      return true;
    }else{
      print('not liked by Curr User');
      return false;
    }
  }catch(err){
    print(err.toString());
  }
  return false;
}
// Toggle like function to Firestore
Future toggleLike({required userID, required postID}) async {
  try{
    print("Get UsEr Id is, $getUserID()");
    bool isLiked = await LikedByCurrUser(userID: userID, postID: postID);
    if (isLiked) {
      FirebaseFirestore.instance.collection('users')
          .doc(userID).collection('posts').doc(postID).update({
        'likes': FieldValue.arrayRemove([getUserID()]),
        'likeCount': FieldValue.increment(-1),
      });
    } else {
      FirebaseFirestore.instance.collection('users')
          .doc(userID).collection('posts').doc(postID).update({
        'likes': FieldValue.arrayUnion([getUserID()]),
        'likeCount': FieldValue.increment(1),
      });
    }
    print("toggle liked");
  }catch(err){
    print(err.toString());
  }
}

// check from firebase if a post disliked by current user
Future<bool> DislikedByCurrUser({required userID, required postID}) async {
  try{
    final UID = getUserID();
    var post = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('posts')
        .doc(postID).get();
    var postData = post.data();
    if (postData!['dislikes'].contains(UID)){
      print('disliked by Curr User');
      return true;
    }else{
      print('not disliked by Curr User');
      return false;
    }
  }catch(err){
    print(err.toString());
  }
  return false;
}
// toggle dislike function to Firestore
Future toggleDislike({required userID, required postID}) async {
  try{
    bool isDisliked = await DislikedByCurrUser(userID: userID, postID: postID);
    if (isDisliked) {
      FirebaseFirestore.instance.collection('users')
          .doc(userID).collection('posts').doc(postID).update({
        'dislikes': FieldValue.arrayRemove([getUserID()]),
        'dislikeCount': FieldValue.increment(-1),
      });
    } else {
      FirebaseFirestore.instance.collection('users')
          .doc(userID).collection('posts').doc(postID).update({
        'dislikes': FieldValue.arrayUnion([getUserID()]),
        'dislikeCount': FieldValue.increment(1),
      });
    }
    print("toggle disliked");
  }catch(err){
    print(err.toString());
  }
}

// check from firebase if a post saved by current user
Future<bool> SavedByCurrUser({required postID}) async {
  try{
    final UID = getUserID();
    var snap = await FirebaseFirestore.instance.collection('users').doc(UID)
        .collection('bookmarks').where('id', isEqualTo: postID).get();
    print(snap.size);
    return snap.size != 0;
  }catch(err){
    print(err.toString());
  }
  return false;
}
// toggle save to bookmark function to Firestore
Future toggleSave({required Post post}) async {
  try{
    bool isSaved = await SavedByCurrUser(postID: post.id);
    final UID = getUserID();
    if(isSaved){ // Delete from collection
      var snap = await FirebaseFirestore.instance.collection('users').doc(UID)
          .collection('bookmarks').where('id', isEqualTo: post.id ).get();

      snap.docs.forEach((element) {
           element.reference.delete();
         });

    }else{ // Add to collection
      final savedPost = FirebaseFirestore.instance.collection('users').doc(getUserID())
          .collection('bookmarks').doc();
      final json = post.toJson();
      await savedPost.set(json);
    }
    print('success');
  }catch(err){
    print(err.toString());
  }
}
// get posts in the bookmarks
Stream<List<Post>> readCurrentUserBookmarks() {
  final UID = getUserID();
  return FirebaseFirestore.instance
      .collection('users')
      .doc(UID)
      .collection('bookmarks')
      .snapshots()
      .map((event) =>
      event.docs.map((doc) =>
          Post.fromJson(doc.data())).toList());
}

// check from firebase if a post reposted by current user
Future<bool> RepostedByCurrUser({required userID, required postID}) async {
  try{
    final UID = getUserID();
    var post = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('posts')
        .doc(postID).get();
    var postData = post.data();
    if (postData!['reposts'].contains(UID)){
      print('reposted by Curr User');
      return true;
    }else{
      print('not reposted by Curr User');
      return false;
    }
  }catch(err){
    print(err.toString());
  }
  return false;
}

// toggle repost function to Firestore
Future toggleRepost({required Post post}) async {
  try{
    final user_id = post.originalOwner.id;
    final post_id = post.id;
    final UID = getUserID();
    final username = await getUsername();

    bool isReposted = await RepostedByCurrUser(userID: user_id, postID: post_id);
    if (isReposted) {
      FirebaseFirestore.instance.collection('users')
          .doc(user_id).collection('posts').doc(post_id).update({
        'reposts': FieldValue.arrayRemove([UID]),
        'repostCount': FieldValue.increment(-1),
      });
      // delete post from current user posts collection
      var snap = await FirebaseFirestore.instance.collection('users').doc(UID)
          .collection('posts').where('repostId', isEqualTo: post.id ).get();
      snap.docs.forEach((element) {
        element.reference.delete();
      });

    } else {
      FirebaseFirestore.instance.collection('users')
          .doc(user_id).collection('posts').doc(post_id).update({
        'reposts': FieldValue.arrayUnion([UID]),
        'repostCount': FieldValue.increment(1),
      });
      // add post as new post to current user posts collection
      final repostedPost = FirebaseFirestore.instance.collection('users').doc(UID)
            .collection('posts').doc();
      post.repostId = post.id;
      post.id = repostedPost.id;
      post.likeCount = 0;
      post.dislikeCount = 0;
      post.repostCount = 0;
      post.originalOwner.id = UID == null ? '' : UID;
      post.originalOwner.username = username;
      post.owner.id = UID == null ? '' : UID;
      post.owner.username = username;
      final json = post.toJson();
      await repostedPost.set(json);
    }
    print("toggle reposted");
  }catch(err){
    print(err.toString());
  }
}

// add comment to firebase
Future addComment({required userID, required postID, required Comment cmnt}) async {
  try{
    FirebaseFirestore.instance.collection('users')
        .doc(userID).collection('posts').doc(postID).update({
        'comments': FieldValue.arrayUnion([cmnt.toJson()]),
        //'commentCount': FieldValue.increment(1),
    });
    print('Comment inserted');
  }catch(err){
    print(err.toString());
  }
}

// read all comments of a post
Future<List<Comment>> getCommentsOfPost({required userID, required postID}) async {
  var data = await FirebaseFirestore.instance.collection('users').doc(userID)
      .collection('posts').doc(postID).get().then((value) => value.data());
  if (data!.containsKey('comments')){
    print('data contains comments');
    var  cmntList = data['comments'] as List<dynamic>;
    return cmntList.map((cmnt) =>
      Comment.fromJson(cmnt)).toList();
  }
  print('data not contains comments');
  print(data);
  List<Comment> empty = [];
  return empty;

}
// read all posts as stream
Stream<List<Post>> readAllPosts() {
  return FirebaseFirestore.instance.collectionGroup('posts').snapshots()
      .map((event) =>
      event.docs.map((doc) =>
          Post.fromJson(doc.data())).toList());
}


// isUsernameUnique(username) async {
//   try {
//     final w = FirebaseFirestore.instance
//         .collection('users').get().then((value) =>
//     value.docs.where((element) => element.get(element.));
//
//   } catch (e) {
//     debugPrint(e.toString());
//   }
// }


// Future<bool> isUsernameUnique(String email) async {
//   bool isUsernameUnique = true;
//   readAllUsers().listen((event) {
//     for (UserData object in event) {
//       if (object.email == email) {
//         isUsernameUnique = false;
//       }
//     }
//   });
//   return Future.value(isUsernameUnique);
// }




//final user = snapshot.data!.firstWhere((element) => element.id == Globals.UID, orElse: ()=>UserData());



// Future<bool> usernameCheck(String username) async {
//   final result = await FirebaseFirestore.instance
//       .collection('users')
//       .where('username', isEqualTo: username)
//   .get();
//   return result.isEmpty;
// }
//
// Future<void> availableUsername(String username) async {
//   //exit if the username is not valid
//   if (validateUsername(username) != null) return;
//
//   //save the username
//   _formKey.currentState.save();
//   setState(() => _checkingForUsername = true);
//
//   userNameAvailable = await handleRequest(() => userProvider.checkUserName(username), widget.scaffoldKey.currentContext);
//
//   setState(() => _checkingForUsername = false);
//   return;
// }
//
// Future<bool> checkUserName(String calledValue) async {
//   //wait a second, is the user finished typing ?
//   //if the given value != [_username] this means another instance of this method is called and it will finish the mission
//   await Future.delayed(Duration(seconds: 1,milliseconds: 500));
//   if (calledValue != _userName) {
//     print('cancel username check ');
//     return null;
//   }
//   final result = await FirebaseFirestore.instance.collection('usernames').doc(_userName).get();
//
//   print('is Exist:  ${result.exists}');
//   return !result.exists;
//
// }



String? getUserID() => FirebaseAuth.instance.currentUser?.uid;



// final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
// final GoogleSignIn _googleSignIn = new GoogleSignIn();
// void initState(){
//   super.initState();
//   firebaseAuth.onAuthStateChanged
//       .firstWhere((user) => user != null)
//       .then((user) {
//     String user_Name = user.displayName;
//     String image_Url = user.photoUrl;
//     String email_Id = user.email;
//     String user_Uuid = user.uid; // etc
//   }
//       // Give the navigation animations, etc, some time to finish
//       new Future.delayed(new Duration(seconds: 2))
//       .then((_) => signInWithGoogle());
// }
//
// Future<FirebaseUser> signInWithGoogle() async {
//   // Attempt to get the currently authenticated user
//   GoogleSignInAccount currentUser = _googleSignIn.currentUser;
//   if (currentUser == null) {
//     // Attempt to sign in without user interaction
//     currentUser = await _googleSignIn.signInSilently();
//   }
//   if (currentUser == null) {
//     // Force the user to interactively sign in
//     currentUser = await _googleSignIn.signIn();
//   }
//
//   final GoogleSignInAuthentication googleAuth =
//   await currentUser.authentication;
//
//   // Authenticate with firebase
//   final FirebaseUser user = await firebaseAuth.signInWithGoogle(
//     idToken: googleAuth.idToken,
//     accessToken: googleAuth.accessToken,
//   );
//
//   assert(user != null);
//   assert(!user.isAnonymous);
//
//   return user;
// }