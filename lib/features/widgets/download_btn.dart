// import 'dart:io';
// import 'package:android_path_provider/android_path_provider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:open_file/open_file.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:poetic_app/core/utils/text_style.dart';

// @immutable
// class CircalDownloadButton extends StatefulWidget {
//   final String urlPath;
//   const CircalDownloadButton({Key? key, required this.urlPath})
//       : super(key: key);

//   @override
//   _CircalDownloadButtonState createState() => _CircalDownloadButtonState();
// }

// class _CircalDownloadButtonState extends State<CircalDownloadButton> {
//   DownloadController downloadController = SimulatedDownloadController(
//       url: 'widget.urlPath', fileEX: '', onOpenDownload: () {});

//   @override
//   Widget build(BuildContext context) {
//     // final downloadController = _downloadControllers[0];
//     return SizedBox(
//       width: 70,
//       child: AnimatedBuilder(
//         animation: downloadController,
//         builder: (context, child) {
//           return DownloadButton(
//             status: downloadController.downloadStatus,
//             downloadProgress: downloadController.progress,
//             onDownload: downloadController.startDownload,
//             onCancel: downloadController.stopDownload,
//             onOpen: downloadController.openDownload,
//           );
//         },
//       ),
//     );
//   }
// }

// enum DownloadStatus {
//   notDownloaded,
//   fetchingDownload,
//   downloading,
//   downloaded,
// }

// abstract class DownloadController implements ChangeNotifier {
//   DownloadStatus get downloadStatus;
//   double get progress;
//   // String get url;
//   // late String fileEX;
//   void startDownload();
//   void stopDownload();
//   void openDownload();
// }

// class SimulatedDownloadController extends DownloadController
//     with ChangeNotifier {
//   SimulatedDownloadController({
//     DownloadStatus downloadStatus = DownloadStatus.notDownloaded,
//     required String url,
//     required String fileEX,
//     double progress = 0.0,
//     required VoidCallback onOpenDownload,
//   })  : _downloadStatus = downloadStatus,
//         _progress = progress,
//         _fileEX = fileEX,
//         _url = url,
//         _onOpenDownload = onOpenDownload;

//   DownloadStatus _downloadStatus;
//   @override
//   DownloadStatus get downloadStatus => _downloadStatus;

//   double _progress;
//   final String _url;
//   final String _fileEX;
//   @override
//   double get progress => _progress;
//   // @override
//   // String get url => _url;
//   // @override
//   // String get fileEX => _fileEX;
//   final VoidCallback _onOpenDownload;

//   // final String urlPath;

//   bool _isDownloading = false;

//   @override
//   void startDownload() async {
//     if (downloadStatus == DownloadStatus.notDownloaded) {
//       if (await Permission.storage.request().isGranted) {
//         downloadFile(_url, _fileEX);
//         _doSimulatedDownload();
//       } else {
//         await Permission.storage.request();
//       }
//     }
//   }

//   @override
//   void stopDownload() {
//     if (_isDownloading) {
//       _isDownloading = false;
//       _downloadStatus = DownloadStatus.notDownloaded;
//       _progress = 0.0;
//       notifyListeners();
//     }
//   }

//   @override
//   void openDownload() {
//     if (downloadStatus == DownloadStatus.downloaded) {
//       _onOpenDownload();
//     }
//   }

//   // @override
//   void downloadFile(String url, String fileEX) async {
//     // var fileEX = (savePath.split('.').last);
//     // var filePath = savePath.replaceAll("/$fileName", '');
//     var fileName = DateTime.now().microsecond.toString();
//     try {
//       var response = await Dio().get(
//         url,
//         // onReceiveProgress: showDownloadProgress,
//         options: Options(
//           responseType: ResponseType.bytes,
//           followRedirects: false,
//           receiveTimeout: 0,
//         ),
//       );

//       // final directory = await getApplicationDocumentsDirectory();
//       final directory = await AndroidPathProvider.downloadsPath;
//       // final file = File('${directory.path}/$savePath');
//       final file = File('$directory/$fileName.$fileEX');
//       final raf = file.openSync(mode: FileMode.writeOnly);
//       // response.data is List<int> type
//       raf.writeFromSync(response.data);
//       await raf.close();
//       OpenFile.open(file.path);
//     } catch (e) {
//       return null;
//     }
//   }

//   Future<void> _doSimulatedDownload() async {
//     _isDownloading = true;
//     _downloadStatus = DownloadStatus.fetchingDownload;
//     notifyListeners();
//     // Wait a second to simulate fetch time.
//     await Future<void>.delayed(const Duration(seconds: 1));
//     // If the user chose to cancel the download, stop the simulation.
//     if (!_isDownloading) {
//       return;
//     }
//     // Shift to the downloading phase.
//     _downloadStatus = DownloadStatus.downloading;
//     notifyListeners();
//     const downloadProgressStops = [0.0, 0.15, 0.45, 0.8, 1.0];
//     for (final stop in downloadProgressStops) {
//       // Wait a second to simulate varying download speeds.
//       await Future<void>.delayed(const Duration(seconds: 1));

//       // If the user chose to cancel the download, stop the simulation.
//       if (!_isDownloading) {
//         return;
//       }
//       // Update the download progress.
//       _progress = stop;
//       notifyListeners();
//     }

//     // Wait a second to simulate a final delay.
//     await Future<void>.delayed(const Duration(seconds: 1));

//     // If the user chose to cancel the download, stop the simulation.
//     if (!_isDownloading) {
//       return;
//     }

//     // Shift to the downloaded state, completing the simulation.
//     _downloadStatus = DownloadStatus.downloaded;
//     _isDownloading = false;
//     notifyListeners();
//   }
// }

// @immutable
// class DownloadButton extends StatelessWidget {
//   const DownloadButton({
//     Key? key,
//     required this.status,
//     this.downloadProgress = 0.0,
//     required this.onDownload,
//     required this.onCancel,
//     required this.onOpen,
//     this.transitionDuration = const Duration(milliseconds: 500),
//   }) : super(key: key);

//   final DownloadStatus status;
//   final double downloadProgress;
//   final VoidCallback onDownload;
//   final VoidCallback onCancel;
//   final VoidCallback onOpen;
//   final Duration transitionDuration;

//   bool get _isDownloading => status == DownloadStatus.downloading;

//   bool get _isFetching => status == DownloadStatus.fetchingDownload;

//   bool get _isDownloaded => status == DownloadStatus.downloaded;

//   void _onPressed() {
//     switch (status) {
//       case DownloadStatus.notDownloaded:
//         onDownload();
//         break;
//       case DownloadStatus.fetchingDownload:
//         // do nothing.print('notDownloaded');
//         break;
//       case DownloadStatus.downloading:
//         onCancel();
//         break;
//       case DownloadStatus.downloaded:
//         onOpen();
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _onPressed,
//       child: Stack(
//         children: [
//           ButtonShapeWidget(
//             transitionDuration: transitionDuration,
//             isDownloaded: _isDownloaded,
//             isDownloading: _isDownloading,
//             isFetching: _isFetching,
//           ),
//           Positioned.fill(
//             child: AnimatedOpacity(
//               duration: transitionDuration,
//               opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
//               curve: Curves.ease,
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   ProgressIndicatorWidget(
//                     downloadProgress: downloadProgress,
//                     isDownloading: _isDownloading,
//                     isFetching: _isFetching,
//                   ),
//                   if (_isDownloading)
//                     const Icon(
//                       Icons.stop,
//                       size: 14,
//                       color: CupertinoColors.activeBlue,
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// @immutable
// class ButtonShapeWidget extends StatelessWidget {
//   const ButtonShapeWidget({
//     Key? key,
//     required this.isDownloading,
//     required this.isDownloaded,
//     required this.isFetching,
//     required this.transitionDuration,
//   }) : super(key: key);

//   final bool isDownloading;
//   final bool isDownloaded;
//   final bool isFetching;
//   final Duration transitionDuration;

//   @override
//   Widget build(BuildContext context) {
//     // var shape = const ShapeDecoration(
//     //   shape: StadiumBorder(),
//     //   color: CupertinoColors.lightBackgroundGray,
//     // );

//     // if (isDownloading || isFetching) {
//     //   shape = ShapeDecoration(
//     //     shape: const CircleBorder(),
//     //     color: Colors.white.withOpacity(0),
//     //   );
//     // }

//     return AnimatedContainer(
//       duration: transitionDuration,
//       curve: Curves.ease,
//       width: double.infinity,
//       // decoration: shape,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 6),
//         child: AnimatedOpacity(
//           duration: transitionDuration,
//           opacity: isDownloading || isFetching ? 0.0 : 1.0,
//           curve: Curves.ease,
//           child: Row(
//             children: [
//               const Icon(Icons.download),
//               Text(
//                 isDownloaded ? ' open' : ' save',
//                 textAlign: TextAlign.center,
//                 style: authPageSubTitle,
//               ),
//             ],
//           ),
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
//     required this.isFetching,
//   }) : super(key: key);

//   final double downloadProgress;
//   final bool isDownloading;
//   final bool isFetching;

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1,
//       child: TweenAnimationBuilder<double>(
//         tween: Tween(begin: 0, end: downloadProgress),
//         duration: const Duration(milliseconds: 200),
//         builder: (context, progress, child) {
//           return CircularProgressIndicator(
//             backgroundColor: isDownloading
//                 ? CupertinoColors.lightBackgroundGray
//                 : Colors.white.withOpacity(0),
//             valueColor: AlwaysStoppedAnimation(isFetching
//                 ? CupertinoColors.lightBackgroundGray
//                 : CupertinoColors.activeBlue),
//             strokeWidth: 2,
//             value: isFetching ? null : progress,
//           );
//         },
//       ),
//     );
//   }
// }
