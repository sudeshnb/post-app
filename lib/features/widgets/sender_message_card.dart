import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/utils/text_style.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({Key? key, required this.message, required this.date})
      : super(key: key);
  final String message;
  final String date;

  @override
  Widget build(BuildContext context) {
    var time = DateFormat.jm().format(DateTime.parse(date));
    var theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: Color(0XFFF3F5F7),
            // gradient: const LinearGradient(
            //   stops: [0, 1],
            //   colors: [
            //     Color(0XFFFF0099),
            //     Color(0XFF493240),
            //   ],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            // boxShadow: [
            //   BoxShadow(
            //     color: const Color(0XFFAE0000).withOpacity(0.3),
            //     offset: const Offset(1, 3),
            //     blurRadius: 5.0,
            //   ),
            // ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 3 * SizeOF.width!,
                  right: 8 * SizeOF.width!,
                  top: 5,
                  bottom: 20,
                ),
                child: Text(
                  message,
                  style: theme.textTheme.headline6!.copyWith(
                    // color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 10,
                child: Text(
                  time,
                  style: chatMymsg.copyWith(
                    color: Colors.grey,
                    // fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
