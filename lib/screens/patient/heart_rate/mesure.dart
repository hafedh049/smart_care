import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_care/screens/patient/heart_rate/statistics.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/functions.dart';

class Mesure extends StatefulWidget {
  const Mesure({super.key});

  @override
  State<Mesure> createState() => _MesureState();
}

class _MesureState extends State<Mesure> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(children: <Widget>[const Spacer(), Center(child: LottieBuilder.asset("assets/lottie/wave.json", height: 200))]),
          Column(
            children: <Widget>[
              const SizedBox(height: 60),
              Center(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    LottieBuilder.asset("assets/lottie/rate_placeholder.json", width: 200, height: 200, fit: BoxFit.cover),
                    LottieBuilder.asset("assets/lottie/heart.json", width: 100, fit: BoxFit.cover),
                  ],
                ),
              ),
              const SizedBox(height: 100),
              GestureDetector(
                onTap: () => goTo(const Statistics()),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(child: LottieBuilder.asset("assets/lottie/fingerprint.json", width: 80, height: 80)),
                    CustomizedText(text: "Start Mesurements".tr, fontSize: 16),
                  ],
                ),
              ),
              const Spacer(),
              CustomizedText(text: "Place your index finger tightly on camera".tr, fontSize: 16),
              const SizedBox(height: 50),
            ],
          ),
        ],
      ),
    );
  }
}
