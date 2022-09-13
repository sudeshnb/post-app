import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poetic_app/core/theme/app_theme.dart';
import 'package:poetic_app/core/utils/colors.dart';
import 'package:poetic_app/core/utils/utils.dart';
import 'gradient_picker.dart';

class BGColorSet extends StatefulWidget {
  const BGColorSet({Key? key, required this.onData}) : super(key: key);
  final Function(Color?, LinearGradient?, List?, Uint8List?) onData;
  @override
  State<BGColorSet> createState() => _BGColorSetState();
}

class _BGColorSetState extends State<BGColorSet> {
  Color? _tempShadeColor;
  Color? _shadeColor;
  Uint8List? _image;
  LinearGradient? _colorGradient;
  List? postG;

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    if (mounted) {
      setState(() => _image = im);
    }
  }

  void _openColorPicker() async {
    _openDialog(
        "Select Post Background Color",
        MaterialColorPicker(
          selectedColor: _shadeColor,
          onColorChange: (color) => setState(() => _tempShadeColor = color),
        ));
  }

  void _openGradientPicker() async {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(6.0),
            backgroundColor: backgroundColor,
            title: const Text(
              'Select Gradient Colors',
              style: TextStyle(color: Colors.white),
            ),
            content: BuildGradientColor(setGradi: setLinearGradient),
          );
        });
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
                Navigator.of(context).pop();
                setState(() {
                  _shadeColor = _tempShadeColor;
                  _colorGradient = null;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _openColorPicker,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Choose single background color',
                  style: TextStyle(
                    color: theme.textColor,
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: _shadeColor != null ? _shadeColor! : Colors.white,
                    border: Border.all(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _openGradientPicker,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Choose gradient background color',
                  style: TextStyle(
                    color: theme.textColor,
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    gradient: _colorGradient,
                    border: Border.all(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: selectImage,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Choose background image',
                  style: TextStyle(
                    color: theme.textColor,
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    image: _image != null
                        ? DecorationImage(image: MemoryImage(_image!))
                        : null,
                    border: Border.all(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.red.shade500),
                ),
                onPressed: Navigator.of(context).pop,
              ),
              const SizedBox(width: 20),
              OutlinedButton(
                child: const Text(
                  'SUBMIT',
                  style: TextStyle(color: blue),
                ),
                onPressed: () {
                  //  postG=PostGredient(begin: ,end: ,color: []);
                  widget.onData(_shadeColor, _colorGradient, postG, _image);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  setLinearGradient(LinearGradient lg, List post) {
    setState(() {
      _colorGradient = lg;
      postG = post;
    });
  }
}
