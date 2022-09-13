// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:poetic_app/core/size/size_config.dart';
// import 'package:poetic_app/core/theme/app_theme.dart';
// import 'package:poetic_app/core/utils/overlay.dart';

// class EditInterests extends StatefulWidget {
//   const EditInterests({Key? key, required this.userData}) : super(key: key);

//   final List userData;
//   @override
//   State<EditInterests> createState() => _EditInterestsState();
// }

// class _EditInterestsState extends State<EditInterests> {
//   List<dynamic>? dataRetrieved; // data decoded from the json file
//   List<dynamic>? data; // data to display on the screen
//   bool isInterst = false;
//   List interests = [];
//   // int searchValue = 0;
//   @override
//   void initState() {
//     super.initState();
//     _getData();
//   }

//   Future _getData() async {
//     final String response =
//         await rootBundle.loadString('assets/Interests.json');
//     dataRetrieved = await json.decode(response) as List<dynamic>;

//     setState(() {
//       data = dataRetrieved;
//       interests = widget.userData;
//     });
//   }

//   updateData() async {
//     CollectionReference users = FirebaseFirestore.instance.collection('users');
//     users
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .update({'interst': interests});
//   }

//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     return SizedBox(
//       height: 25 * SizeOF.height!,
//       child: RemoveOverlay(
//         child: AlignedGridView.count(
//           crossAxisCount: 3,
//           mainAxisSpacing: 5,
//           crossAxisSpacing: 10,
//           itemCount: data != null ? data!.length : 0,
//           itemBuilder: (context, index) {
//             isInterst = widget.userData.contains(data![index]['name']);
//             if (isInterst) data![index]['isClick'] = true;
//             return OutlinedButton(
//               onPressed: () {
//                 if (!data![index]['isClick']) {
//                   setState(() {
//                     interests.add(data![index]['name']);
//                     updateData();
//                     data![index]['isClick'] = true;
//                   });
//                 } else {
//                   setState(() {
//                     interests.remove(data![index]['name']);
//                     data![index]['isClick'] = false;
//                     updateData();
//                   });
//                 }
//               },
//               style: OutlinedButton.styleFrom(
//                 shape: const StadiumBorder(),
//                 backgroundColor: data![index]['isClick'] || isInterst
//                     ? theme.btnSelectColor
//                     : null,
//                 side: BorderSide(
//                   width: 1.0,
//                   color: theme.btnSelectColor,
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 1),
//                 child: Text(
//                   data![index]['name'],
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontSize: 2 * SizeOF.text!,
//                       // fontWeight: FontWeight.w600,
//                       color: data![index]['isClick'] || isInterst
//                           ? Colors.white
//                           : theme.textColor),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/theme/app_theme.dart';
import 'package:poetic_app/core/utils/overlay.dart';

class EditInterests extends StatefulWidget {
  const EditInterests({
    Key? key,
    required this.userData,
    required this.onTap,
  }) : super(key: key);
  final List userData;
  final Function() onTap;

  @override
  State<EditInterests> createState() => _EditInterestsState();
}

class _EditInterestsState extends State<EditInterests> {
  List<dynamic>? dataRetrieved; // data decoded from the json file
  List<dynamic>? data; // data to display on the screen
  bool isInterst = false;
  List interests = [];
  // int searchValue = 0;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    final String response =
        await rootBundle.loadString('assets/Interests.json');
    dataRetrieved = await json.decode(response) as List<dynamic>;

    setState(() {
      data = dataRetrieved;
      interests = widget.userData;
    });
  }

  updateData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'interst': interests});
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      // height: 25 * SizeOF.height!,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      child: RemoveOverlay(
        child: AlignedGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 10,
          itemCount: data != null ? data!.length : 0,
          itemBuilder: (context, index) {
            isInterst = widget.userData.contains(data![index]['name']);
            if (isInterst) data![index]['isClick'] = true;
            return OutlinedButton(
              onPressed: () {
                if (!data![index]['isClick']) {
                  setState(() {
                    interests.add(data![index]['name']);
                    updateData();
                    data![index]['isClick'] = true;
                  });
                } else {
                  setState(() {
                    interests.remove(data![index]['name']);
                    data![index]['isClick'] = false;
                    updateData();
                  });
                }
                widget.onTap();
              },
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: data![index]['isClick'] || isInterst
                    ? theme.btnSelectColor
                    : null,
                side: BorderSide(
                  width: 1.0,
                  color: theme.btnSelectColor,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Text(
                  data![index]['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 2 * SizeOF.text!,
                    color: data![index]['isClick'] || isInterst
                        ? Colors.white
                        : theme.textColor,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
