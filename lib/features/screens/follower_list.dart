import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poetic_app/core/utils/overlay.dart';
import 'package:poetic_app/core/utils/text_style.dart';

class FollowerList extends StatelessWidget {
  final List followList;
  final String title;
  const FollowerList({Key? key, required this.title, required this.followList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(title, style: completeTitle),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
          )),
      body: RemoveOverlay(
        child: ListView.builder(
            itemCount: followList.length,
            itemBuilder: (context, index) {
              return GetUserData(id: followList[index]);
            }),
      ),
    );
  }
}

class GetUserData extends StatelessWidget {
  const GetUserData({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(id).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'Something wrong.!',
                textAlign: TextAlign.center,
              ),
            );
          }
          final user = (snapshot.data! as dynamic);
          return ListTile(
            title: Text(user['username']),
            onTap: () => Navigator.of(context).pushNamed(
              '/ProfileScreen',
              arguments: user['uid'],
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user['photoUrl']),
              backgroundColor: Colors.blue.shade300,
            ),
          );
        });
  }
}
