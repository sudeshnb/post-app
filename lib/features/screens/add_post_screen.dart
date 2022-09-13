import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/theme/app_theme.dart';
import 'package:poetic_app/core/utils/colors.dart';
import 'package:poetic_app/core/utils/overlay.dart';
import 'package:poetic_app/core/utils/text_style.dart';
import 'package:poetic_app/core/utils/utils.dart';
import 'package:poetic_app/features/providers/user_provider.dart';
import 'package:poetic_app/features/resources/firestore_methods.dart';
import 'package:poetic_app/features/resources/storage_methods.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:video_player/video_player.dart';

import 'widgets/bg_color_set.dart';
import 'widgets/text_b_sheet.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final scrollController = ScrollController();
  // final conroller = TextEditingController();
  bool isLoading = false;
  final QuillController _controller = QuillController.basic();
  late VideoPlayerController _videoPlayerController;
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Uint8List? _file;
  String fileType = '';
  // Uint8List? emptyFile = Uint8List(1);
  String fontValue = 'avenir';
  // File? _imageFile = null;
  File? videoFile;
  File? _audio;
  bool isText = false;
  bool isFontSize = false;
  final picker = ImagePicker();
  Uint8List? _bgimage;
  double _value = 20;
  List? _postGredient;
  LinearGradient? _colorGradient;
  Future pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'wma'],
    );
    // setState(() =>_audio=result);
    if (result != null) {
      setState(() {
        isText = false;
        _audio = File(result.files.single.path!);
        _file = _audio!.readAsBytesSync();
        fileType = 'audio';
        // if (_audio != null) isShow = true;
      });
    }
  }

  Future pickVideos() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      isText = false;
      videoFile = File(pickedFile!.path);
      _file = videoFile!.readAsBytesSync();
      fileType = 'video';
    });

    _videoPlayerController = VideoPlayerController.file(videoFile!)
      ..initialize().then((_) {
        setState(() {
          // if (_video != null) isShow = true;
        });
        _videoPlayerController.play();
      });
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
    setState(() => fontValue = val);
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () {
        //     // Navigator.pop(context);
        //     // showSheet();
        //   },
        //   icon: const Icon(
        //     Icons.arrow_back_ios_new_outlined,
        //   ),
        // ),
        automaticallyImplyLeading: false,
        elevation: 1,
        actions: [
          TextButton(
            onPressed: () {
              var json = jsonEncode(_controller.document.toDelta().toJson());
              List category = [];
              setState(() {
                if (userProvider.getUser.accountType == 'Writer/poet') {
                  category = ['Poetry', 'Write'];
                }
                if (userProvider.getUser.accountType ==
                    'Playback singer/audio recorder') {
                  category = ['Playback Song', 'Audio Record'];
                }
                if (userProvider.getUser.accountType == 'Composer/publisher') {
                  category = ['Compose', 'Publish'];
                }
                if (userProvider.getUser.accountType ==
                    'Marketing promoter/advertiser') {
                  category = ['Marketing Promote', 'Advertise'];
                }
                if (userProvider.getUser.accountType == 'General user') {
                  category = ['non', 'Write'];
                }
              });

              postImage(
                category,
                json,
                fontValue,
                _value,
                theme.textBoxColor,
              );
            },
            child: RichText(
              text: TextSpan(
                text: 'Publish',
                style: TextStyle(
                  fontSize: 20,
                  color: theme.textColor,
                ),
              ),
            ),
          ),
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
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      if (isText)
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
                            showLink: false,
                            showVideoButton: false,
                            showImageButton: false,
                            showInlineCode: false,
                            showSmallButton: false,
                            // showStrikeThrough: false,
                            // showClearFormat: false,
                            // showJustifyAlignment: false,
                            // multiRowsDisplay: false,
                            // showClearFormat: false,
                            showAlignmentButtons: true,
                            // showDirection: true,
                            showCodeBlock: false,
                            showListCheck: false,
                          ),
                        ),
                      if (isText)
                        Container(
                          padding: EdgeInsets.all(3 * SizeOF.width!),
                          height: 25 * SizeOF.height!,
                          margin: EdgeInsets.only(bottom: 3 * SizeOF.height!),
                          decoration: BoxDecoration(
                            image: _bgimage != null
                                ? DecorationImage(
                                    image: MemoryImage(_bgimage!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: _colorGradient != null
                                ? null
                                : _shadeColor != null
                                    ? _shadeColor!
                                    : secondaryColor.withOpacity(0.1),
                            gradient: _colorGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: QuillEditor(
                            controller: _controller,
                            // customStyleBuilder: ,
                            customStyles: DefaultStyles(
                              paragraph: DefaultTextBlockStyle(
                                  TextStyle(
                                      fontSize: _value,
                                      fontFamily: fontValue,
                                      color: theme.textColor),
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
                      if (isText)
                        Padding(
                          padding: EdgeInsets.only(bottom: 3 * SizeOF.height!),
                          child: Row(
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
                        ),
                      if (_file != null)
                        if (fileType == 'image')
                          SizedBox(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter,
                                  image: MemoryImage(_file!),
                                )),
                              ),
                            ),
                          ),
                      if (fileType == 'video')
                        AspectRatio(
                          aspectRatio: 1.5,
                          // aspectRatio:
                          //     _videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController),
                        ),
                      if (fileType == 'audio')
                        AspectRatio(
                          aspectRatio: 1.5,
                          // aspectRatio:
                          //     _videoPlayerController.value.aspectRatio,
                          child: CircleAvatar(
                            child: Icon(
                              Icons.music_note,
                              size: 20 * SizeOF.height!,
                            ),
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 0.3,
                              color: secondaryColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                        height: 9 * SizeOF.height!,
                        margin: EdgeInsets.only(bottom: 15 * SizeOF.height!),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            btnforpost(
                              onTap: () {
                                setState(() {
                                  isText = true;
                                  _file = null;
                                  fileType = 'text';
                                });
                              },
                              icon: Icons.text_fields_outlined,
                            ),
                            btnforpost(
                              onTap: () async {
                                Uint8List file =
                                    await pickImage(ImageSource.camera);
                                setState(() {
                                  isText = false;
                                  _file = file;
                                  fileType = 'image';
                                });
                              },
                              icon: Icons.camera_enhance_outlined,
                            ),
                            btnforpost(
                              onTap: () async {
                                Uint8List file =
                                    await pickImage(ImageSource.gallery);
                                setState(() {
                                  _file = file;
                                  isText = false;
                                  fileType = 'image';
                                });
                              },
                              icon: Icons.insert_photo_sharp,
                            ),
                            btnforpost(
                              onTap: pickAudio,
                              icon: Icons.audiotrack,
                            ),
                            btnforpost(
                              onTap: pickVideos,
                              icon: Icons.video_camera_back_outlined,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector buildTabButton(Function() ontap, String name) {
    return GestureDetector(
      onTap: ontap,
      child: RichText(
        text: TextSpan(
          text: name,
          style: completeDropdown,
        ),
      ),
    );
  }

  Row buildFontSize(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RichText(
          text: TextSpan(
            text: 'A',
            style: TextStyle(
              fontSize: 14,
              color: theme.textColor,
            ),
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
            },
          ),
        ),
        RichText(
          text: TextSpan(
            text: 'A',
            style: TextStyle(
              fontSize: 20,
              color: theme.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void postImage(
    List type,
    String json,
    String font,
    double size,
    Color color,
  ) async {
    setState(() => isLoading = true);
    String bgPhotoUrl = '';
    // start the loading
    try {
      if (_bgimage != null) {
        bgPhotoUrl = await StorageMethods()
            .uploadImageToStorage('posts_bg', _bgimage, true);
      }

      String res = await FireStoreMethods().uploadPost(
        type,
        isText ? json : _descriptionController.text,
        // _file != null ? _file! : emptyFile,
        _file,
        setColorToString(
            _shadeColor != null ? _shadeColor.toString() : color.toString()),
        fileType,
        size,
        font,
        _postGredient != null ? _postGredient! : [],
        bgPhotoUrl,
      );
      if (res == "success") {
        setState(() => isLoading = false);
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/HomePage',
          (route) => false,
        );

        showAutoCloseDialog(context, 'success', 'done');
        clearPaths();
      } else {
        showAutoCloseDialog(context, 'something went wrong', 'error');
      }
    } catch (err) {
      setState(() => isLoading = false);
      showAutoCloseDialog(context, 'something went wrong', 'error');
    }
  }

  void clearPaths() {
    setState(() {
      videoFile = null;
      _file = null;
      _audio = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  InkWell btnforpost({required Function() onTap, required IconData icon}) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 12 * SizeOF.width!,
        width: 12 * SizeOF.width!,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.textBoxColor,
          boxShadow: [
            BoxShadow(
              color: darkBlue.withOpacity(0.3),
              offset: const Offset(0, 1),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Icon(icon),
      ),
    );
  }

  // String getFileExtension(String fileName) {
  //   var ex = fileName.split('.').last;
  //   var pre = ex.split('\'');
  //   var prefix = pre[0].trim();
  //   return "." + prefix;
  // }

  String setColorToString(String color) {
    var ex = color.split('(').last;
    var pre = ex.split(')');
    var prefix = pre[0].trim();
    return prefix;
  }

  Color? _shadeColor;
}
