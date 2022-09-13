import 'dart:io';
// import 'package:android_path_provider/android_path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:path_provider/path_provider.dart';
import 'package:poetic_app/core/routes/routes.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:poetic_app/core/theme/app_theme.dart';

import 'package:poetic_app/core/utils/global_variable.dart';

import 'package:poetic_app/core/utils/text_style.dart';
import 'package:poetic_app/core/utils/time.dart';
import 'package:poetic_app/features/models/user.dart' as model;

import 'package:poetic_app/core/utils/utils.dart';
import 'package:poetic_app/features/providers/user_provider.dart';
import 'package:poetic_app/features/resources/firestore_methods.dart';
import 'package:poetic_app/features/screens/widgets/get_audio.dart';
import 'package:poetic_app/features/screens/widgets/get_video.dart';
import 'package:poetic_app/features/screens/widgets/text_display_card.dart';
// import 'package:poetic_app/features/widgets/download.dart';
// import 'package:poetic_app/features/widgets/download_btn.dart';
import 'package:share_plus/share_plus.dart';

import 'like_animation.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'package:screenshot/screenshot.dart';

class PostCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  final String docId;

  const PostCard({Key? key, required this.snap, required this.docId})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();
  int commentLen = 0;
  int shareLen = 0;
  bool isLikeAnimating = false;
  bool isFollowing = false;
  String postType = '';
  bool conform = false;
  var userData = {};
  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    fetchCommentLen();
    fetchShareLen();
    getUserdetails();
    // shareReady();
  }

  getUserdetails() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.snap['uid'])
          .get();

      userData = snapshot.data()!;
      isFollowing = snapshot
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
    } catch (err) {
      showAutoCloseDialog(context, 'something went wrong', 'error');
    }
    if (mounted) {
      setState(() {});
    }
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      if (mounted) {
        setState(() {
          commentLen = snap.docs.length;
        });
      }
    } catch (_) {}
    //
  }

  fetchShareLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('shares')
          .get();
      shareLen = snap.docs.length;
    } catch (err) {
      showAutoCloseDialog(context, 'something went wrong', 'error');
    }
    if (mounted) {
      setState(() {});
    }
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showAutoCloseDialog(context, 'something went wrong', 'error');
    }
  }

  void _settingModalBottomSheet(context, user) {
    if (!conform) {
      showModalBottomSheet(
          elevation: 0,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext bc) {
            return Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Wrap(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor:
                            const Color(0XFF9597A1).withOpacity(0.3),
                        child: const Icon(Icons.close, color: Colors.black45),
                      ),
                    ),
                  ),
                  (widget.snap['uid'].toString() == user.uid)
                      ? Column(
                          children: [
                            ListTile(
                                leading: SvgPicture.asset(
                                  'assets/svg/trash.svg',
                                ),
                                title: const Text('Delete'),
                                onTap: () {
                                  _postDeleteDialog(context).then(
                                      (value) => Navigator.of(context).pop());
                                  // Navigator.of(context).pop();
                                }),
                            const Divider(),
                            ListTile(
                                leading: SvgPicture.asset(
                                  'assets/svg/edit.svg',
                                ),
                                title: const Text('Edit'),
                                onTap: () {
                                  var post = PostEditArguments(
                                      postId: widget.docId, p: widget.snap);
                                  Navigator.of(context).pushNamed(
                                      '/PostEditPage',
                                      arguments: post);
                                }),
                          ],
                        )
                      : isFollowing
                          ? ListTile(
                              title: const Text('Unfollow'),
                              leading: SvgPicture.asset(
                                'assets/svg/user_close.svg',
                              ),
                              onTap: () async {
                                await FireStoreMethods().followUser(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  userData['uid'],
                                );
                                if (mounted) {
                                  setState(() => isFollowing = false);
                                }
                                Navigator.pop(context);
                              },
                            )
                          : ListTile(
                              title: const Text(
                                'Follow',
                              ),
                              leading: SvgPicture.asset(
                                'assets/svg/user_plus.svg',
                              ),
                              onTap: () async {
                                await FireStoreMethods().followUser(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  userData['uid'],
                                );
                                await FireStoreMethods().chatUser(
                                  uid: FirebaseAuth.instance.currentUser!.uid,
                                  followId: userData['uid'],
                                );
                                if (mounted) {
                                  setState(() => isFollowing = true);
                                }
                                Navigator.pop(context);
                              },
                            ),
                  if (widget.snap['uid'].toString() != user.uid)
                    Column(
                      children: [
                        const Divider(thickness: 1),
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/svg/message.svg',
                          ),
                          title: const Text('Message'),
                          onTap: () async {
                            await FireStoreMethods().chatUser(
                              uid: FirebaseAuth.instance.currentUser!.uid,
                              followId: userData['uid'],
                            );

                            final chat = MessageArguments(
                                friendName: userData['username'],
                                friendUid: userData['uid']);

                            Navigator.of(context)
                                .pushNamed('/ChatDetail', arguments: chat);
                          },
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text('Profile'),
                          leading: SvgPicture.asset(
                            'assets/svg/user_user.svg',
                          ),
                          onTap: () async {
                            Navigator.of(context).pushNamed(
                              '/ProfileScreen',
                              arguments: widget.snap['uid'].toString(),
                            );
                          },
                        )
                      ],
                    ),
                  // if (widget.snap['uid'].toString() != user.uid)
                ],
              ),
            );
          });
    }
  }

  Future _postDeleteDialog(context) {
    var data = showDialog(
      // useRootNavigator: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Please Confirm'),
          content: const Text('Are you sure to remove the post?'),
          actions: [
            // The "Yes" button
            TextButton(
                onPressed: () {
                  // Remove the post
                  deletePost(widget.snap['postId'].toString());
                  setState(() {
                    conform = true;
                  });
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: const Text('Yes')),
            TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: const Text('No'))
          ],
        );
      },
    );
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    var theme = Theme.of(context);
    return Container(
      // boundary needed for web
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Row(
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(
                        userData['photoUrl'] != null
                            ? userData['photoUrl']!
                            : friendPic,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          userData['username'] != null
                              ? userData['username']!
                              : '',
                          maxLines: 1,
                          style:
                              postcardUsername.copyWith(color: theme.textColor),
                        ),
                        Text(
                          userData['accountType'] != null
                              ? userData['accountType']!
                              : '',
                          style: postcardaccountType,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      StringExtension.timeAgo(
                          widget.snap['datePublished'].toDate().toString()),
                      // displayTimeAgoFromTimestamp(
                      //     widget.snap['datePublished'].toDate().toString()),
                      style: postcardaccountType,
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        _settingModalBottomSheet(context, user);
                      },
                      child: const Icon(Icons.more_vert),
                    ),
                  ],
                )
              ],
            ),
          ),
          const Divider(height: 1),
          // IMAGE SECTION OF THE POST
          Column(
            children: [
              if (widget.snap['type'] != 'text')
                Row(
                  children: [
                    Container(
                      width: width - 50,
                      padding: EdgeInsets.symmetric(
                          horizontal: 2 * SizeOF.width!,
                          vertical: 2 * SizeOF.width!),
                      child: Text(
                        ' ${widget.snap['description']}',
                        maxLines: 4,
                        style: dontHaveAccount.copyWith(color: theme.textColor),
                      ),
                    ),
                  ],
                ),
              if (widget.snap['type'] == 'image')
                SizedBox(
                  // height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'].toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              if (widget.snap['type'] == 'video')
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: double.infinity,
                  child: GetVideoPost(
                    data: widget.snap['postUrl'].toString(),
                  ),
                ),
              if (widget.snap['type'] == 'audio')
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Center(
                    child: GetAudio(
                      audioUrl: widget.snap['postUrl'].toString(),
                    ),
                  ),
                ),
              if (widget.snap['type'] == 'text')
                Screenshot(
                  controller: screenshotController,
                  child: TextCardUI(
                    snap: widget.snap,
                    // title: widget.snap['description'],
                    // size: widget.snap['size'],
                    // font: widget.snap['font'],
                    // bgColor: Color(
                    //   int.parse(widget.snap['colorCode']),
                    // ),
                  ),
                ),
            ],
          ),
          const Divider(),
          // LIKE, COMMENT, SHARE SECTION OF THE POST
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              buildLikeButton(user, context),
              buildcommentButton(context, theme),
              // if (widget.isSave != null)
              //   DownloadButton(
              //     url: widget.snap['postUrl'],
              //     exType: widget.snap['type'],
              //   ),
              GestureDetector(
                onTap: () {
                  if (widget.snap['type'] != 'text') {
                    _onShareWithResult(uid: user.uid);
                  } else {
                    tackScreenshot(user.uid);
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.send),
                    Text(
                      shareLen > 0 ? ' $shareLen shares' : "  share ",
                      style: authPageSubTitle,
                    )
                  ],
                ),
              ),
            ],
          ),
          //DESCRIPTION AND NUMBER OF COMMENTS
        ],
      ),
    );
  }

  tackScreenshot(String uid) {
    screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((value) async {
      await textShare(value, uid);
    }).catchError((onError) {});
  }

  // downloadImagaeScreenshot() {
  //   String fileName = DateTime.now().microsecondsSinceEpoch.toString();
  //   screenshotController
  //       .capture(delay: const Duration(milliseconds: 10))
  //       .then((value) async {
  //     final directory = await AndroidPathProvider.downloadsPath;
  //     screenshotController.captureAndSave(directory, fileName: '$fileName.png');

  //     // OpenFile.open(file.path);
  //   }).catchError((onError) {});
  // }

  textShare(Uint8List? capturedImage, String uid) async {
    final box = context.findRenderObject() as RenderBox?;
    ShareResult result;
    final tempdDir = await getTemporaryDirectory();
    final path2 = '${tempdDir.path}/image.jpg';
    File(path2).writeAsBytesSync(capturedImage!);
    result = await Share.shareFilesWithResult([path2],
        text: 'Poetically App',
        subject: 'Poetic App',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);

    if (result.status == ShareResultStatus.success) {
      setState(() => shareLen++);
      postShare(uid);
    }
  }

  String path = '';
  Future<dynamic> _onShareWithResult({required String uid}) async {
    final box = context.findRenderObject() as RenderBox?;
    ShareResult result;
    if (!mounted) return;
    // if (widget.snap['type'] != 'text') {
    final url = Uri.parse(widget.snap['postUrl']);
    final response = await http.get(url);
    final bytes = response.bodyBytes;
    final tempDir = await getTemporaryDirectory();

    setState(() {
      if (widget.snap['type'] == 'image') {
        path = '${tempDir.path}/image.jpg';
      }
      if (widget.snap['type'] == 'video') {
        path = '${tempDir.path}/video.mp4';
      }
      if (widget.snap['type'] == 'audio') {
        path = '${tempDir.path}/music.mp3';
      }
      File(path).writeAsBytesSync(bytes);
    });
    result = await Share.shareFilesWithResult([path],
        text: widget.snap['description'],
        subject: 'Poetic App',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);

    if (result.status == ShareResultStatus.success) {
      setState(() => shareLen++);
      postShare(uid);
    }
  }

  void postShare(String uid) async {
    try {
      String res = await FireStoreMethods().postShare(
        widget.snap['postId'].toString(),
        uid,
      );

      if (res != 'Shared !') {
        // showSnackBar(context, res);
      }
    } catch (err) {
      showAutoCloseDialog(context, 'something went wrong', 'error');
    }
  }

  GestureDetector buildcommentButton(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/CommentsScreen',
          // (route) => false,
          arguments: widget.snap['postId'].toString(),
        );
      },
      child: Row(
        children: [
          const Icon(Icons.comment_outlined),
          Text(
            commentLen > 0 ? '  $commentLen comments' : "  comment ",
            style: authPageSubTitle,
          )
        ],
      ),
    );
  }

  LikeAnimation buildLikeButton(model.User user, BuildContext context) {
    return LikeAnimation(
      isAnimating: widget.snap['likes'].contains(user.uid),
      smallLike: true,
      child: GestureDetector(
        onTap: () => FireStoreMethods().likePost(
          widget.snap['postId'].toString(),
          user.uid,
          widget.snap['likes'],
        ),
        child: Row(
          children: [
            Icon(
              widget.snap['likes'].contains(user.uid)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color:
                  widget.snap['likes'].contains(user.uid) ? Colors.red : null,
            ),
            const SizedBox(width: 5),
            Text(
              widget.snap['likes'].length > 0
                  ? '${widget.snap['likes'].length} lovely'
                  : 'lovely',
              style: authPageSubTitle,
            ),
          ],
        ),
      ),
    );
  }
}
