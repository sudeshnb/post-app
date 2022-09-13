import 'package:flutter/material.dart';

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({Key? key}) : super(key: key);

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with TickerProviderStateMixin {
  late Animation<int> _characterCount;

  int _stringIndex = 0;
  // static const List<String> _kStrings = <String>['Poetically'];
  String currentString = 'Poetically~';
  late AnimationController _breathingController;
  var _breathe = 0.0;
  late AnimationController _angleController;
  late AnimationController _textController;
  @override
  void initState() {
    super.initState();
    // typing();
    _breathingController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _breathingController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _breathingController.forward();
      }
    });
    _breathingController.addListener(() {
      if (mounted) {
        setState(() {
          _breathe = _breathingController.value;
        });
      }
    });
    _breathingController.forward();
    _angleController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 200));
    _angleController.addListener(() {});
    //
    _textController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    if (mounted) {
      setState(() => _stringIndex = _stringIndex + 1);
    }

    _textController.forward();
    _characterCount = StepTween(begin: 0, end: currentString.length).animate(
        CurvedAnimation(parent: _textController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _angleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = 300.0 - 30.0 * _breathe;
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: SizedBox(
                height: size,
                width: size,
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => const LinearGradient(stops: [
                    0.2,
                    1,
                  ], colors: [
                    Color(0XFF590148),
                    Color(0xFFFB3161),
                  ]).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: Image.asset(
                    'assets/image/logo-1.png',
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: AnimatedBuilder(
                  animation: _characterCount,
                  builder: (context, child) {
                    String text =
                        currentString.substring(0, _characterCount.value);
                    return ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0XFF590148),
                          Color(0xFFFB3161),
                          // Color(0XFF590148),
                        ],
                        end: Alignment.topRight,
                        begin: Alignment.bottomLeft,
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                      child: Text(
                        text,
                        style: const TextStyle(
                          letterSpacing: 1,
                          fontSize: 35,
                          fontFamily: 'Parnaso',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
