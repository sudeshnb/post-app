import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poetic_app/core/theme/app_theme.dart';
import 'package:poetic_app/core/utils/overlay.dart';
import 'package:poetic_app/core/utils/text_style.dart';

import 'widgets/post_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: backgroundColor,
          title: Form(
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                  labelText: 'Search for something...',
                  prefixIcon: const Icon(Icons.search),
                  labelStyle: dontHaveAccount),
              onFieldSubmitted: (String _) {
                setState(() => isShowUsers = true);
              },
            ),
          ),
          bottom: isShowUsers
              ? TabBar(
                  tabs: const [
                    Tab(text: 'user'),
                    Tab(text: 'post'),
                  ],
                  labelColor: theme.textColor,
                  labelStyle: dontHaveAccount,
                )
              : null,
        ),
        body: isShowUsers
            ? TabBarView(
                children: [
                  searchUser(),
                  searchPost(),
                ],
              )
            : null,
      ),
    );
  }

  Widget searchUser() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .where(
            'username',
            isGreaterThanOrEqualTo: searchController.text,
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
              return InkWell(
                onTap: () => Navigator.of(context).pushNamed(
                  '/ProfileScreen',
                  arguments: (snapshot.data! as dynamic).docs[index]['uid'],
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.1),
                    ),
                  ),
                  child: ListTile(
                    isThreeLine: true,
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
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
                      // style: theme.textTheme.subtitle1,
                    ),
                    subtitle: Text(
                      (snapshot.data! as dynamic).docs[index]['accountType'],
                      // style: theme.textTheme.subtitle1,
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

  Widget searchPost() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('posts')
          .where(
            'description',
            isGreaterThanOrEqualTo: searchController.text,
          )
          .get(),
      builder: (context, snapshot) {
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

        return RemoveOverlay(
          child: ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (ctx, index) => PostCard(
              docId: (snapshot.data! as dynamic).docs.id,
              snap: (snapshot.data! as dynamic).docs[index],
              // user: user,
            ),
          ),
        );
      },
    );
  }
}
