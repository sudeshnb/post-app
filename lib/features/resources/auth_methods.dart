import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:poetic_app/features/models/user.dart' as model;
import 'package:poetic_app/features/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // Signing Up User

  Future<String> signUpUser({
    required String token,
    required String email,
    required String password,
    required String username,
    required Uint8List? file,
    // required String country,
    // required String phoneNo,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          file != null) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file!, false);

        model.User _user = model.User(
          username: username,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          email: email,
          bio: '',
          followers: [],
          following: [],
          status: 'online',
          languages: [],
          country: '',
          interst: [],
          phoneNo: '',
          accountType: '',
          socialLinks: [],
          token: token,
          people: [],
        );

        // adding user in our database
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(_user.toJson());

        res = "Success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  //
  Future<String> accounteSetUp({
    // required String gender,
    required String country,
    required String phoneNo,
    required List interst,
    required String accountType,
  }) async {
    String res = "Some error Occurred";
    try {
      //get registered user id
      var uid = _auth.currentUser!.uid;
      CollectionReference users = _firestore.collection('users');
      // update user in our database
      await users.doc(uid).update({
        'country': country,
        'phoneNo': phoneNo,
        'accountType': accountType,
        'interst': interst,
      });

      res = "success";
    } catch (err) {
      return err.toString();
    }
    return res;
  }

//
  Future<void> signOut() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({'status': 'offline'});
    await _auth.signOut();
  }
  //

  Future<String> deleteAcconut() async {
    String res = 'Some error Occurred';
    try {
      await _auth.currentUser!.delete();
      res = 'Success';
    } catch (_) {}
    return res;
  }

  Future<String> deletePosts() async {
    // ignore: unused_local_variable
    String res = 'Some error Occurred';

    try {
      //get registered user id
      var uid = _auth.currentUser!.uid;
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      // delete Post
      await _firestore
          .collection('posts')
          .where('uid', isEqualTo: _auth.currentUser!.uid)
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          _firestore.collection('posts').doc(doc["postId"]).delete();
        }
      });

      //get registered user id
      DocumentSnapshot snap = await users.doc(uid).get();
      List followers = (snap.data()! as dynamic)['followers'];

      for (int doc = 0; doc < followers.length; doc++) {
        users.doc(followers[doc]).update({
          'following': FieldValue.arrayRemove([uid])
        });
      }
      List people = (snap.data()! as dynamic)['people'];
      for (int i = 0; i < followers.length; i++) {
        users.doc(people[i]).update({
          'people': FieldValue.arrayRemove([uid])
        });
      }
      // delete Post
      await users.doc(_auth.currentUser!.uid).delete();
      res = 'Success';
    } catch (_) {}

    return res;
  }
}
