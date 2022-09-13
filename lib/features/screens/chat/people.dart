import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poetic_app/core/routes/routes.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/theme/app_theme.dart';
import 'package:poetic_app/core/utils/chat_time.dart';
import 'package:poetic_app/core/utils/colors.dart';
import 'package:poetic_app/core/utils/overlay.dart';
import 'package:poetic_app/core/utils/text_style.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  var userData = {};
  bool isLoading = false;
  List uIdList = [];
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
          .doc(currentUserId)
          .get();
      if (mounted) {
        setState(() => userData = userSnap.data()!);
        getKeysAndValuesUsingEntries(userData['people']);
      }
    } catch (e) {
      // showAutoCloseDialog(context, 'something went wrong', 'error');
    }
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  void getKeysAndValuesUsingEntries(Map map) {
    // Get all keys and values at the same time using entries
    if (mounted) {
      setState(() {
        for (var entry in map.entries) {
          Map conv = {'key': entry.key, 'time': entry.value};
          uIdList.add(conv);
        }
        uIdList.sort((b, a) => a["time"].compareTo(b["time"]));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peoples', style: completeTitle),
        elevation: 0,
        // centerTitle: true,
      ),
      body: isLoading
          ? const SizedBox()
          : RemoveOverlay(
              child: ListView.builder(
                itemCount: uIdList.length,
                itemBuilder: (context, index) {
                  return GetUserName(documentId: uIdList[index]['key']);
                },
              ),
            ),
    );
  }
}

// class People extends StatefulWidget {
//   const People({Key? key}) : super(key: key);

//   @override
//   State<People> createState() => _PeopleState();
// }

// class _PeopleState extends State<People> {
//   CollectionReference chats = FirebaseFirestore.instance.collection('chats');

//   // ignore: prefer_typing_uninitialized_variables
//   var chatDocId;
//   // int totalCount = 0;

//   final currentUserId = FirebaseAuth.instance.currentUser!.uid;
//   CollectionReference users = FirebaseFirestore.instance.collection('users');
//   Future<String> checkUser(String id) async {
//     // String lastMsg = '';
//     String lastMsgTime = '';
//     if (mounted) {
//       try {
//         await chats
//             .where('users', isEqualTo: {id: null, currentUserId: null})
//             .limit(1)
//             .get()
//             .then(
//               (QuerySnapshot querySnapshot) async {
//                 if (querySnapshot.docs.isNotEmpty) {
//                   setState(() => chatDocId = querySnapshot.docs.single.id);
//                 } else {
//                   await chats.add({
//                     'users': {currentUserId: null, id: null}
//                   }).then((value) async {
//                     chatDocId = value;
//                   }).catchError((error) {});
//                 }
//               },
//             )
//             .catchError((error) {});

//         await chats
//             .doc(chatDocId)
//             .collection('messages')
//             .orderBy('createdOn', descending: true)
//             .limit(1)
//             .get()
//             .then((QuerySnapshot value) {
//           setState(() {
//             // String lastMsg = value.docs.single['msg'];
//             lastMsgTime =
//                 chatTime(value.docs.single['createdOn'].toDate().toString());
//           });
//         }).catchError((error) {});
//         if (mounted) {
//           setState(() {});
//         }
//       } on StateError catch (_) {}
//     }
//     return lastMsgTime;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance
//             .collection("users")
//             .doc(FirebaseAuth.instance.currentUser!.uid)
//             .get(),
//         builder:
//             (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return const Center(
//               child: Text("Something went wrong"),
//             );
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CupertinoActivityIndicator(),
//             );
//           }
//           // Map<String, dynamic> data =
//           //     snapshot.data!.data() as Map<String, dynamic>;

//           var len = snapshot.data!['people'].length!;

//           final datas = snapshot.data!['people'];
//           final convart = datas..sort((a, b) => b[''].compareTo(a['']));
//           print(convart);
//           // if (people != null) {}

//           // return RemoveOverlay(
//           //   child: ListView.builder(
//           //     itemCount: len,
//           //     itemBuilder: (context, index) {
//           //       // if (checkUser(people[index]) ==
//           //       //     '4jXIxTME7ya75sWuO2mEnz1FPSD2') {
//           //       //   print('object: $index');
//           //       // }
//           //       return GetUserName(documentId: people[index]);
//           //     },
//           //   ),
//           // );
//           print(len);
//           return Text('data');
//         });
//   }
// }

class GetUserName extends StatefulWidget {
  final String documentId;

  const GetUserName({Key? key, required this.documentId}) : super(key: key);

  @override
  State<GetUserName> createState() => _GetUserNameState();
}

class _GetUserNameState extends State<GetUserName> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  String lastMsg = '';
  String lastMsgTime = '';
  int totalCount = 0;

  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  // ignore: prefer_typing_uninitialized_variables
  var chatDocId;
  @override
  void initState() {
    checkUser();
    super.initState();
  }

  void checkUser() async {
    if (mounted) {
      try {
        await chats
            .where('users',
                isEqualTo: {widget.documentId: null, currentUserId: null})
            .limit(1)
            .get()
            .then(
              (QuerySnapshot querySnapshot) async {
                if (querySnapshot.docs.isNotEmpty) {
                  setState(() => chatDocId = querySnapshot.docs.single.id);
                } else {
                  await chats.add({
                    'users': {currentUserId: null, widget.documentId: null}
                  }).then((value) async {
                    chatDocId = value;
                  }).catchError((error) {});
                }
              },
            )
            .catchError((error) {});

        await chats
            .doc(chatDocId)
            .collection('messages')
            .orderBy('createdOn', descending: true)
            .limit(1)
            .get()
            .then((QuerySnapshot value) {
          setState(() {
            lastMsg = value.docs.single['msg'];
            lastMsgTime =
                chatTime(value.docs.single['createdOn'].toDate().toString());
          });
        }).catchError((error) {});
        if (mounted) {
          setState(() {});
        }
        // Sum the count of each shard in the subcollection
        await chats
            .doc(chatDocId)
            .collection('unReadmsg')
            .doc(widget.documentId)
            .get()
            .then((value) {
          if (mounted) {
            setState(() => totalCount = value.data()!['count']);
          }
        }).catchError((error) {});
      } on StateError catch (_) {}
    }
  }

  void getCount() async {
    // Sum the count of each shard in the subcollection
    chats
        .doc(chatDocId)
        .collection('unReadmsg')
        .doc(currentUserId)
        .set({'count': 0}).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Dismissible(
            key: Key(data['uid']),
            secondaryBackground: slideLeftBackground(),
            direction: DismissDirection.endToStart,
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("DELETE"),
                    content: const Text(
                        "Are you sure to permanently delete all messages with this person? "),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () async {
                            await chats.doc(chatDocId).delete();
                            await users.doc(currentUserId).update(
                                {'people.${data['uid']}': FieldValue.delete()});
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/HomePage',
                              (route) => false,
                            );
                          },
                          child: const Text(
                            "DELETE",
                            style: TextStyle(color: Colors.red),
                          )),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("CANCEL"),
                      ),
                    ],
                  );
                },
              );
            },
            background: Container(),
            // onDismissed: (direction) {
            //   if (direction == DismissDirection.endToStart) {
            //     chats
            //         .doc(chatDocId)
            //         .delete()
            //         .then((value) => Navigator.of(context).pop(false));
            //     FirebaseFirestore.instance
            //         .collection('users')
            //         .doc(FirebaseAuth.instance.currentUser!.uid)
            //         .update({
            //       'people': FieldValue.arrayRemove([data['uid']])
            //     });
            //   }
            //   if (direction == DismissDirection.startToEnd) {}
            // },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade800, width: 0.15),
                ),
              ),
              // padding: EdgeInsets.symmetric(vertical: 1 * SizeOF.height!),
              margin: EdgeInsets.zero,
              child: ListTile(
                onTap: () => callChatDetailScreen(
                    context, data['username'], data['uid']),
                title: Text(
                  data['username'].toString(),
                  style: postcardUsername,
                ),
                trailing: Column(
                  children: [
                    if (totalCount > 0)
                      CircleAvatar(
                        radius: 2 * SizeOF.height!,
                        backgroundColor: theme.logoTextColor,
                        child: Text(
                          totalCount.toString(),
                          style: peopleLastmsg.copyWith(color: Colors.white),
                        ),
                      ),
                    Text(
                      lastMsgTime,
                      style: peopleLastmsg,
                    ),
                    if (lastMsgTime.isEmpty)
                      Icon(
                        Icons.new_releases,
                        color: Colors.green.shade600,
                      )
                  ],
                ),
                subtitle: lastMsgTime.isNotEmpty
                    ? Text(
                        lastMsg,
                        maxLines: 1,
                        style: peopleLastmsg,
                      )
                    : Text(
                        'new user',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.green.shade600,
                        ),
                      ),
                leading: Stack(
                  children: [
                    Container(
                      height: 7 * SizeOF.height!,
                      width: 7 * SizeOF.height!,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(1, 2),
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(
                            data['photoUrl'].toString(),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (data['status'] == 'online' ||
                        data['status'] == 'available')
                      Positioned(
                        bottom: 0,
                        right: 2,
                        child: CircleAvatar(
                          radius: 1 * SizeOF.height!,
                          backgroundColor: tabColor,
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void callChatDetailScreen(BuildContext context, String name, String uid) {
    final chat = MessageArguments(friendName: name, friendUid: uid);

    Navigator.of(context).pushNamed('/ChatDetail', arguments: chat);
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
