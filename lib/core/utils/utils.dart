import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poetic_app/features/widgets/arlet_box.dart';

// for picking up image from gallery
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
}

// for displaying snackbars
// showSnackBar(BuildContext context, String text) {
//   return ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       backgroundColor: showSnackBarColor,
//       content: Text(
//         text,
//         style: const TextStyle(color: textColor),
//       ),
//     ),
//   );
// }

showAutoCloseDialog(BuildContext context, String title, String status) {
  showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        Timer(const Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });

        return AlertDialogData(status: status, title: title);
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      });
}
