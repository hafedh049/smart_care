import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smart_care/authentification/sign_in.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setS) {
      return Scaffold(
        backgroundColor: darkBlue,
        body: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
              Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
              Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue.withOpacity(.5)), const SizedBox(width: 30)]),
              const SizedBox(height: 30),
              CustomizedText(text: AppLocalizations.of(context)!.virtual, color: blue, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
              CustomizedText(text: AppLocalizations.of(context)!.ecosystem, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
              CustomizedText(text: AppLocalizations.of(context)!.specialized_healthcare, fontSize: 16).animate().fadeIn(duration: 500.ms),
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
                    ).animate().fadeIn(duration: 500.ms),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await db!.update("SMART_CARE", <String, dynamic>{"FIRST_TIME": 0});
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const SignIn()));
                },
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue),
                  child: Center(child: CustomizedText(text: AppLocalizations.of(context)!.get_started, fontWeight: FontWeight.bold, fontSize: 25)),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
