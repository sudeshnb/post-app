import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;
  // input second page
  // final String gender;
  final List languages;
  final List people;
  final String status;
  final String country;
  final List interst;
  final List socialLinks;
  final String phoneNo;
  final String accountType;
  final String token;

  const User({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.status,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    // my
    required this.languages,
    required this.accountType,
    required this.country,
    // required this.gender,
    required this.interst,
    required this.phoneNo,
    required this.socialLinks,
    required this.token,
    required this.people,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    var snapshot2 = [];
    // List<dynamic>.generate(
    //     snapshot["socialLinks"].length, (index) => snapshot2.add(index));

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],

      status: snapshot["status"],
      languages: snapshot["languages"],
      accountType: snapshot["accountType"],
      country: snapshot["country"],

      interst: snapshot["interst"],
      phoneNo: snapshot["phoneNo"],
      socialLinks: snapshot2,
      token: snapshot["token"],
      // people: snapshot['people'],
      people: snapshot2,
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
        //
        "status": status,
        "accountType": accountType,
        "languages": languages,
        "country": country,
        // "gender": gender,
        "interst": interst,
        "phoneNo": phoneNo,
        "socialLinks": socialLinks,
        "token": token,
        'people': people,
      };
}
