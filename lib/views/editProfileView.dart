import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/util/auth.dart';
import 'package:project/util/colors.dart';
import 'package:project/util/styles.dart';
import 'package:project/views/changeUsername.dart';
import 'package:project/views_initial/errorScreen.dart';
import 'package:project/views_initial/waitingScreen.dart';

import '../classes/firestoreFunctions.dart';
import '../classes/userClass.dart';
import 'changeBio.dart';
import 'changeNameSurname.dart';



class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  bool showPassword = false;
  late Stream<UserData> streamer;

  final passwordTextController = TextEditingController();
  final locationTextController = TextEditingController();

  late String fileName;
  late File imagefile;
  late XFile? image;

  @override
  void initState() {
    streamer = readUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: streamer,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreen(message: snapshot.toString());
          }
          if (!snapshot.hasData) {
            return const WaitingScreen();
          } else {
            final user = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                elevation: 1,
                centerTitle: true,
                title: const Text("Edit Profile"),
              ),
              body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 4,
                                      color: Theme.of(context).scaffoldBackgroundColor),
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        color: AppColors.primary,
                                        offset: Offset(0, 10))
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        user.photo,
                                      )
                                  )
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                    ),
                                    color: AppColors.primary,
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    iconSize: 20,
                                    icon: Icon(
                                      Icons.add_photo_alternate,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      image = (await ImagePicker()
                                          .pickImage(source: ImageSource.camera));
                                      if (image != null) {
                                        imagefile = File(image!.path);
                                        fileName = image!.name;
                                        final imageURL = await uploadImage(
                                            user: user,
                                            object: imagefile,
                                            objName: fileName);
                                        final filename = user.id +
                                            "/profilePicture/" + fileName;
                                        await updatePhoto(user: user,
                                          fileName: filename,
                                          imageURL: imageURL,);
                                        print('i have been here');
                                      }
                                    },
                                  ),
                                )
                            ),
                            Positioned(
                                bottom: 0,
                                right: 90,
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                    ),
                                    color: AppColors.primary,
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    iconSize: 20,
                                    icon: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      image = (await ImagePicker()
                                          .pickImage(source: ImageSource.camera));
                                      if (image != null) {
                                        imagefile = File(image!.path);
                                        fileName = image!.name;
                                        final imageURL = await uploadImage(
                                            user: user,
                                            object: imagefile,
                                            objName: fileName);
                                        final filename = user.id +
                                            "/profilePicture/" + fileName;
                                        await updatePhoto(user: user,
                                          fileName: filename,
                                          imageURL: imageURL,);
                                        print('i have been here');
                                      }
                                    },
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      buildTextField("Full Name", user.name+' '+user.surname, false, null),
                      buildTextField("E-mail", user.email, false, null),
                      buildTextField("Password", user.password, showPassword, passwordTextController),
                      buildTextField("Last Locations", "Pendik, Istanbul", false, null),

                      Row(
                        mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                        children: [

                          OutlinedButton(
                            onPressed: () {
                              passwordTextController.clear();
                              setState(() {});
                            },
                            child: Text("Cancel",
                                style:kBoldLabelStyle),
                          ),

                          ElevatedButton( // ElevatedButton
                              onPressed: () async {
                                final String password = passwordTextController.text;
                                if (password.length < 6) {
                                  _showDialog(context, 'Incorrect Password', 'Password is short, enter at least 6 characters');
                                }
                                else {
                                  user.password = password;
                                  await updateUserData(user: user);
                                  await FirebaseAuth.instance.currentUser?.updatePassword(password);
                                  await _showDialog(context, 'Success', 'Your password has been changed successfully');
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(AppColors.primary),
                                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 50)),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                              ),
                              child: const Text(
                                "SAVE",
                                style: TextStyle(),
                              )
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      Text(
                        "Settings",
                        style: kBoldLabelStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: AppColors.primary,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Account",
                            style: kBoldLabelStyle,
                          ),
                          const Divider(
                            height: 15,
                            thickness: 2,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      buildAccountOptionRow(context, "Account Privacy", user),
                      accountManipulations(context, "Sign Out", "Do you want to sign out?", user),
                      accountManipulations(context, 'Delete Account', "Do you want to delete you account? (irreversible)", user),
                      //TODO here
                      accountManipulations(context, "Deactivate Account", "Do you want to deactivate your account? (irreversible for one week)", user),
                      accountManipulations(context, "Change Username", "Do you want to change your Username? (might lose previous username)", user),
                      accountManipulations(context, "Change Name & Surname", "Do you want to change your Name and Surname?", user),
                      accountManipulations(context, "Change Bio", "Do you want to change your Bio?", user),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
    );
  }

  Widget buildTextField(String labelText, String placeholder, bool isPassword,
      TextEditingController? controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        readOnly: labelText == 'Password'? false:true,
        onTap: (){setState(() {});},
        keyboardType: TextInputType.visiblePassword,
        enableSuggestions: labelText == 'Password'? false:true,
        controller: controller,
        obscureText: !showPassword,
        decoration: InputDecoration(
            suffixIcon: labelText == 'Password'? isPassword ?
            IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: const Icon(
                Icons.visibility_off,
                color: AppColors.navigatorBarColor,
              ),
            )
                :
            IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: const Icon(
                Icons.remove_red_eye,
                color: AppColors.navigatorBarColor,
              ),
            )
                : null,
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: labelText == 'Password'? (!isPassword? '******': placeholder): placeholder,
            hintStyle: kEditProfileHintTextStyle),
      ),
    );
  }
}

GestureDetector buildAccountOptionRow(BuildContext context, String title, UserData user) {
  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(child: Text('Make my Account')),
              actions: [
                Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () async {
                        user.privateProfile = true;
                        await updateUserData(user: user);
                        Navigator.of(context).pop();
                        await _showDialog(context, 'Success', 'Your Profile is Private now');
                        },
                      child: const Text('Private')
                    ),
                    TextButton(
                        onPressed: () async {
                          user.privateProfile = false;
                          await updateUserData(user: user);
                          Navigator.of(context).pop();
                          await _showDialog(context, 'Success', 'Your Profile is Public now');
                        },
                        child: const Text('Public')
                    ),
                  ],
                ),
              ],
            );
          });
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: kEditProfileTextStyle
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.navigatorBarColor,
          ),
        ],
      ),
    ),
  );
}

GestureDetector accountManipulations(BuildContext context, String title, String content, UserData user) {
  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [ Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      child: const Text("Yes"),
                      onPressed: () async {
                        if (title == 'Sign Out') {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
                        } else if (title == 'Delete Account') {
                          await deleteFromStorage(userID: user.id);
                          await FirebaseFirestore.instance.collection('users').doc(user.id).collection('posts').
                          get().then((querySnapshot) => {
                              querySnapshot.docs.forEach((element) async {await element.reference.delete();
                              })
                          });
                          await FirebaseFirestore.instance.collection('users').doc(user.id).collection('bookmarks').
                          get().then((querySnapshot) => {
                            querySnapshot.docs.forEach((element) async {await element.reference.delete();
                            })
                          });
                          await FirebaseFirestore.instance.collection('users').doc(user.id).collection('notifications').
                          get().then((querySnapshot) => {
                            querySnapshot.docs.forEach((element) async {await element.reference.delete();
                            })
                          });
                          await FirebaseFirestore.instance.collection('users').doc(user.id).collection('followers').
                          get().then((querySnapshot) => {
                            querySnapshot.docs.forEach((element) async {await element.reference.delete();
                            })
                          });
                          await FirebaseFirestore.instance.collection('users').doc(user.id).collection('following').
                          get().then((querySnapshot) => {
                            querySnapshot.docs.forEach((element) async {await element.reference.delete();
                            })
                          });
                          await FirebaseFirestore.instance.collection('users').doc(user.id).delete();
                          await FirebaseAuth.instance.currentUser?.delete();
                          Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
                        } else if (title == "Deactivate Account"){
                          await deactive();
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
                        } else if (title == 'Change Username') {
                          Navigator.of(context).pop();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeUsername(user: user)));
                        } else if (title == 'Change Name & Surname') {
                          Navigator.of(context).pop();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNameSurname(user: user)));
                        } else if (title == 'Change Bio') {
                          Navigator.of(context).pop();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeBio(user: user)));
                        }
                      }
                  ),
                  const Spacer(flex: 1),
                  TextButton(
                      child: const Text("No"),
                      onPressed: () =>Navigator.of(context).pop()
                  ),
                ],) ],
            );
          }
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              title,
              style: kEditProfileTextStyle
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.navigatorBarColor,
          ),
        ],
      ),
    ),
  );
}

Future<String> uploadImage ({required UserData user, required File object, required String objName}) async {
  UploadTask? uploadTask;
  FirebaseStorage.instance.ref().child(user.profilePicturePath).delete();
  final path = user.id + "/profilePicture/" + objName;
  final ref = FirebaseStorage.instance.ref().child(path);
  uploadTask = ref.putFile(object);
  final snapshot = await uploadTask.whenComplete((){});
  final urlDownload = await snapshot.ref.getDownloadURL();
  return urlDownload;
}

Future<void> _showDialog(BuildContext context, title, String message) async {
  bool isAndroid = Platform.isAndroid;
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        if (isAndroid) {
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

Future deleteFromStorage({required String userID}) async {
  await FirebaseStorage.instance.ref(userID+"/posts/images").listAll().then((value) {
    for (var element in value.items) {
      FirebaseStorage.instance.ref(element.fullPath).delete();
    }}
  );
  await FirebaseStorage.instance.ref(userID+"/profilePicture").listAll().then((value) {
    for (var element in value.items) {
      FirebaseStorage.instance.ref(element.fullPath).delete();
    }}
  );
}