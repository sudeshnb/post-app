import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LanguageSheet extends StatefulWidget {
  final List userData;
  final Function() onTap;

  const LanguageSheet({
    Key? key,
    required this.userData,
    required this.onTap,
  }) : super(key: key);

  @override
  State<LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<LanguageSheet> {
  bool isLanguage = false;
  List<dynamic>? dataLanguage = [];
  List<dynamic>? language;
  List selectLanguage = [];
  @override
  void initState() {
    super.initState();
    // getData();
    _getLanguagesData();
  }

  Future _getLanguagesData() async {
    final String responseL =
        await rootBundle.loadString('assets/languages.json');
    dataLanguage = await json.decode(responseL) as List<dynamic>;
    setState(() {
      language = dataLanguage;
      selectLanguage = widget.userData;
    });
  }

  updateLanguageData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'languages': selectLanguage});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: language != null ? language!.length : 0,
        itemBuilder: (context, index) {
          isLanguage = widget.userData.contains(language![index]['nativeName']);
          if (isLanguage) language![index]['value'] = true;
          return InkWell(
            onTap: () {},
            // child: Text(language![index]['value'].toString()),
            child: CheckboxListTile(
              value: language![index]['value'],
              activeColor: const Color(0XFF493240),
              onChanged: (value) {
                if (!language![index]['value']) {
                  setState(() {
                    selectLanguage.add(language![index]['nativeName']);
                    isLanguage = true;

                    language![index]['value'] = true;
                  });
                } else {
                  setState(() {
                    selectLanguage.remove(language![index]['nativeName']);

                    language![index]['value'] = false;
                    isLanguage = false;
                  });
                }
                widget.onTap();
                updateLanguageData();
              },
              title: Text(language![index]['name']),
              subtitle: Text(language![index]['nativeName']),
            ),
          );
        },
      ),
    );
  }
}
