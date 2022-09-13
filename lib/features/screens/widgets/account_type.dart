// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:poetic_app/core/size/size_config.dart';
// import 'package:poetic_app/core/utils/colors.dart';
// import 'package:poetic_app/core/utils/global_variable.dart';

// class AccountType extends StatefulWidget {
//   const AccountType({Key? key, required this.onTap, required this.onRemove})
//       : super(key: key);
//   final Function(String value) onTap;
//   final Function(String value) onRemove;
//   @override
//   State<AccountType> createState() => _AccountTypeState();
// }

// class _AccountTypeState extends State<AccountType> {
//   List<dynamic>? dataRetrieved; // data decoded from the json file
//   List<dynamic>? data; // data to display on the screen
//   String values = 'Please select your account type';
//   int searchValue = 0;
//   @override
//   void initState() {
//     super.initState();
//     _getData();
//   }

//   Future _getData() async {
//     final String response =
//         await rootBundle.loadString('assets/AccountTypes.json');
//     dataRetrieved = await json.decode(response) as List<dynamic>;
//     setState(() {
//       data = dataRetrieved;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     // return SizedBox(
//     //   height: 25 * SizeOF.height!,
//     //   child: AlignedGridView.count(
//     //     crossAxisCount: 3,
//     //     mainAxisSpacing: 4,
//     //     crossAxisSpacing: 4,
//     //     itemCount: data != null ? data!.length : 0,
//     //     itemBuilder: (context, index) {
//     //       return OutlinedButton(
//     //         onPressed: () {
//     //           if (!data![index]['isClick']) {
//     //             setState(() {
//     //               // searchValue = (data![index]['code']);
//     //               widget.onTap(data![index]['name']);
//     //               data![index]['isClick'] = true;
//     //             });
//     //           } else {
//     //             setState(() {
//     //               // searchValue = (data![index]['code']);
//     //               widget.onRemove(data![index]['name']);
//     //               data![index]['isClick'] = true;
//     //             });
//     //           }
//     //         },
//     //         child: Text(
//     //           data![index]['name'],
//     //           textAlign: TextAlign.center,
//     //           style:
//     //               TextStyle(color: data![index]['isClick'] ? blue : textColor),
//     //         ),
//     //       );
//     //     },
//     //   ),
//     // );
//     return DropdownButton<String>(
//       isExpanded: true,
//       hint: Text(
//         values,
//         style: theme.textTheme.subtitle2,
//       ),
//       items: account_types.map((value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(
//             value,
//             style: theme.textTheme.subtitle2,
//           ),
//         );
//       }).toList(),
//       onChanged: (data) {
//         setState(() {
//           values = data!;
//         });
//       },
//     );
//   }
// }
