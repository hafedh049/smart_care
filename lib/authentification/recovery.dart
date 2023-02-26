import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_care/stuff/classes.dart';
import 'package:health_care/stuff/globals.dart';
import 'package:lottie/lottie.dart';

class Recovery extends StatefulWidget {
  const Recovery({super.key});

  @override
  State<Recovery> createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setS) {
      return Scaffold(
        key: recoveryScaffoldKey,
        drawer: HealthDrawer(
          func: () {
            recoveryScaffoldKey.currentState!.closeDrawer();
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
                Row(children: <Widget>[const SizedBox(width: 10), CustomIcon(func: () => Navigator.pop(context), icon: FontAwesomeIcons.chevronLeft), const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
                Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
                Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), const SizedBox(width: 30)]),
                const SizedBox(height: 10),
                LottieBuilder.asset("assets/recover.json"),
                Translate(text: "Account", color: blue, fontWeight: FontWeight.bold, to: language).animate().fadeIn(duration: 2.seconds),
                Translate(text: "Recovery.", fontWeight: FontWeight.bold, to: language).animate().fadeIn(duration: 2.seconds),
                Translate(text: "After continuing you will recieve a mail that contains a link to recover your account in the inbox.", fontSize: 16, to: language).animate().fadeIn(duration: 2.seconds),
                const SizedBox(height: 30),
                CustomTextField(controller: _emailController, hint: "E-mail", to: language),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Center(child: LottieBuilder.asset("assets/ok.json")),
                                const SizedBox(height: 20),
                                Translate(text: "Link Sent", fontSize: 20, fontWeight: FontWeight.bold, to: language).animate().shimmer(duration: 5.seconds, color: blue),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * .6,
                      decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            const Spacer(),
                            Translate(text: "Continue", fontSize: 20, fontWeight: FontWeight.bold, to: language),
                            const Spacer(),
                            CircleAvatar(radius: 17, backgroundColor: darkBlue, child: const Icon(FontAwesomeIcons.chevronRight, size: 15)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
