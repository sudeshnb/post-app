import 'package:flutter/material.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/utils/colors.dart';

class CustomRoundBtn extends StatelessWidget {
  final Function() onTap;
  final String text;
  const CustomRoundBtn({Key? key, required this.onTap, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 3 * SizeOF.width!, vertical: 1.2 * SizeOF.width!),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5 * SizeOF.width!),
          // color: Color(0XFFFF0084),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 30],
            colors: <Color>[
              // LightColor.burgundy.withOpacity(0.6),
              Color(0XFF33001B),
              Color(0XFFFF0084),

              // LightColor.maroon
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0XFFAE0000).withOpacity(0.3),
              offset: const Offset(2, 6),
              blurRadius: 15.0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 2.7 * SizeOF.text!,
              letterSpacing: 1,
              // fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
