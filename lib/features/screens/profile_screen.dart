import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poetic_app/core/routes/routes.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/theme/light_theme.dart';
import 'package:poetic_app/core/utils/overlay.dart';
import 'package:poetic_app/core/utils/text_style.dart';
import 'package:poetic_app/core/utils/utils.dart';
import 'package:poetic_app/features/resources/firestore_methods.dart';
import 'package:poetic_app/features/screens/follower_list.dart';
import 'package:poetic_app/features/screens/widgets/follow_button.dart';
import 'package:poetic_app/features/screens/widgets/post_card.dart';
import 'package:video_player/video_player.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late VideoPlayerController _controller;
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid',
              isEqualTo: widget.uid) //FirebaseAuth.instance.currentUser!.uid
          .get();
      if (mounted) {
        setState(() {
          postLen = postSnap.docs.length;
          userData = userSnap.data()!;
          followers = userSnap.data()!['followers'].length;
          following = userSnap.data()!['following'].length;

          isFollowing = userSnap
              .data()!['followers']
              .contains(FirebaseAuth.instance.currentUser!.uid);
        });
      }
    } catch (e) {
      showAutoCloseDialog(context, 'something went wrong', 'error');
    }
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  showSocialLink(String link) {
    showDialog(
        context: context,
        builder: (builder) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            child: SizedBox(
              height: 50,
              child: Center(
                child: SelectableText(
                  link,
                  style: TextStyle(
                    color: LightColor.textColor,
                    fontSize: 1.9 * SizeOF.text!,
                  ),
                ),
              ),
            ),
            // elevation: 0,
          );
        });
  }

  getVideo(String url) {
    _controller = VideoPlayerController.network(url);

    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: FirebaseAuth.instance.currentUser!.uid != widget.uid
          ? AppBar(
              elevation: 0,
              title: Text('Profile', style: completeTitle),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
              ))
          : null,
      body: isLoading
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : SafeArea(
              child: RemoveOverlay(
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 5),
                            blurRadius: 15.0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 10 * SizeOF.height!,
                                      width: 10 * SizeOF.height!,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            blurRadius: 5,
                                            offset: const Offset(1, 3),
                                          ),
                                        ],
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            userData['photoUrl'],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              buildStatColumn(
                                                  postLen, "posts", theme),
                                              GestureDetector(
                                                onTap: () {
                                                  // Navigator.of(context)
                                                  //     .pushNamedAndRemoveUntil(
                                                  //         '/FollowerPage',
                                                  //         (route) => false,
                                                  //         arguments: userData[
                                                  //             'followers']);
                                                  if (FirebaseAuth.instance
                                                          .currentUser!.uid ==
                                                      widget.uid) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (builder) =>
                                                            FollowerList(
                                                          followList: userData[
                                                              'followers'],
                                                          title: 'Followers',
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: buildStatColumn(
                                                    followers,
                                                    "followers",
                                                    theme),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  // Navigator.of(context)
                                                  //     .pushNamedAndRemoveUntil(
                                                  //         '/FollowerPage',
                                                  //         (route) => false,
                                                  //         arguments: userData[
                                                  //             'following']);
                                                  if (FirebaseAuth.instance
                                                          .currentUser!.uid ==
                                                      widget.uid) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (builder) =>
                                                            FollowerList(
                                                          followList: userData[
                                                              'following'],
                                                          title: 'Following',
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: buildStatColumn(
                                                    following,
                                                    "following",
                                                    theme),
                                              ),
                                            ],
                                          ),
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(left: 15.0),
                                            child: Divider(thickness: 1),
                                          ),
                                          if (userData['socialLinks'].length >
                                              0)
                                            if (userData['socialLinks']
                                                ['isShow'])
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  if (userData['socialLinks']
                                                          ['facebook']
                                                      .isNotEmpty)
                                                    InkWell(
                                                      onTap: () => showSocialLink(
                                                          userData[
                                                                  'socialLinks']
                                                              ['facebook']),
                                                      child: SvgPicture.asset(
                                                        'assets/svg/Facebook.svg',
                                                        // height: 2 * SizeOF.height!,
                                                        // color: Colors.black,
                                                      ),
                                                    ),
                                                  if (userData['socialLinks']
                                                          ['instagram']
                                                      .isNotEmpty)
                                                    InkWell(
                                                      onTap: () => showSocialLink(
                                                          userData[
                                                                  'socialLinks']
                                                              ['instagram']),
                                                      child: SvgPicture.asset(
                                                        'assets/svg/Instagram.svg',
                                                        // height: 2 * SizeOF.height!,
                                                        // color: Colors.black,
                                                      ),
                                                    ),
                                                  if (userData['socialLinks']
                                                          ['twitter']
                                                      .isNotEmpty)
                                                    InkWell(
                                                      onTap: () => showSocialLink(
                                                          userData[
                                                                  'socialLinks']
                                                              ['twitter']),
                                                      child: SvgPicture.asset(
                                                        'assets/svg/Twitter.svg',
                                                        // height: 2 * SizeOF.height!,
                                                        // color: Colors.black,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                          if (FirebaseAuth
                                                  .instance.currentUser!.uid !=
                                              widget.uid)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                          horizontal: 20)
                                                      .copyWith(top: 20.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  isFollowing
                                                      ? FollowGButton(
                                                          text: 'Message',
                                                          function: () async {
                                                            await FireStoreMethods()
                                                                .chatUser(
                                                              uid: FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                              followId:
                                                                  userData[
                                                                      'uid'],
                                                            );

                                                            final chat = MessageArguments(
                                                                friendName:
                                                                    userData[
                                                                        'username'],
                                                                friendUid:
                                                                    userData[
                                                                        'uid']);

                                                            Navigator.of(
                                                                    context)
                                                                .pushNamed(
                                                                    '/ChatDetail',
                                                                    arguments:
                                                                        chat);
                                                          },
                                                        )
                                                      : FollowGButton(
                                                          text: 'Follow',
                                                          function: () async {
                                                            await FireStoreMethods()
                                                                .followUser(
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                              userData['uid'],
                                                            );
                                                            await FireStoreMethods()
                                                                .chatUser(
                                                              uid: FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                              followId:
                                                                  userData[
                                                                      'uid'],
                                                            );
                                                            setState(() {
                                                              isFollowing =
                                                                  true;
                                                              followers++;
                                                            });
                                                          },
                                                        ),
                                                  const SizedBox(width: 10),
                                                  isFollowing
                                                      ? FollowIButton(
                                                          function: () async {
                                                            await FireStoreMethods()
                                                                .followUser(
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                              userData['uid'],
                                                            );

                                                            setState(() {
                                                              isFollowing =
                                                                  false;
                                                              followers--;
                                                            });
                                                          },
                                                          text: 'Icon_Follow',
                                                        )
                                                      : FollowIButton(
                                                          function: () async {
                                                            await FireStoreMethods().chatUser(
                                                                uid: FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid,
                                                                followId:
                                                                    userData[
                                                                        'uid']);

                                                            final chat = MessageArguments(
                                                                friendName:
                                                                    userData[
                                                                        'username'],
                                                                friendUid:
                                                                    userData[
                                                                        'uid']);

                                                            Navigator.of(
                                                                    context)
                                                                .pushNamed(
                                                                    '/ChatDetail',
                                                                    arguments:
                                                                        chat);
                                                          },
                                                          text: 'message',
                                                        ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Text(
                                    userData['username'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: LightColor.textColor,
                                      fontSize: 2.6 * SizeOF.text!,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    userData['accountType'].toUpperCase(),
                                    style: TextStyle(
                                      color: LightColor.iconColor,
                                      letterSpacing: 0.6,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 1.8 * SizeOF.text!,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    userData['bio'],
                                    maxLines: 10,
                                    style: profileAtype,
                                  ),
                                ),
                                if (userData['languages'].length > 0)
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Languages: ',
                                          style: TextStyle(
                                            color: const Color(0XFF5458F7),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 2 * SizeOF.text!,
                                          ),
                                        ),
                                        for (int k = 0;
                                            k < userData['languages'].length;
                                            k++)
                                          TextSpan(
                                            text:
                                                '${userData['languages'][k]} ${userData['languages'].length - 1 == k ? "" : "/"} ',
                                            style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 145, 145, 145),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 1.9 * SizeOF.text!,
                                            ),
                                          ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                          const Divider(thickness: 1),
                          if (userData['interst'].length > 0)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16)
                                      .copyWith(bottom: 20),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    for (int i = 0;
                                        i < userData['interst'].length;
                                        i++)
                                      TextSpan(
                                        text: '#${userData['interst'][i]} ',
                                        style: TextStyle(
                                          color: const Color(0XFF5458F7),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 1.9 * SizeOF.text!,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // ProfilePost(uid: widget.uid)
                    SizedBox(
                      height: 500,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CupertinoActivityIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Center(
                                child: CupertinoActivityIndicator());
                          }
                          final datas = snapshot.data!.docs;
                          final convart = datas
                            ..sort((a, b) => b['datePublished']
                                .compareTo(a['datePublished']));
                          return RemoveOverlay(
                            child: ListView(
                              children:
                                  convart.map((DocumentSnapshot document) {
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
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Column buildStatColumn(int num, String label, ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: theme.textTheme.headline6,
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

// class ProfilePost extends StatefulWidget {
//   final String uid;
//   const ProfilePost({Key? key, required this.uid}) : super(key: key);

//   @override
//   State<ProfilePost> createState() => _ProfilePostState();
// }

// class _ProfilePostState extends State<ProfilePost> {
//   List postData = [];
//   @override
//   void initState() {
//     getPosts();
//     super.initState();
//   }

//   Future getPosts() async {
//     FirebaseFirestore.instance
//         .collection('posts')
//         .where('uid', isEqualTo: widget.uid)
//         .snapshots()
//         .listen((event) {
//       for (var change in event.docChanges) {
//         switch (change.type) {
//           case DocumentChangeType.added:
//             // print("New City: ${change.doc.data()}");
//             if (mounted) {
//               setState(() {
//                 postData.add(change.doc.data());
//                 postData = postData
//                   ..sort((a, b) =>
//                       b['datePublished'].compareTo(a['datePublished']));
//               });
//             }

//             break;
//           case DocumentChangeType.modified:
//             // print("Modified City: ${change.doc.data()}");
//             break;
//           case DocumentChangeType.removed:
//             // print("Removed City: ${change.doc.data()}");
//             break;
//         }
//       }
//       // ignore: avoid_print
//     }).onError((error) => print("Listen failed: $error"));
//     // print(listener);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print(postData);
//     return RemoveOverlay(
//       child: SizedBox(
//         height: 350,
//         child: ListView(
//           children: postData.map((document) {
//             // Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
//             return PostCard(
//               docId: document['uid'],
//               snap: document,
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
