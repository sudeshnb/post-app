import 'package:flutter/material.dart';
import 'package:poetic_app/features/screens/widgets/player_widget.dart';

class GetAudio extends StatefulWidget {
  const GetAudio({Key? key, required this.audioUrl}) : super(key: key);
  final String audioUrl;

  @override
  State<GetAudio> createState() => _GetAudioState();
}

class _GetAudioState extends State<GetAudio> {
  @override
  void initState() {
    if (!mounted) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlayerWidget(url: widget.audioUrl);
  }
}
