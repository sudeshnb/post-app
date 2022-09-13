import 'dart:async';
import 'package:flutter/material.dart';
import 'package:poetic_app/features/widgets/animation/animation_logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 4000), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/Wapper',
        (route) => false,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AnimatedLogo(),
    );
  }
}
