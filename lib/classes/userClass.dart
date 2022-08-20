import 'package:project/classes/postClass.dart';

class UserData {
  bool privateProfile = false, isDeactivated = false;
  String username = '',
      email = '',
      name = '',
      surname = '',
      bio = '',
      password = '',
      photo = '',
      id = '',
      profilePicturePath = '';

  int postIterator = 1,deactivatedUntil = 0;

  UserData({
    this.privateProfile = false,
    this.username = '',
    this.email = '',
    this.name = '',
    this.surname = '',
    this.password = '',
    this.photo = '',
    this.id = '',
    this.postIterator = 1,
    this.bio = '',
    this.isDeactivated = false,
    this.deactivatedUntil = 0,
    this.profilePicturePath = ''
  });

  get getUsername => username == '' ? 'No username' : username;
  get getFullName => name == '' ? 'No name' : name+' '+surname;
  get getEmail => email == '' ? 'No email' : email;
  get getPhoto => photo == '' ? 'No photo' : photo;

//Notification listesi eklenip friend requestle privateların listeye gönderilebilir
  List<String> topicList = [];
  List<Post> postList = [];
  List<Post> bookmarks = [];
  List<UserData> followers = [];
  List<UserData> following = [];
  List<UserData> pendingFollowers = [];
  addPost(List<Post> postList) {
    this.postList = postList;
  }

  followUnfollow(UserData friend) {
    following.contains(friend)
        ? following.remove(friend)
        : following.add(friend);
    //İkinci satırda private mı kontrol edip ona göre devam etmesi lazım 2. if else checkle
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'name': name,
        'surname': surname,
        'password': password,
        'photo': photo,
        'postIterator': postIterator,
        'privateProfile': privateProfile,
        'bio': bio,
        'isDeactivated': isDeactivated,
        'deactivatedUntil': deactivatedUntil,
        'profilePicturePath': profilePicturePath
      };

  static UserData fromJson(Map<String, dynamic> json) => UserData(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        name: json['name'],
        surname: json['surname'],
        password: json['password'],
        photo: json['photo'],
        postIterator:  json['postIterator'],
        privateProfile: json['privateProfile'],
        isDeactivated:json['isDeactivated'],
        bio: json['bio'],
        deactivatedUntil: json['deactivatedUntil'],
        profilePicturePath: json['profilePicturePath']
  );
}