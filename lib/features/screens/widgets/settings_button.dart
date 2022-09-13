import 'package:flutter/material.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/theme/app_theme.dart';

class SettingsButton extends StatelessWidget {
  final String text;
  final String text2;
  final IconData icon;
  final Function() onTap;
  final Widget? child;
  const SettingsButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.text2,
    required this.onTap,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: 6 * SizeOF.height!,
        // width: double.infinity,
        // width: 60 * SizeOF.width!,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        margin:
            const EdgeInsets.symmetric(horizontal: 5.0).copyWith(bottom: 15),
        // color: appBarColor.withOpacity(0.5),
        decoration: BoxDecoration(
          color: const Color(0XFFFAFAFA).withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 5 * SizeOF.width!,
              child: Icon(
                icon,
                color: theme.iconColor,
              ),
              backgroundColor: theme.backgroundColor,
            ),
            SizedBox(width: 2 * SizeOF.width!),
            SizedBox(
              width: 50 * SizeOF.width!,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 57 * SizeOF.width!,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 2.2 * SizeOF.text!,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (child != null) child!
                      ],
                    ),
                  ),
                  const Divider(thickness: 1, height: 2),
                  Text(
                    text2,
                    style: TextStyle(
                      fontSize: 1.4 * SizeOF.text!,
                      color: Colors.black54,
                      // fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
