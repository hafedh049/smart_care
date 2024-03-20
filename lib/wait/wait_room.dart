import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/globals.dart';

class WaitRoom extends StatelessWidget {
  const WaitRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Center(child: LottieBuilder.asset("assets/lotties/wait.json")),
      ),
    );
  }
}
