import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poetic_app/core/routes/routes.dart';
import 'package:poetic_app/core/utils/overlay.dart';
import 'package:poetic_app/core/utils/text_style.dart';
import 'package:poetic_app/features/resources/firestore_methods.dart';
import 'package:poetic_app/features/widgets/my_message_card.dart';
import 'package:poetic_app/features/widgets/sender_message_card.dart';
import 'package:http/http.dart' as http;

class ChatDetail extends StatefulWidget {
  final MessageArguments chat;
  const ChatDetail({Key? key, required this.chat}) : super(key: key);

  @override
  _ChatDetailState createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> with WidgetsBindingObserver {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final _dataBase = FirebaseFirestore.instance.collection('users');
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  // ignore: prefer_typing_uninitialized_variables
  var chatDocId;
  final _textController = TextEditingController();
  // String? token;
  String friendPic = 'https://i.stack.imgur.com/l60Hf.png';
  String friendState = '';
  int msgCount = 0;
  List uIdList = [];
  bool isFristMsg = false;
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    setOnlineStatus('online');
    super.initState();
    getDataFrien();
    checkUser();
  }

  void sendPushMessage(
      {required String name,
      required String msg,
      required String token,
      required String uid}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAP50TnNQ:APA91bH9Wv9V-0l3kHftOI_q04PH3Y3eK1qBA4nO2uc7_ZDbXmWDXNy43lc9-wmOUz5vbzdhrkAM5BVWmmIUTjqTsUIvdB46hrH1i5Af2zQ83rjOEReM29UzwxDb72PAx902dgF9t6H-',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': msg, 'title': name},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': uid,
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (_) {}
  }

  void didExitPage() async {
    await _dataBase.doc(currentUserId).update({'status': 'available'});
  }

  void setOnlineStatus(String status) async {
    await _dataBase.doc(currentUserId).update({'status': status});
  }

  // void setChatTime(String time) async {
  //   await _dataBase.doc(currentUserId).update({
  //     'people': {widget.chat.friendUid: time}
  //   });
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setOnlineStatus('online');
    } else {
      setOnlineStatus('offline');
    }
    super.didChangeAppLifecycleState(state);
  }

  getDataFrien() {
    _dataBase.doc(widget.chat.friendUid).get().then((snapshot) {
      setState(() {
        friendPic = snapshot.data()!['photoUrl'];
        getKeysAndValuesUsingEntries(snapshot.data()!['people']);

        if (snapshot.data()!['status'] == 'online' ||
            snapshot.data()!['status'] == 'available') {
          friendState = 'online';
        } else {
          friendState = 'offline';
        }
      });
    });
  }

  void getKeysAndValuesUsingEntries(Map map) {
    // Get all keys and values at the same time using entries
    if (mounted) {
      setState(() {
        for (var entry in map.entries) {
          // Map conv = {'key': entry.key, 'time': entry.value};
          uIdList.add(entry.key);
        }
        // uIdList.sort((b, a) => a["time"].compareTo(b["time"]));
      });
    }
  }

  void checkUser() async {
    try {
      await chats
          .where('users',
              isEqualTo: {widget.chat.friendUid: null, currentUserId: null})
          .limit(1)
          .get()
          .then(
            (QuerySnapshot querySnapshot) async {
              if (querySnapshot.docs.isNotEmpty) {
                setState(() {
                  chatDocId = querySnapshot.docs.single.id;
                });
              } else {
                await chats.add({
                  'users': {currentUserId: null, widget.chat.friendUid: null}
                }).then((value) => chatDocId = value);
              }
            },
          )
          .catchError((error) {});

      // chats
      //     .doc(chatDocId)
      //     .collection('unReadmsg')
      //     .doc(widget.chat.friendUid)
      //     .update({'count': 0}).catchError((error) {});
    } catch (_) {}
  }

  void sendMessage(String msg) {
    if (msg == '') return;
    // _dataBase.doc(widget.chat.friendUid).get().then((snapshot) {
    // var status = snapshot.data()!['status'];
    // var token = snapshot.data()!['token'];
    // if (status != 'online') {
    //   _dataBase.doc(currentUserId).get().then((value) {
    //     var userName = value.data()!['username'];

    //     sendPushMessage(
    //         name: userName, msg: msg, token: token, uid: currentUserId);
    //   });
    // }
    // });
    if (!uIdList.contains(currentUserId)) {
      FireStoreMethods()
          .chatUser(uid: widget.chat.friendUid, followId: currentUserId);
    }

    try {
      chats.doc(chatDocId).collection('messages').add({
        'createdOn': FieldValue.serverTimestamp(),
        'uid': currentUserId,
        'msg': msg
      }).then((value) {
        _textController.clear();
      });
      _dataBase.doc(currentUserId).update(
          {'people.${widget.chat.friendUid}': FieldValue.serverTimestamp()});
    } catch (_) {
      try {
        chats.doc(chatDocId).collection('messages').add({
          'createdOn': FieldValue.serverTimestamp(),
          'uid': currentUserId,
          'msg': msg
        }).then((value) {
          _textController.clear();
        });
        _dataBase.doc(currentUserId).update(
            {'people.${widget.chat.friendUid}': FieldValue.serverTimestamp()});
      } catch (_) {
        chats
            .where('users',
                isEqualTo: {widget.chat.friendUid: null, currentUserId: null})
            .limit(1)
            .get()
            .then(
              (QuerySnapshot querySnapshot) async {
                if (querySnapshot.docs.isNotEmpty) {
                  setState(() {
                    chatDocId = querySnapshot.docs.single.id;
                  });
                } else {
                  await chats.add({
                    'users': {currentUserId: null, widget.chat.friendUid: null}
                  }).then((value) => chatDocId = value);
                }
              },
            );
      }
    }

    // getDataFrien();
  }

  bool isSender(String friend) {
    return friend == currentUserId;
  }

  Alignment getAlignment(friend) {
    if (friend == currentUserId) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Returning true allows the pop to happen, returning false prevents it.
        didExitPage();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leadingWidth: 40,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              // PeoplePage
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/HomePage',
                (route) => false,
              );
            },
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(friendPic),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.chat.friendName, style: profileAtype),
                  Text(friendState, style: postcardaccountType),
                ],
              ),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: chats
              .doc(chatDocId)
              .collection('messages')
              .orderBy('createdOn', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong"),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CupertinoActivityIndicator();
            }

            if (snapshot.hasData) {
              return Scaffold(
                body: Column(
                  children: [
                    Expanded(
                      child: RemoveOverlay(
                        child: ListView(
                          reverse: true,
                          children: snapshot.data!.docs.map(
                            (DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: isSender(data['uid'].toString())
                                    ? GestureDetector(
                                        onLongPress: () {
                                          showCupertinoDialog(
                                              context: context,
                                              builder: (BuildContext ctx) {
                                                return CupertinoAlertDialog(
                                                  title: const Text(
                                                      'Please Confirm'),
                                                  content: const Text(
                                                      'Are you sure to permanently delete the message ?'),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      onPressed: () async {
                                                        chats
                                                            .doc(chatDocId)
                                                            .collection(
                                                                'messages')
                                                            .doc(document.id)
                                                            .delete();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('Yes'),
                                                      isDefaultAction: true,
                                                      isDestructiveAction: true,
                                                    ),
                                                    // The "No" button
                                                    CupertinoDialogAction(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('No'),
                                                      isDefaultAction: false,
                                                      isDestructiveAction:
                                                          false,
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        child: MyMessageCard(
                                          date: data['createdOn'] == null
                                              ? DateTime.now().toString()
                                              : data['createdOn']
                                                  .toDate()
                                                  .toString(),
                                          message: data['msg'].toString(),
                                        ),
                                      )
                                    : SenderMessageCard(
                                        message: data['msg'].toString(),
                                        date: data['createdOn']
                                            .toDate()
                                            .toString(),
                                      ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildChatTextFild(isFristMsg)
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Row buildChatTextFild(bool isFMsg) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 10, right: 20),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                filled: true,
                hintText: '    Type a message!',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 20),
          child: InkWell(
            // child: const Icon(Icons.send_sharp),
            child: CircleAvatar(
              radius: 23,
              backgroundColor: const Color(0XFFF3F5F7),
              child: SvgPicture.asset(
                'assets/svg/Send.svg',
                // width: 30,
                height: 30,
              ),
            ),

            onTap: () => sendMessage(_textController.text),
          ),
        )
      ],
    );
  }
}
