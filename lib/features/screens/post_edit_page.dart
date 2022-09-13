import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:poetic_app/core/routes/routes.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/theme/app_theme.dart';
import 'package:poetic_app/core/utils/colors.dart';
import 'package:poetic_app/core/utils/overlay.dart';
import 'package:poetic_app/core/utils/text_style.dart';
import 'package:poetic_app/core/utils/utils.dart';
import 'package:poetic_app/features/resources/firestore_methods.dart';
import 'package:poetic_app/features/resources/storage_methods.dart';
import 'package:poetic_app/features/screens/widgets/get_audio.dart';
import 'package:poetic_app/features/screens/widgets/get_video.dart';
import 'package:tuple/tuple.dart';

import 'widgets/bg_color_set.dart';
import 'widgets/text_b_sheet.dart';

class PostEditPage extends StatefulWidget {
  final PostEditArguments post;

  const PostEditPage({Key? key, required this.post}) : super(key: key);

  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  bool isLoading = false;
  QuillController _controller = QuillController.basic();
  final TextEditingController _descriptionController = TextEditingController();
  String fontFamily = '';
  double _value = 0;
  bool isText = false;
  LinearGradient? _colorGradient;
  Uint8List? _bgimage;
  List? _postGredient;
  // String fontValue = 'avenir';
  Color? _shadeColor;
  final scrollController = ScrollController();
  @override
  void initState() {
    if (widget.post.p['type'] == 'text') {
      if (mounted) {
        setState(() {
          isText = true;
          _value = widget.post.p['size'];
          _shadeColor = Color(
            int.parse(widget.post.p['colorCode']),
          );
          var myJSON = jsonDecode(widget.post.p['description']);
          _controller = QuillController(
              document: Document.fromJson(myJSON),
              selection: const TextSelection.collapsed(offset: 0));
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _descriptionController.text = widget.post.p['description'];
        });
      }
    }

    super.initState();
  }

  void updatePost() async {
    var json = jsonEncode(_controller.document.toDelta().toJson());
    setState(() => isLoading = true);
    String bgPhotoUrl = '';
    List postG = [];
    try {
      if (widget.post.p['gradient'].isNotEmpty) {
        postG = [
          {'begin': widget.post.p['gradient'][0]['begin']},
          {
            'color': [
              for (int i = 0;
                  i < widget.post.p['gradient'][1]['color'].length;
                  i++)
                widget.post.p['gradient'][1]['color'][i]
            ]
          },
          {'end': widget.post.p['gradient'][2]['end']}
        ];
      }
      if (_bgimage != null) {
        bgPhotoUrl = await StorageMethods()
            .uploadImageToStorage('posts_bg', _bgimage, true);
      }
      String res = await FireStoreMethods().updatePost(
        isText ? json : _descriptionController.text,
        widget.post.postId,
        setColorToString(_shadeColor.toString()),
        _value,
        fontFamily,
        bgPhotoUrl.isEmpty
            ? widget.post.p['bgImage'].isEmpty
                ? ''
                : widget.post.p['bgImage']
            : bgPhotoUrl,
        _postGredient != null ? _postGredient! : postG,
      );
      if (res == "success") {
        setState(() => isLoading = false);
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/HomePage',
          (route) => false,
        );

        showAutoCloseDialog(context, 'success', 'done');
      } else {
        showAutoCloseDialog(context, 'something went wrong', 'error');
      }
    } catch (_) {}
  }

  String setColorToString(String color) {
    var ex = color.split('(').last;
    var pre = ex.split(')');
    var prefix = pre[0].trim();
    return prefix;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            TextButton(
              onPressed: updatePost,
              child: RichText(
                text: TextSpan(
                  text: 'Edit',
                  style: TextStyle(
                    fontSize: 20,
                    color: theme.textColor,
                  ),
                ),
              ),
            )
          ],
        ),
        body: RemoveOverlay(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(3 * SizeOF.width!),
              child: Stack(
                children: [
                  isLoading
                      ? const LinearProgressIndicator()
                      : const Padding(padding: EdgeInsets.only(top: 0.0)),
                  if (isText)
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3 * SizeOF.width!),
                          margin: EdgeInsets.only(bottom: 3 * SizeOF.width!),
                          decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(5 * SizeOF.width!),
                          ),
                          child: QuillToolbar.basic(
                            controller: _controller,
                            showSmallButton: true,
                            showAlignmentButtons: true,
                            showDirection: true,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(3 * SizeOF.width!),
                          height: 25 * SizeOF.height!,
                          decoration: BoxDecoration(
                            color: _shadeColor != null
                                ? _shadeColor!
                                : Color(
                                    int.parse(widget.post.p['colorCode']),
                                  ),
                            borderRadius: BorderRadius.circular(20),
                            image: widget.post.p['bgImage'].isNotEmpty
                                ? DecorationImage(
                                    image:
                                        NetworkImage(widget.post.p['bgImage']),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            gradient: _colorGradient != null
                                ? _colorGradient!
                                : widget.post.p['gradient'].isNotEmpty
                                    ? LinearGradient(
                                        begin: passBegin(widget
                                            .post.p['gradient'][0]['begin']),
                                        end: passBegin(widget.post.p['gradient']
                                            [2]['end']),
                                        colors: [
                                            for (int i = 0;
                                                i <
                                                    widget
                                                        .post
                                                        .p['gradient'][1]
                                                            ['color']
                                                        .length;
                                                i++)
                                              Color(int.parse(
                                                  widget.post.p['gradient'][1]
                                                      ['color'][i]))
                                          ])
                                    : null,
                          ),
                          child: QuillEditor(
                            controller: _controller,
                            customStyles: DefaultStyles(
                              paragraph: DefaultTextBlockStyle(
                                  TextStyle(
                                    fontSize: _value > 0
                                        ? _value
                                        : widget.post.p['size'],
                                    fontFamily: fontFamily.isNotEmpty
                                        ? fontFamily
                                        : widget.post.p['font'],
                                    color: Colors.black,
                                  ),
                                  const Tuple2(16, 0),
                                  const Tuple2(0, 0),
                                  null),
                            ),
                            focusNode: FocusNode(),
                            placeholder: 'What\'s on your mind?',
                            scrollController: scrollController,
                            autoFocus: false,
                            expands: false,
                            padding: const EdgeInsets.all(10.0),
                            scrollable: true,
                            readOnly: false, // true for view only mode
                          ),
                        ),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildTabButton(
                                () => showSheet(type: 'size'), 'Size'),
                            buildTabButton(
                                () => showColorSheet(), 'Background'),
                            buildTabButton(
                                () => showSheet(type: 'font'), 'Font'),
                          ],
                        ),
                      ],
                    ),
                  Column(
                    children: [
                      if (!isText)
                        SizedBox(
                          child: TextField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                                hintText: "Write a caption...",
                                border: InputBorder.none),
                            maxLines: 4,
                          ),
                        ),
                      if (widget.post.p['type'] == 'image')
                        SizedBox(
                          // height: MediaQuery.of(context).size.height * 0.35,
                          width: double.infinity,
                          child: Image.network(
                            widget.post.p['postUrl'].toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (widget.post.p['type'] == 'video')
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          width: double.infinity,
                          child: GetVideoPost(
                            data: widget.post.p['postUrl'].toString(),
                          ),
                        ),
                      if (widget.post.p['type'] == 'audio')
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: double.infinity,
                          child: Center(
                            child: GetAudio(
                              audioUrl: widget.post.p['postUrl'].toString(),
                            ),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  OutlinedButton buildTabButton(Function() ontap, String name) {
    return OutlinedButton(
      onPressed: ontap,
      child: RichText(
        text: TextSpan(
          text: name,
          style: completeDropdown,
        ),
      ),
    );
  }

  showSheet({required String type}) {
    showModalBottomSheet<void>(
        context: context,
        elevation: 0,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return TextSizeSheet(
              onValue: getFontsize, type: type, onFont: getFont);
        });
  }

  getAndSetData(
    Color? color,
    LinearGradient? linearGradient,
    List? postGredient,
    Uint8List? img,
  ) {
    setState(() {
      if (color != null) {
        _shadeColor = color;
        _colorGradient = null;
        _bgimage = null;
      }
      if (linearGradient != null) {
        _colorGradient = linearGradient;
        _postGredient = postGredient;
        _bgimage = null;
      }
      if (img != null) {
        _bgimage = img;
        _colorGradient = null;
      }
    });
  }

  showColorSheet() {
    showModalBottomSheet<void>(
        context: context,
        elevation: 0,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return BGColorSet(onData: getAndSetData);
        });
  }

  getFontsize(double val) {
    setState(() => _value = val);
  }

  getFont(String val) {
    setState(() => fontFamily = val);
  }
}
