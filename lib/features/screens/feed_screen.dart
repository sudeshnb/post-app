import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/theme/app_theme.dart';
import 'package:poetic_app/core/theme/cubit/theme_cubit.dart';
import 'package:poetic_app/core/utils/overlay.dart';
import 'package:poetic_app/core/utils/text_style.dart';
import 'package:poetic_app/core/utils/utils.dart';
import 'package:poetic_app/features/providers/user_provider.dart';
import 'package:poetic_app/features/resources/auth_methods.dart';
import 'package:poetic_app/features/screens/widgets/post_card.dart';
import 'package:poetic_app/features/screens/widgets/settings_button.dart';
import 'package:poetic_app/features/widgets/build_search_user.dart';
import 'package:provider/provider.dart';
import 'package:poetic_app/features/models/user.dart' as model;

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  bool isFollowing = false;
  List following = [];
  List types = [];
  @override
  void initState() {
    getDataPost();
    super.initState();
  }

  void getDataPost() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    // isFollowing = (snap.data()! as dynamic)['followers']
    //     .contains(FirebaseAuth.instance.currentUser!.uid);
    if (mounted) {
      setState(() {
        following = (snap.data()! as dynamic)['following'];
        types = (snap.data()! as dynamic)['interst'];
      });
    }
  }

  List setCategory(String val) {
    var ex = val.split('/').last;
    // var pre = ex.split(')');
    // var prefix = ex[0].trim();
    return [ex[0].trim(), ex[1].trim()];
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 8 * SizeOF.height!, //8
          // backgroundColor: theme.logoTextColor,
          automaticallyImplyLeading: false,
          flexibleSpace: PreferredSize(
            preferredSize: Size.fromHeight(15 * SizeOF.height!),
            child: SafeArea(
              child: SizedBox(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/image/logo-1.png',
                      width: isShowUsers ? 16 * SizeOF.width! : null,
                    ),
                    Container(
                      height: 40,
                      width: 65 * SizeOF.width!,
                      decoration: BoxDecoration(
                        color: theme.textBoxColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: 3 * SizeOF.width!),
                      child: Form(
                        child: TextFormField(
                          controller: searchController,
                          decoration: InputDecoration(
                              hintText: 'Search for something...',
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SvgPicture.asset(
                                  'assets/svg/Dark_Search.svg',
                                ),
                              ),
                              labelStyle: dontHaveAccount),
                          onFieldSubmitted: (value) {
                            if (value.isNotEmpty) {
                              setState(() => isShowUsers = true);
                            }
                          },
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() => isShowUsers = false);
                            }
                          },
                        ),
                      ),
                    ),
                    Builder(
                      builder: (context) => InkWell(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: CircleAvatar(
                          backgroundColor: theme.textBoxColor,
                          child: SvgPicture.asset(
                            'assets/svg/more.svg',
                            height: 2 * SizeOF.height!,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottom: isShowUsers
              ? TabBar(
                  tabs: const [
                    Tab(text: "user"),
                    Tab(text: "post"),
                  ],
                  labelColor: const Color(0XFF961067),
                  unselectedLabelColor: const Color(0XFFBDBDBD),
                  indicatorColor: const Color(0XFF961067),
                  labelStyle: dontHaveAccount,
                )
              : null,
        ),
        drawer: const CustomAppDrawer(),
        body: isShowUsers
            ? TabBarView(
                children: [
                  // searchUser(),

                  BuildSearchUser(text: searchController.text),
                  searchPost(),
                ],
              )
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('datePublished', descending: true)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }

                  return RemoveOverlay(
                    child: ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        if (user.uid == data['uid']) {
                          return PostCard(
                            docId: document.id.toString(),
                            snap: data,
                          );
                        }
                        if (following.contains(data['uid'])) {
                          return PostCard(
                            docId: document.id.toString(),
                            snap: data,
                          );
                        }
                        if (types.isNotEmpty) {
                          if (types.contains(data['category'][0])) {
                            return PostCard(
                              docId: document.id.toString(),
                              snap: data,
                            );
                          }

                          if (types.contains(data['category'][1])) {
                            return PostCard(
                              docId: document.id.toString(),
                              snap: data,
                            );
                          }
                        }
                        return const SizedBox();
                      }).toList(),
                    ),
                  );
                },
              ),
      ),
    );
  }

  // Widget searchUser() {
  //   final model.User user = Provider.of<UserProvider>(context).getUser;
  //   return FutureBuilder(
  //     future: FirebaseFirestore.instance
  //         .collection('users')
  //         .where(
  //           'username',
  //           isGreaterThanOrEqualTo: searchController.text,
  //         )
  //         .get(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CupertinoActivityIndicator());
  //       }
  //       if (!snapshot.hasData) {
  //         return const Center(
  //           child: Text(
  //             'Can not find a user..!',
  //             textAlign: TextAlign.center,
  //           ),
  //         );
  //       }
  //       return RemoveOverlay(
  //         child: ListView.builder(
  //           itemCount: (snapshot.data! as dynamic).docs.length,
  //           itemBuilder: (context, index) {
  //             if ((snapshot.data! as dynamic).docs[index]['uid'] == user.uid) {
  //               return const SizedBox();
  //             }
  //             isFollowing = following
  //                 .contains((snapshot.data! as dynamic).docs[index]['uid']);
  //             return InkWell(
  //               onTap: () => Navigator.of(context).pushNamed(
  //                 '/ProfileScreen',
  //                 arguments: (snapshot.data! as dynamic).docs[index]['uid'],
  //               ),
  //               child: Container(
  //                 margin: const EdgeInsets.symmetric(horizontal: 10)
  //                     .copyWith(top: 20),
  //                 decoration: BoxDecoration(
  //                   border: Border.all(color: Colors.black12),
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 child: ListTile(
  //                   // isThreeLine: true,
  //                   leading: Container(
  //                     height: 50,
  //                     width: 50,
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       color: Colors.white,
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.black.withOpacity(0.3),
  //                           blurRadius: 5,
  //                           offset: const Offset(0, 2),
  //                         ),
  //                       ],
  //                       image: DecorationImage(
  //                         image: NetworkImage(
  //                           (snapshot.data! as dynamic).docs[index]['photoUrl'],
  //                         ),
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   ),
  //                   title: Text(
  //                     (snapshot.data! as dynamic).docs[index]['username'],
  //                     style: postcardUsername,
  //                   ),
  //                   subtitle: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         (snapshot.data! as dynamic).docs[index]
  //                             ['accountType'],
  //                         style: profileAtype,
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                         children: [
  //                           if (!isFollowing)
  //                             InkWell(
  //                               child: Container(
  //                                 padding: const EdgeInsets.symmetric(
  //                                     horizontal: 30, vertical: 5),
  //                                 decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(30),
  //                                   gradient: const LinearGradient(
  //                                     colors: [
  //                                       Color(0XFF493240),
  //                                       Color(0XFFFF0099),
  //                                     ],
  //                                     begin: Alignment.topLeft,
  //                                     end: Alignment.bottomRight,
  //                                   ),
  //                                 ),
  //                                 child: Center(
  //                                   child: Text(
  //                                     'Follow',
  //                                     style: TextStyle(
  //                                       fontWeight: FontWeight.w900,
  //                                       color: Colors.white,
  //                                       fontSize: 2.1 * SizeOF.text!,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                               onTap: () async {
  //                                 await FireStoreMethods().followUser(
  //                                   user.uid,
  //                                   (snapshot.data! as dynamic).docs[index]
  //                                       ['uid'],
  //                                 );
  //                                 await FireStoreMethods().chatUser(
  //                                   uid: user.uid,
  //                                   followId: (snapshot.data! as dynamic)
  //                                       .docs[index]['uid'],
  //                                 );
  //                                 setState(() => isFollowing = true);
  //                               },
  //                             ),
  //                           if (isFollowing)
  //                             InkWell(
  //                               child: Container(
  //                                 padding: const EdgeInsets.symmetric(
  //                                     horizontal: 30, vertical: 5),
  //                                 decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(30),
  //                                   color: const Color(0XFFFF0099)
  //                                       .withOpacity(0.1),
  //                                 ),
  //                                 child: Center(
  //                                   child: Text(
  //                                     'Unfollow',
  //                                     style: TextStyle(
  //                                       fontWeight: FontWeight.w900,
  //                                       color: Colors.black,
  //                                       fontSize: 2.1 * SizeOF.text!,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                               onTap: () async {
  //                                 await FireStoreMethods().followUser(
  //                                   user.uid,
  //                                   (snapshot.data! as dynamic).docs[index]
  //                                       ['uid'],
  //                                 );

  //                                 setState(() => isFollowing = false);
  //                               },
  //                             ),
  //                           FollowIButton(
  //                             function: () async {
  //                               await FireStoreMethods().chatUser(
  //                                 uid: user.uid,
  //                                 followId: (snapshot.data! as dynamic)
  //                                     .docs[index]['uid'],
  //                               );

  //                               final chat = MessageArguments(
  //                                   friendName: (snapshot.data! as dynamic)
  //                                       .docs[index]['username'],
  //                                   friendUid: (snapshot.data! as dynamic)
  //                                       .docs[index]['uid']);

  //                               Navigator.of(context)
  //                                   .pushNamed('/ChatDetail', arguments: chat);
  //                             },
  //                             text: 'message',
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget searchPost() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where(
            'description',
            isGreaterThanOrEqualTo: searchController.text,
          )
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(
            child: Text(
              'Can not find post ..!',
              textAlign: TextAlign.center,
            ),
          );
        }

        // return RemoveOverlay(
        //   child: ListView.builder(
        //     itemCount: (snapshot.data! as dynamic).docs.length,
        //     itemBuilder: (ctx, index) {
        //       return PostCard(
        //         docId: (snapshot.data! as dynamic).docs.single.id,
        //         snap: (snapshot.data! as dynamic).docs[index],
        //         // user: user,
        //       );
        //     },
        //   ),
        // );

        return RemoveOverlay(
          child: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return PostCard(
                docId: document.id.toString(),
                snap: data,
                //       // user: user,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SizedBox(
      width: 73 * SizeOF.width!,
      child: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Flexible(flex: 1, child: Container()),
              const Text(
                'Settings ',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Flexible(flex: 2, child: Container()),
              SettingsButton(
                text: 'Profile Settings',
                text2:
                    'Do you want to edit your personal details? do tap here.',
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/ProfileEditPage',
                    (route) => false,
                  );
                },
                icon: Icons.person,
              ),
              SettingsButton(
                text: 'Social Media Links',
                text2:
                    'Do you need more attention to your profile? if you link your social media links.',
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/SocialMediaLinkPage',
                    (route) => false,
                  );
                },
                icon: Icons.people,
              ),
              BlocBuilder<ThemeCubit, bool>(builder: (context, state) {
                return SettingsButton(
                  text: state ? 'Light Mode' : 'Dark Mode',
                  text2:
                      'Change the theme colour. we are recommended to use a dark theme.',
                  onTap: () {},
                  icon: state ? Icons.light_mode : Icons.dark_mode,
                  child: Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                      value: state,
                      activeColor: const Color(0XFF961067),
                      onChanged: (value) => BlocProvider.of<ThemeCubit>(context)
                          .toggleTheme(value: value),
                    ),
                  ),
                );
              }),
              // DownloadButton(status: DownloadStatus.downloaded),
              SettingsButton(
                text: 'Remove Account ',
                text2: 'Do you want permanently remove your account?',
                onTap: () {
                  _delete(context);
                },
                icon: Icons.delete_outline,
              ),
              Flexible(flex: 1, child: Container()),
              buildNormalBtn(theme, 'About', () {
                showAboutDialog(
                  context: context,
                  applicationIcon: Image.asset(
                    'assets/image/logo-1.png',
                    width: 50,
                  ),
                  applicationName: 'Poetically~',
                  // useRootNavigator: false,
                  applicationVersion: 'version : 1.0.3',
                  applicationLegalese: 'Developed by Onyxsio Co.',
                );
              }, Icons.help),
              buildNormalBtn(
                theme,
                'Logout',
                () async {
                  await AuthMethods().signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/LoginPage',
                    (route) => false,
                  );
                },
                Icons.exit_to_app,
              ),
              Flexible(flex: 3, child: Container()),
            ],
          ),
        ),
      ),
    );
  }

  InkWell buildNormalBtn(
      ThemeData theme, String name, Function() ontap, IconData icon) {
    return InkWell(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: const Color(0XFFFAFAFA).withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 5 * SizeOF.width!,
              child: Icon(
                icon,
                color: theme.iconColor,
              ),
              backgroundColor: theme.backgroundColor,
            ),
            SizedBox(width: 2 * SizeOF.width!),
            Text(
              name,
              style: TextStyle(
                fontSize: 2.2 * SizeOF.text!,
                fontWeight: FontWeight.w800,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _delete(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(
            title: const Text('Please Confirm'),
            content:
                const Text('Are you sure to permanently delete the account?'),
            actions: [
              CupertinoDialogAction(
                onPressed: () async {
                  String res1 = await AuthMethods().deletePosts();
                  if (res1 == "Success") {
                    String res2 = await AuthMethods().deleteAcconut();

                    showAutoCloseDialog(
                        context, 'your account deleted', 'done');
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Wapper',
                      (route) => false,
                    );

                    if (res2 == "Success") {}
                  }
                },
                child: const Text('Yes'),
                isDefaultAction: true,
                isDestructiveAction: true,
              ),
              // The "No" button
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No'),
                isDefaultAction: false,
                isDestructiveAction: false,
              )
            ],
          );
        });
  }
}
