import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  // final String username;
  // ignore: prefer_typing_uninitialized_variables
  final likes;
  final String postId;
  final DateTime datePublished;
  final String? postUrl;

  //
  final String font;
  final double size;
  final String colorCode;
  final String type;
  final List category;
  final List gradient;
  final String bgImage;

  const Post({
    required this.description,
    required this.uid,
    // required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.postUrl,

    //
    required this.colorCode,
    required this.size,
    required this.font,
    required this.type,
    required this.category,
    required this.gradient,
    required this.bgImage,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        // username: snapshot["username"],
        postUrl: snapshot['postUrl'],

        //
        size: snapshot["size"],
        font: snapshot["font"],
        type: snapshot["type"],
        category: snapshot["category"],
        gradient: snapshot["gradient"],
        bgImage: snapshot['bgImage'],
        colorCode: snapshot["colorCode"]);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'size': size,
        'font': font,
        'gradient': gradient,
        'colorCode': colorCode,
        'type': type,
        'bgImage': bgImage,
        'category': category
      };
}
