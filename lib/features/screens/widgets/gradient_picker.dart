import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/utils/colors.dart';

class BuildGradientColor extends StatefulWidget {
  const BuildGradientColor({Key? key, required this.setGradi})
      : super(key: key);
  final Function(LinearGradient, List) setGradi;
  @override
  State<BuildGradientColor> createState() => _BuildGradientColorState();
}

class _BuildGradientColorState extends State<BuildGradientColor> {
  int direction = 0;
  List<Color> colors = [];
  AlignmentGeometry end = Alignment.bottomCenter;
  AlignmentGeometry begin = Alignment.topCenter;

  @override
  Widget build(BuildContext context) {
    switch (direction) {
      case 0:
        begin = Alignment.topCenter;
        end = Alignment.bottomCenter;
        break;
      case 1:
        begin = Alignment.bottomCenter;
        end = Alignment.topCenter;
        break;
      case 2:
        begin = Alignment.centerLeft;
        end = Alignment.centerRight;
        break;
      case 3:
        begin = Alignment.centerRight;
        end = Alignment.centerLeft;
        break;
      case 4:
        begin = Alignment.topLeft;
        end = Alignment.bottomRight;
        break;
      case 5:
        begin = Alignment.bottomRight;
        end = Alignment.topLeft;
        break;
      case 6:
        begin = Alignment.topRight;
        end = Alignment.bottomLeft;
        break;
      case 7:
        begin = Alignment.bottomLeft;
        end = Alignment.topRight;
        break;

      default:
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (colors.length > 1)
          Container(
            height: 150,
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [for (int k = 0; k < colors.length; k++) colors[k]],
                begin: begin,
                end: end,
              ),
            ),
          ),
        Text(
          'Please select color :',
          style: TextStyle(
            fontSize: 2.2 * SizeOF.text!,
            fontWeight: FontWeight.w800,
            color: const Color(0XFFFFFFFF),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            GestureDetector(
              onTap: _openColorPicker,
              child: Container(
                height: 50,
                width: 50,
                color: Colors.blue.shade600,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            for (int i = 0; i < colors.length; i++)
              GestureDetector(
                onTap: () {
                  setState(() {
                    colors.removeAt(i);
                  });
                },
                child: Container(
                  height: 50,
                  width: 50,
                  color: colors[i],
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              )
          ],
        ),
        const SizedBox(height: 50),
        Text(
          'Please select direction :',
          style: TextStyle(
            fontSize: 2.2 * SizeOF.text!,
            fontWeight: FontWeight.w800,
            color: const Color(0XFFFFFFFF),
          ),
        ),
        const SizedBox(height: 20),
        CupertinoPicker(
          itemExtent: 80,
          onSelectedItemChanged: (value) {
            setState(() => direction = value);
          },
          children: directions
              .map(
                (e) => Center(
                  child: Text(
                    e['name'],
                    style: TextStyle(
                      fontSize: 2.2 * SizeOF.text!,
                      fontWeight: FontWeight.w800,
                      color: const Color(0XFFFFFFFF),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 50),
        Center(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                width: 1.0,
                color: Colors.blue,
                style: BorderStyle.solid,
              ),
            ),
            onPressed: () {
              if (colors.isNotEmpty) {
                var lg = LinearGradient(colors: colors, end: end, begin: begin);
                var postG = [
                  {'begin': begin.toString()},
                  {
                    'color': [
                      for (int i = 0; i < colors.length; i++)
                        setColorToString(colors[i].toString())
                    ]
                  },
                  {'end': end.toString()}
                ];
                widget.setGradi(lg, postG);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ),
      ],
    );
  }

  String setColorToString(String color) {
    var ex = color.split('(').last;
    var pre = ex.split(')');
    var prefix = pre[0].trim();
    return prefix;
  }

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          backgroundColor: backgroundColor,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          content: content,
          actions: [
            TextButton(
              child: const Text(
                'CANCEL',
                style: TextStyle(color: blue),
              ),
              onPressed: Navigator.of(context).pop,
            ),
            TextButton(
              child: const Text(
                'SUBMIT',
                style: TextStyle(color: blue),
              ),
              onPressed: () {
                setState(() {
                  _shadeColor = _tempShadeColor;
                  colors.add(_tempShadeColor!);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Color? _tempShadeColor;

  Color? _shadeColor;

  void _openColorPicker() async {
    if (colors.length < 4) {
      _openDialog(
        "Select Color",
        MaterialColorPicker(
          selectedColor: _shadeColor,
          onColorChange: (color) => setState(() => _tempShadeColor = color),
        ),
      );
    }
  }
}

List directions = [
  {'name': 'Top - Bottom', 'value': 'topCenter_bottomCenter'},
  {'name': 'Bottom - Top', 'value': 'bottomCenter_topCenter'},
  {'name': 'Left - Right ', 'value': 'centerLeft_centerRight'},
  {'name': 'Right - Left ', 'value': 'centerRight_centerLeft'},
  {'name': 'Top Left - Bottom Right', 'value': 'topLeft_bottomRight'},
  {'name': 'Bottom Right - Top Left ', 'value': 'bottomRight_topLeft'},
  {'name': 'Top Right - Bottom Left', 'value': 'topRight_bottomLeft'},
  {'name': 'Bottom Left - Top Right', 'value': 'bottomLeft_topRight'},
];
