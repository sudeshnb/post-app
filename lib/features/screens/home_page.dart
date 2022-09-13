import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poetic_app/core/routes/routes.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/theme/app_theme.dart';
import 'package:poetic_app/core/utils/global_variable.dart';
import 'package:poetic_app/features/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _page = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isNotGeneralUser = false;
  String senderName = '';
  late PageController pageController; // for tabs animation
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    setOnlineStatus('available');
    super.initState();
    addData();
    requestPermission();
    pageController = PageController();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        final chat = MessageArguments(
          friendName: message.notification!.title!,
          friendUid: message.data['id']!,
        );
        Navigator.of(context).pushNamed('/ChatDetail', arguments: chat);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage onappmessage) {
      RemoteNotification? onappnotification = onappmessage.notification;
      AndroidNotification? android = onappmessage.notification?.android;

      if (onappnotification != null && android != null) {
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
              largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
            ),
          ),
        );

        getMessageUid(onappmessage.data['id']!);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final chat = MessageArguments(
        friendName: message.notification!.title!,
        friendUid: message.data['id']!,
      );

      Navigator.of(context).pushNamed('/ChatDetail', arguments: chat);
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {}
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    // if (_userProvider != null) {
    await _userProvider.refreshUser();
    // }

    DocumentSnapshot snap =
        await _firestore.collection("users").doc(_auth.currentUser!.uid).get();

    if ((snap.data()! as dynamic)['accountType'] != 'General user') {
      if (mounted) {
        setState(() => isNotGeneralUser = true);
      }
    }
  }

  getMessageUid(String uid) async {
    DocumentSnapshot snap =
        await _firestore.collection("users").doc(_auth.currentUser!.uid).get();
    List people = (snap.data()! as dynamic)['people'];

    if (!people.contains(uid)) {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'people': FieldValue.arrayUnion([uid])
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  void setOnlineStatus(String status) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({'status': status});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setOnlineStatus('available');
    } else {
      setOnlineStatus('offline');
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    var theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: !keyboardIsOpen,
        child: FloatingActionButton(
          onPressed: () => navigationTapped(2),
          // onPressed: () {
          //   // _showSheet();
          //   var bottomSheetController = scaffoldKey.currentState!
          //       .showBottomSheet((context) => Container(color: Colors.red));

          //   // showBottomSheet(
          //   //     context: context,
          //   //     builder: (builder) {
          //   //       return TextBSheet(childs: Text('sudesh'));
          //   //     });
          //   bottomSheetController.closed.then((value) {
          //     // showFoatingActionButton(true);
          //   });
          // },
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0XFF493240),
                  Color(0XFFFF0099),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ), //Edit_Square
            child: Center(
              child: SizedBox(
                height: 3 * SizeOF.height!,
                width: 3.5 * SizeOF.height!,
                child: SvgPicture.asset(
                  'assets/svg/Edit_Square.svg',
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        // elevation: 10,
        notchMargin: 5,
        shape: const CircularNotchedRectangle(),
        color: theme.backgroundColor,
        child: SizedBox(
          // padding: EdgeInsets.only(top: 0.5 * SizeOF.height!),
          height: 7.5 * SizeOF.height!,
          // decoration: BoxDecoration(
          // color: theme.backgroundColor,
          // boxShadow: [
          //   BoxShadow(
          //     color: const Color(0xff800020).withOpacity(0.1),
          //     blurRadius: 10,
          //     offset: const Offset(0, -5),
          //   ),
          // ],
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildBottombtn(
                theme: theme,
                id: 0,
                image: _page == 0 ? 'Fill_Home' : 'Light_Home',
                name: 'Home',
              ),
              buildBottombtn(
                theme: theme,
                id: 1,
                image: _page == 1 ? 'Fill_chart' : 'Light_chart',
                name: 'Library',
              ),
              const SizedBox(width: 15),
              buildBottombtn(
                theme: theme,
                id: 3,
                image: _page == 3 ? 'Fill_chat' : 'Light_message',
                name: 'Chat',
              ),
              buildBottombtn(
                theme: theme,
                id: 4,
                image: _page == 4 ? 'Fill_Profile' : 'Light_Profile',
                name: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell buildBottombtn(
      {required ThemeData theme,
      required int id,
      required String image,
      required String name,
      Function()? ontap}) {
    return InkWell(
      onTap: ontap ?? () => navigationTapped(id),
      child: Container(
        // color: _page == id ? theme.btnSelectColor : Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 0.5 * SizeOF.height!),
        width: 10 * SizeOF.height!,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 3 * SizeOF.height!,
              width: 3.5 * SizeOF.height!,
              child: SvgPicture.asset(
                'assets/svg/$image.svg',
                // color:
                //     _page == id ? theme.btnSelectColor : theme.btnUnselectColor,
              ),
            ),
            Flexible(child: Container()),
            Text(
              name,
              style: TextStyle(
                color:
                    _page == id ? theme.btnSelectColor : theme.btnUnselectColor,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
