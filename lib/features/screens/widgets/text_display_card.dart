import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:tuple/tuple.dart';

class TextCardUI extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const TextCardUI({Key? key, required this.snap}) : super(key: key);

  @override
  State<TextCardUI> createState() => _TextCardUIState();
}

class _TextCardUIState extends State<TextCardUI> {
  QuillController _controller = QuillController.basic();
  final scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {});
    super.initState();
  }

  AlignmentGeometry passBegin(String begin) {
    AlignmentGeometry top = Alignment.topCenter;
    setState(() {
      switch (begin) {
        case 'Alignment.topCenter':
          top = Alignment.topCenter;
          break;
        case 'Alignment.bottomCenter':
          top = Alignment.bottomCenter;
          break;
        case 'Alignment.centerLeft':
          top = Alignment.centerLeft;
          break;
        case 'Alignment.centerRight':
          top = Alignment.centerRight;
          break;
        case 'Alignment.topLeft':
          top = Alignment.topLeft;
          break;
        case 'Alignment.bottomRight':
          top = Alignment.bottomRight;
          break;
        case 'Alignment.topRight':
          top = Alignment.topRight;
          break;
        case 'Alignment.bottomLeft':
          top = Alignment.bottomLeft;
          break;
        default:
      }
    });

    return top;
  }

  @override
  Widget build(BuildContext context) {
    var myJSON = jsonDecode(widget.snap['description']);

    _controller = QuillController(
        document: Document.fromJson(myJSON),
        selection: const TextSelection.collapsed(offset: 0));

    return Container(
      decoration: BoxDecoration(
        color: Color(int.parse(widget.snap['colorCode'])),
        image: widget.snap['bgImage'].isNotEmpty
            ? DecorationImage(
                image: NetworkImage(widget.snap['bgImage']),
                fit: BoxFit.cover,
              )
            : null,
        gradient: widget.snap['gradient'].isNotEmpty
            ? LinearGradient(
                begin: passBegin(widget.snap['gradient'][0]['begin']),
                end: passBegin(widget.snap['gradient'][2]['end']),
                colors: [
                    if (widget.snap['gradient'][1]['color'].length > 1)
                      for (int i = 0;
                          i < widget.snap['gradient'][1]['color'].length;
                          i++)
                        Color(
                          int.parse(widget.snap['gradient'][1]['color'][i]),
                        ),
                    if (widget.snap['gradient'][1]['color'].length < 2)
                      for (int i = 0; i < 2; i++)
                        Color(
                          int.parse(widget.snap['gradient'][1]['color'][0]),
                        )
                  ])
            : null,
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: QuillEditor(
          controller: _controller,
          customStyles: DefaultStyles(
            paragraph: DefaultTextBlockStyle(
                TextStyle(
                  fontSize: widget.snap['size'],
                  fontFamily: widget.snap['font'],
                  color: Colors.black,
                ),
                const Tuple2(16, 0),
                const Tuple2(0, 0),
                null),
          ),
          scrollPhysics: const NeverScrollableScrollPhysics(),
          focusNode: FocusNode(),
          scrollController: scrollController,
          autoFocus: false,
          expands: false,
          // maxHeight: _see_more ? null : 20 * SizeOF.height!,
          padding: const EdgeInsets.all(10.0),
          scrollable: false,
          readOnly: true,
          // true for view only mode
        ),
      ),
    );
  }
}
