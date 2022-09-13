import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poetic_app/core/utils/overlay.dart';
import 'package:poetic_app/core/utils/text_style.dart';
import 'package:poetic_app/core/utils/utils.dart';
import 'package:poetic_app/features/models/user.dart';
import 'package:poetic_app/features/providers/user_provider.dart';
import 'package:poetic_app/features/resources/firestore_methods.dart';
import 'package:poetic_app/features/screens/widgets/comment_card.dart';

import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final postId;
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FireStoreMethods().postComment(
        widget.postId,
        commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        showAutoCloseDialog(context, 'something went wrong', 'error');
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showAutoCloseDialog(context, 'something went wrong', 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: theme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //   '/HomePage',
            //   (route) => false,
            // );
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Comments',
          style: completeTitle,
        ),
        // centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          return RemoveOverlay(
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) => CommentCard(
                snap: snapshot.data!.docs[index],
              ),
            ),
          );
        },
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          // height: kToolbarHeight,
          decoration: BoxDecoration(
            color: theme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(
                  user.uid,
                  user.username,
                  user.photoUrl,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
