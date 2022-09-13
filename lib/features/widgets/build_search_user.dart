import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poetic_app/core/routes/routes.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/utils/overlay.dart';
import 'package:poetic_app/core/utils/text_style.dart';
import 'package:poetic_app/features/providers/user_provider.dart';
import 'package:poetic_app/features/resources/firestore_methods.dart';
import 'package:poetic_app/features/screens/widgets/follow_button.dart';
import 'package:provider/provider.dart';
import 'package:poetic_app/features/models/user.dart' as model;

class BuildSearchUser extends StatefulWidget {
  final String text;
  // final List following;
  const BuildSearchUser({Key? key, required this.text}) : super(key: key);

  @override
  State<BuildSearchUser> createState() => _BuildSearchUserState();
}

class _BuildSearchUserState extends State<BuildSearchUser> {
  bool isFollowing = false;
  List following = [];
  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    // isFollowing = (snap.data()! as dynamic)['followers']
    //     .contains(FirebaseAuth.instance.currentUser!.uid);
    if (mounted) {
      setState(() {
        following = (snap.data()! as dynamic)['following'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .where(
            'username',
            isGreaterThanOrEqualTo: widget.text,
          )
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(
            child: Text(
              'Can not find a user..!',
              textAlign: TextAlign.center,
            ),
          );
        }
        return RemoveOverlay(
          child: ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) {
              if ((snapshot.data! as dynamic).docs[index]['uid'] == user.uid) {
                return const SizedBox();
              }
              isFollowing = following
                  .contains((snapshot.data! as dynamic).docs[index]['uid']);
              return InkWell(
                onTap: () => Navigator.of(context).pushNamed(
                  '/ProfileScreen',
                  arguments: (snapshot.data! as dynamic).docs[index]['uid'],
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10)
                      .copyWith(top: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    // isThreeLine: true,
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]['photoUrl'],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      (snapshot.data! as dynamic).docs[index]['username'],
                      style: postcardUsername,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (snapshot.data! as dynamic).docs[index]
                              ['accountType'],
                          style: profileAtype,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            !isFollowing
                                ? InkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0XFF493240),
                                            Color(0XFFFF0099),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Follow',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            fontSize: 2.1 * SizeOF.text!,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      await FireStoreMethods().followUser(
                                        user.uid,
                                        (snapshot.data! as dynamic).docs[index]
                                            ['uid'],
                                      );
                                      await FireStoreMethods().chatUser(
                                        uid: user.uid,
                                        followId: (snapshot.data! as dynamic)
                                            .docs[index]['uid'],
                                      );
                                      setState(() => isFollowing = true);
                                      getData();
                                    },
                                  )
                                : InkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: const Color(0XFFFF0099)
                                            .withOpacity(0.1),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Unfollow',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black,
                                            fontSize: 2.1 * SizeOF.text!,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      await FireStoreMethods().followUser(
                                        user.uid,
                                        (snapshot.data! as dynamic).docs[index]
                                            ['uid'],
                                      );

                                      setState(() => isFollowing = false);
                                      getData();
                                    },
                                  ),
                            FollowIButton(
                              function: () async {
                                await FireStoreMethods().chatUser(
                                  uid: user.uid,
                                  followId: (snapshot.data! as dynamic)
                                      .docs[index]['uid'],
                                );

                                final chat = MessageArguments(
                                    friendName: (snapshot.data! as dynamic)
                                        .docs[index]['username'],
                                    friendUid: (snapshot.data! as dynamic)
                                        .docs[index]['uid']);

                                Navigator.of(context)
                                    .pushNamed('/ChatDetail', arguments: chat);
                              },
                              text: 'message',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
