import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poetic_app/features/screens/add_post_screen.dart';
import 'package:poetic_app/features/screens/chat/people.dart';
import 'package:poetic_app/features/screens/feed_screen.dart';
import 'package:poetic_app/features/screens/profile_screen.dart';
import 'package:poetic_app/features/screens/widgets/charts.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  AcoountsChartPage(),
  const AddPostScreen(),
  const PeoplePage(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
const String friendPic = 'https://i.stack.imgur.com/l60Hf.png';

List<String> accountTypes = [
  "Writer/poet",
  "Playback singer/audio recorder",
  "Composer/publisher",
  "Marketing promoter/advertiser",
  "General user",
];
List fonts = [
  {'name': 'App Symbols', 'font': 'AppSymbols'},
  {'name': 'Comfortaa', 'font': 'Comfortaa'},
  {'name': 'Avenir', 'font': 'avenir'},
  {'name': 'Tw Cen MT', 'font': 'TW CEN MT'},
  {'name': 'Hurricane', 'font': 'Hurricane'},
  {'name': 'Oswald', 'font': 'Oswald'},
  {'name': 'Nunito', 'font': 'Nunito'},
  {'name': 'Teko', 'font': 'Teko'},
  {'name': 'Pacifico', 'font': 'Pacifico'},
  {'name': 'Anton', 'font': 'Anton'},
  {'name': 'Noto Serif', 'font': 'NotoSerif'},
  {'name': 'Raleway', 'font': 'Raleway'},
  {'name': 'Rubik Moonrocks', 'font': 'RubikMoonrocks'},
  //
  {'name': 'Lobster', 'font': 'Lobster'},
  {'name': 'Inconsolata', 'font': 'Inconsolata'},
  {'name': 'ZenLoop', 'font': 'ZenLoop'},
  {'name': 'Merriweather', 'font': 'Merriweather'},
  {'name': 'Macondo', 'font': 'Macondo'},
  {'name': 'Koulen', 'font': 'Koulen'},
];
