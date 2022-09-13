// import 'dart:io';

// import 'package:android_path_provider/android_path_provider.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:open_file/open_file.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:poetic_app/core/utils/text_style.dart';
// import 'package:screenshot/screenshot.dart';

// class DownloadButton extends StatefulWidget {
//   const DownloadButton({Key? key, required this.url, required this.exType})
//       : super(key: key);
//   final String exType;
//   final String url;

//   @override
//   State<DownloadButton> createState() => _DownloadButtonState();
// }

// class _DownloadButtonState extends State<DownloadButton> {
//   final transitionDuration = const Duration(milliseconds: 500);
//   bool isDownloading = false;
//   ScreenshotController screenshotController = ScreenshotController();
//   double downloadProgress = 0.0;
//   void _onPressed() async {
//     if (mounted) {
//       if (await Permission.storage.request().isGranted) {
//         downloadFile(widget.url, widget.exType);
//         // getFileName(widget.url);
//         setState(() => isDownloading = true);
//         const downloadProgressStops = [0.0, 0.15, 0.45, 0.8, 1.0];
//         for (final stop in downloadProgressStops) {
//           // Wait a second to simulate varying download speeds.
//           await Future<void>.delayed(const Duration(seconds: 1));
//           // Update the download progress.
//           setState(() => downloadProgress = stop);
//           // Wait a second to simulate a final delay.
//           await Future<void>.delayed(const Duration(seconds: 1));
//           // If the user chose to cancel the download, stop the simulation.
//           if (!isDownloading) {
//             return;
//           }
//           setState(() => isDownloading = false);
//         }
//       } else {
//         await Permission.storage.request();
//       }
//     }
//   }

//   void downloadFile(String url, String fileEX) async {
//     try {
//       var response = await Dio().get(
//         url,
//         options: Options(
//           responseType: ResponseType.bytes,
//           followRedirects: false,
//           receiveTimeout: 0,
//         ),
//       );

//       final directory = await AndroidPathProvider.downloadsPath;

//       final file =
//           File('$directory/${getFileName(url)}.${getFileType(fileEX)}');
//       final raf = file.openSync(mode: FileMode.writeOnly);

//       raf.writeFromSync(response.data);
//       await raf.close();
//       OpenFile.open(file.path);
//     } catch (e) {
//       return null;
//     }
//   }

//   String getFileName(String url) {
//     RegExp regExp = RegExp(r'.+(\/|%2F)(.+)\?.+');
//     var matches = regExp.allMatches(url);
//     var match = matches.elementAt(0);
//     return Uri.decodeFull(match.group(2)!);
//   }

//   String getFileType(String ex) {
//     var match = 'png';
//     if (mounted) {
//       setState(() {
//         switch (ex) {
//           case 'video':
//             match = 'mp4';
//             break;
//           case 'audio':
//             match = 'mp3';
//             break;
//           case 'image':
//             match = 'png';
//             break;
//         }
//       });
//     }
//     return match;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.exType != 'text' ? _onPressed : null,
//       child: SizedBox(
//         width: 90,
//         height: 30,
//         child: Row(
//           children: [
//             const Icon(Icons.download),
//             const SizedBox(width: 10),
//             if (!isDownloading)
//               Text(
//                 'save',
//                 textAlign: TextAlign.center,
//                 style: authPageSubTitle,
//               ),
//             if (isDownloading)
//               AnimatedOpacity(
//                 duration: transitionDuration,
//                 opacity: 1.0,
//                 curve: Curves.ease,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     ProgressIndicatorWidget(
//                       downloadProgress: downloadProgress,
//                       isDownloading: isDownloading,
//                     ),
//                     if (isDownloading)
//                       const Icon(
//                         Icons.stop,
//                         size: 14,
//                         color: CupertinoColors.activeBlue,
//                       ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// @immutable
// class ProgressIndicatorWidget extends StatelessWidget {
//   const ProgressIndicatorWidget({
//     Key? key,
//     required this.downloadProgress,
//     required this.isDownloading,
//   }) : super(key: key);

//   final double downloadProgress;
//   final bool isDownloading;

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1,
//       child: TweenAnimationBuilder<double>(
//         tween: Tween(begin: 0, end: downloadProgress),
//         duration: const Duration(milliseconds: 200),
//         builder: (context, progress, child) {
//           return CircularProgressIndicator(
//             backgroundColor: Colors.white,
//             valueColor:
//                 const AlwaysStoppedAnimation(CupertinoColors.activeBlue),
//             strokeWidth: 2,
//             value: isDownloading ? null : progress,
//           );
//         },
//       ),
//     );
//   }
// }
