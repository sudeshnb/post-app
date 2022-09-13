import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'poetic_app.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  getMessageUid(message.data['id']!);
  RemoteNotification? onappnotification = message.notification;

  if (onappnotification != null) {
    flutterLocalNotificationsPlugin.show(
      onappnotification.hashCode,
      onappnotification.title,
      onappnotification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '0',
          'channelname',
          importance: Importance.high,
          priority: Priority.high,
          icon: 'ic_launcher',
        ),
      ),
    );
  }
}

late AndroidNotificationChannel channel;

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // if (!kIsWeb) {
  //   channel = const AndroidNotificationChannel(
  //     'high_importance_channel', // id
  //     'High Importance Notifications', // title
  //     // description
  //     importance: Importance.high,
  //   );

  //   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // await FirebaseMessaging.instance
  //     .setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  // }

  runApp(const PoeticApp());
}

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
getMessageUid(String uid) async {
  DocumentSnapshot snap =
      await firestore.collection("users").doc(auth.currentUser!.uid).get();
  List people = (snap.data()! as dynamic)['people'];

  if (!people.contains(uid)) {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'people': FieldValue.arrayUnion([uid])
    });
  }
}
