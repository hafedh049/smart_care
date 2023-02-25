import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_care/authentification/sign_in.dart';
import 'package:health_care/stuff/classes.dart';
import 'package:health_care/stuff/globals.dart';
import 'package:lottie/lottie.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
              Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
              Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue.withOpacity(.5)), const SizedBox(width: 30)]),
              const SizedBox(height: 30),
              Text("Virtual", style: GoogleFonts.abel(color: blue, fontSize: 35, fontWeight: FontWeight.bold)).animate().fadeIn(duration: 2.seconds),
              Text("Ecosystem", style: GoogleFonts.abel(fontSize: 35, fontWeight: FontWeight.bold)).animate().fadeIn(duration: 2.seconds),
              Text("Specialized healthcare, on a single tech platform, simplifying access to anyone, anywhere.", style: GoogleFonts.abel(fontSize: 16)).animate().fadeIn(duration: 2.seconds),
              Center(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    LottieBuilder.asset("assets/get_started.json", addRepaintBoundary: true, frameRate: FrameRate.max),
                    SizedBox(
                      height: 400,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: const Alignment(0, -.3),
                            child: Container(width: 130, height: 230, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: const DecorationImage(image: AssetImage("assets/female.jpg"), fit: BoxFit.cover))).animate().shimmer(color: white, duration: 5.seconds),
                          ),
                          const SizedBox(width: 20),
                          Align(
                            alignment: const Alignment(0, .3),
                            child: Container(width: 130, height: 230, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: const DecorationImage(image: AssetImage("assets/male.jpg"), fit: BoxFit.cover))).animate().shimmer(color: white, duration: 5.seconds),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 2.seconds),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const SignIn())),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircleAvatar(radius: 25, backgroundColor: blue, child: const Icon(FontAwesomeIcons.chevronRight, size: 20)).animate(onComplete: (AnimationController controller) => controller.loop(period: 3.seconds)).shake(hz: 5, rotation: pi / 9),
                    const SizedBox(width: 20),
                    Text("Get\nStarted", style: GoogleFonts.abel(fontSize: 16)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
