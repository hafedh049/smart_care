import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../stuff/globals.dart';

class WaitRoom extends StatelessWidget {
  const WaitRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setS) {
        return Scaffold(
          backgroundColor: darkBlue,
          body: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Center(
              child: LottieBuilder.asset(
                "assets/lottie/wait.json",
              ),
            ),
          ),
        );
      },
    );
  }
}
