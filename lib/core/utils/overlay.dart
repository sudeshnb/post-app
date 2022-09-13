import 'package:flutter/material.dart';

class RemoveOverlay extends StatelessWidget {
  final Widget child;
  const RemoveOverlay({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return false;
      },
      child: child,
    );
  }
}
