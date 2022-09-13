import 'package:flutter/material.dart';
import 'package:poetic_app/core/theme/app_theme.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;

  final TextInputType textInputType;

  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.textBoxColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: textEditingController,
        // textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(8),
        ),
        keyboardType: textInputType,
        obscureText: isPass,
      ),
    );
  }
}
