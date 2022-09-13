import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:poetic_app/features/models/post.dart';
import 'package:poetic_app/features/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> uploadPost(
    List categorytype,
    String description,
    Uint8List? file,
    String color,
    String type,
    double size,
    String font,
    List _colorGradient,
    String bgImage,
  ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    String photoUrl = '';

    try {
      if (file != null) {
        photoUrl =
            await StorageMethods().uploadImageToStorage('posts', file, true);
      }
      // DocumentSnapshot snap = await _firestore
      //     .collection("users")
      //     .doc(_auth.currentUser!.uid)
      //     .get();

      // final username = (snap.data()! as dynamic)['username'];

      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: _auth.currentUser!.uid,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        type: type,
        colorCode: color,
        size: size,
        font: font,
        category: categorytype,
        gradient: _colorGradient,
        bgImage: bgImage,
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  List setCategory(String val) {
    var ex = val.split('/').last;

    return [ex[0].trim(), ex[1].trim()];
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post share
  Future<String> postShare(String postId, String uid) async {
    String res = "Some error occurred";
    try {
      // if the likes list contains the user uid, we need to remove it
      String shareId = const Uuid().v1();
      _firestore
          .collection('posts')
          .doc(postId)
          .collection('shares')
          .doc(shareId)
          .set({
        'postId': postId,
        'uid': uid,
        'shareId': shareId,
        'datePublished': DateTime.now(),
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (_) {}
  }

  Future<void> chatUser({required String uid, required String followId}) async {
    try {
      _firestore.collection('users').doc(uid).update({
        // 'people': FieldValue.arrayUnion([followId])
        'people.$followId': FieldValue.serverTimestamp()
      });
    } catch (_) {}
  }

  Future<String> updatePost(
    String description,
    String postId,
    String color,
    double size,
    String font,
    String bgImage,
    List gradient,
  ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";

    try {
      // String postId = const Uuid().v1(); // creates unique id based on time

      _firestore.collection('posts').doc(postId).update({
        'colorCode': color,
        'description': description,
        'size': size,
        'font': font,
        'bgImage': bgImage,
        'gradient': gradient,
        'datePublished': DateTime.now(),
      });
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}


// hello iqayum, Did your country have some software developer a job? if can you tell me