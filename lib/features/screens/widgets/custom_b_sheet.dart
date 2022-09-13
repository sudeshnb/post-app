import 'package:flutter/material.dart';

class CustomBSheet extends StatefulWidget {
  final List<Widget> childs;
  const CustomBSheet({Key? key, required this.childs}) : super(key: key);

  @override
  State<CustomBSheet> createState() => _CustomBSheetState();
}

class _CustomBSheetState extends State<CustomBSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      child: ListView(children: widget.childs),
    );
  }
}
