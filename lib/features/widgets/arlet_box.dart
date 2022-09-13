import 'package:flutter/material.dart';

class AlertDialogData extends StatelessWidget {
  final String title;
  final String status;
  const AlertDialogData({Key? key, required this.title, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String type = '';
    Color color = Colors.green;
    switch (status) {
      case 'done':
        type = 'success';
        color = Colors.green.shade700;
        break;
      case 'warning':
        type = 'warning';
        color = Colors.yellow.shade900;
        break;
      case 'error':
        type = 'error';
        color = Colors.red.shade800;
        break;
      default:
    }
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        color: Colors.transparent,
        child: Container(
          // padding: EdgeInsets.symmetric(horizontal: 00, vertical: 10),
          height: 80,
          width: 250,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 5,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      color: color,
                      letterSpacing: 0.7,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 230,
                    child: Text(
                      title,
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.black,
                        letterSpacing: 0.7,
                        // fontSize: 18,
                        // fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
