import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/classes/firestoreFunctions.dart';
import 'package:project/classes/postClass.dart';
import 'package:project/classes/userClass.dart';
import 'package:project/util/colors.dart';
import 'package:project/util/styles.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditPost extends StatefulWidget {
  Post editPost;
  final UserData user;
  List<String> postTopics = [];
  bool changedPicture = false;
  EditPost({Key? key, required this.user, required this.editPost})
      : super(key: key);

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final postTextController = TextEditingController();
  late String fileName;
  late File? imagefile;

  Future<void> _showDialog(String title, String message) async {
    bool isAndroid = Platform.isAndroid;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          if(isAndroid) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(message),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          } else {
            return CupertinoAlertDialog(
              title: Text(title, style: kBoldLabelStyle),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(message, style: kLabelStyle),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {});
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Post"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.text_fields_rounded,
                size: 48,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              child: TextFormField(
                minLines: 1,
                maxLines: 10,
                keyboardType: TextInputType.text,
                onEditingComplete: () {
                  setState(() {});
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: postTextController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.comment),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: const BorderSide()),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: kBoldLabelStyle,
                    fillColor: AppColors.textFieldFillColor,
                    filled: true,
                    hintText: "Enter post text"),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              child: const Divider(
                color: AppColors.primary,
                thickness: 0.5,
                height: 10,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      await addTopic(
                          context, widget.user, widget.editPost, widget.postTopics);
                      setState(() {});
                    },
                    child: const Text("Add Topic"),
                    style: OutlinedButton.styleFrom(
                      primary: AppColors.darkButtonTextColor,
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text("Add Location"),
                    style: OutlinedButton.styleFrom(
                      primary: AppColors.darkButtonTextColor,
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              child: const Divider(
                color: AppColors.primary,
                thickness: 0.5,
                height: 10,
              ),
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.photo,
                          size: 48,
                          color: AppColors.likeButton,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlinedButton(
                              onPressed: () async {
                                final XFile? image = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                imagefile = File(image!.path);
                                fileName = image.name;
                                widget.editPost.image = imagefile;
                                widget.changedPicture = true;
                                setState(() {});
                              },
                              child: const Text("Add Photo"),
                              style: OutlinedButton.styleFrom(
                                primary: AppColors.darkButtonTextColor,
                                backgroundColor: AppColors.primary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlinedButton(
                              onPressed: () async {
                                final XFile? image = await ImagePicker()
                                    .pickImage(source: ImageSource.camera);
                                imagefile = File(image!.path);
                                fileName = image.name;
                                widget.editPost.image = imagefile;
                                widget.changedPicture = true;
                                setState(() {});
                              },
                              child: const Text("Take Photo"),
                              style: OutlinedButton.styleFrom(
                                primary: AppColors.darkButtonTextColor,
                                backgroundColor: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  // const VerticalDivider(
                  //   width: 100,
                  //   thickness: 0.5,
                  //   color: AppColors.primary,
                  // ),
                  // Column(
                  //   children: [
                  //     const Padding(
                  //       padding: EdgeInsets.all(8.0),
                  //       child: Icon(Icons.videocam),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: OutlinedButton(
                  //         onPressed: () async {
                  //           final XFile? image = await ImagePicker()
                  //               .pickVideo(source: ImageSource.gallery);
                  //           final File? imagefile = File(image!.path);
                  //           newPost.image = imagefile;
                  //           setState(() {});
                  //         },
                  //         child: const Text("Add Video"),
                  //         style: OutlinedButton.styleFrom(
                  //           primary: AppColors.darkButtonTextColor,
                  //           backgroundColor: AppColors.primary,
                  //         ),
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: OutlinedButton(
                  //         onPressed: () async {
                  //           final XFile? image = await ImagePicker()
                  //               .pickVideo(source: ImageSource.camera);
                  //           final File? imagefile = File(image!.path);
                  //           newPost.image = imagefile;
                  //           setState(() {});
                  //         },
                  //         child: const Text("Take Video"),
                  //         style: OutlinedButton.styleFrom(
                  //           primary: AppColors.darkButtonTextColor,
                  //           backgroundColor: AppColors.primary,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              child: const Divider(
                color: AppColors.primary,
                thickness: 0.5,
                height: 10,
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.all(8),
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: [
                  Column(children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: widget.editPost.image != null
                          ? FittedBox(
                              fit: BoxFit.contain,
                              child: Image.file(widget.editPost.image!))
                          : CachedNetworkImage(
                              imageUrl: widget.editPost.img,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                    ),
                    for (int i = 0; i < widget.postTopics.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          widget.postTopics[i],
                          style: kTopicStyle,
                        ),
                      ),
                  ]),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        postTextController.text,
                        style: kBoldLabelStyle,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () async {
            if (widget.changedPicture || postTextController.text.isNotEmpty) {
              if (widget.changedPicture) {
                final imageURL = await updateImage(
                    user: widget.user, object: imagefile!, newObjName: fileName,
                    post: widget.editPost);
                widget.editPost.img = imageURL;
                widget.editPost.path = widget.user.id + "/posts/images/" + fileName;
              }
              widget.editPost.date = DateTime.now();
              widget.editPost.text = postTextController.text;
              updatePost(post: widget.editPost);
              Navigator.of(context).pushNamedAndRemoveUntil('/profileView', (route) => false);
            } else {
              _showDialog('Dear User', 'You have not changed anything!');
            }
          },
          child: const Icon(
            Icons.check,
          ),
        ),
      ),
    );
  }
}

Future<void> addTopic(BuildContext context, UserData user, Post post,
    List<String> postTopics) async {
  final topicController = TextEditingController();

  await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => AlertDialog(
      scrollable: true,
      content: Column(children: [
        TextFormField(
          maxLength: 20,
          minLines: 1,
          maxLines: 10,
          keyboardType: TextInputType.multiline,
          controller: topicController,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.comment),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: const BorderSide()),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: kBoldLabelStyle,
              fillColor: AppColors.textFieldFillColor,
              filled: true,
              hintText: "Enter topic"),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  !postTopics.contains(topicController.text)
                      ? postTopics.add(topicController.text)
                      : null;
                  !user.topicList.contains(topicController.text)
                      ? user.topicList.add(topicController.text)
                      : null;
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.check_circle,
                  color: AppColors.likeButton,
                ),
                iconSize: 36,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.cancel,
                  color: AppColors.dislikeButton,
                ),
                iconSize: 36,
              ),
            ],
          ),
        )
      ]),
    ),
  );
}

Future<String> updateImage(
    {required UserData user,
    required File object,
    required String newObjName,
    required Post post}) async {
  UploadTask? uploadTask;
  FirebaseStorage.instance.ref().child(post.path).delete();
  final path = user.id + "/posts/images/" + newObjName;
  final ref = FirebaseStorage.instance.ref().child(path);
  uploadTask = ref.putFile(object);
  final snapshot = await uploadTask.whenComplete(() {});
  final urlDownload = await snapshot.ref.getDownloadURL();
  return urlDownload;
}
