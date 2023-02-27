import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import '../stuff/classes.dart';
import '../stuff/globals.dart';

class ErrorRoom extends StatelessWidget {
  const ErrorRoom({super.key, required this.error});
  final String error;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setS) {
        return Scaffold(
          key: errorScaffoldKey,
          drawer: HealthDrawer(
            func: () {
              errorScaffoldKey.currentState!.closeDrawer();
              setS(() {});
            },
          ),
          backgroundColor: darkBlue,
          body: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
                  Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
                  Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), const SizedBox(width: 30)]),
                  const SizedBox(height: 10),
                  Center(child: LottieBuilder.asset("assets/error.json")),
                  const SizedBox(height: 20),
                  Center(child: Translate(text: error, fontWeight: FontWeight.bold, to: language).animate().fadeIn(duration: 500.ms)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
