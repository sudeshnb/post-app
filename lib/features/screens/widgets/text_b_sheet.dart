import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poetic_app/core/theme/app_theme.dart';
import 'package:poetic_app/core/utils/global_variable.dart';

class TextSizeSheet extends StatefulWidget {
  const TextSizeSheet(
      {Key? key,
      required this.type,
      required this.onValue,
      required this.onFont})
      : super(key: key);
  final Function(double) onValue;
  final Function(String) onFont;
  final String type;
  @override
  State<TextSizeSheet> createState() => _TextSizeSheetState();
}

class _TextSizeSheetState extends State<TextSizeSheet> {
  double _value = 20;
  String fontValue = 'avenir';
  // String type = '';
  Widget typeOFchild = const SizedBox();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var fontSize = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'A',
          style: TextStyle(
            fontSize: 14,
            color: theme.textColor,
          ),
        ),
        Expanded(
          child: CupertinoSlider(
            min: 0.0,
            max: 100.0,
            activeColor: const Color(0XFFFF0084),
            value: _value,
            onChanged: (value) {
              setState(() => _value = value);
              widget.onValue(value);
            },
          ),
        ),
        Text(
          'A',
          style: TextStyle(
            fontSize: 20,
            color: theme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );

    var font = CupertinoPicker(
      itemExtent: 80,
      children: fonts.map((value) {
        return Center(
          child: Text(
            value['name'],
            style: TextStyle(
              fontSize: 24,
              color: theme.textColor,
              fontFamily: value['font'],
              // fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
      onSelectedItemChanged: (value) {
        setState(() {
          fontValue = fonts[value]['font'];
          widget.onFont(fontValue);
        });
      },
    );
    switch (widget.type) {
      case 'size':
        typeOFchild = fontSize;
        break;
      case 'font':
        typeOFchild = font;
        break;
      default:
    }
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      child: typeOFchild,
    );
  }
}
