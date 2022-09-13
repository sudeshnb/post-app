import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poetic_app/core/size/size_config.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final String text;
  final Color textColor;
  const FollowButton(
      {Key? key,
      required this.backgroundColor,
      required this.text,
      required this.textColor,
      this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: backgroundColor,
        side: BorderSide(width: 1.0, color: backgroundColor),
      ),
      onPressed: function,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor,
          fontSize: 2.2 * SizeOF.text!,
        ),
      ),
    );
  }
}

class FollowGButton extends StatelessWidget {
  final Function()? function;
  final bool? isUn;
  final String text;
  const FollowGButton({Key? key, this.isUn, required this.text, this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isUn != null ? const Color(0XFF493240).withOpacity(0.2) : null,
          gradient: isUn == null
              ? const LinearGradient(
                  colors: [
                    Color(0XFF493240),
                    Color(0XFFFF0099),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            fontSize: 2.3 * SizeOF.text!,
          ),
        ),
      ),
    );
  }
}

class FollowIButton extends StatelessWidget {
  final Function()? function;
  final String text;
  const FollowIButton({Key? key, required this.text, this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        side: BorderSide(
          width: 1.0,
          color: Colors.grey.shade400,
        ),
      ),
      onPressed: function,
      child: SvgPicture.asset(
        'assets/svg/$text.svg',
        color: const Color(0XFF493240),
      ),
    );
  }
}
