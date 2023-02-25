import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Scaffold(
      backgroundColor: darkBlue,
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
              Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
              Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), const SizedBox(width: 30)]),
              const SizedBox(height: 10),
              LottieBuilder.asset("assets/recover.json"),
              Text("Account", style: GoogleFonts.abel(color: blue, fontSize: 35, fontWeight: FontWeight.bold)).animate().fadeIn(duration: 2.seconds),
              Text("Recovery.", style: GoogleFonts.abel(fontSize: 35, fontWeight: FontWeight.bold)).animate().fadeIn(duration: 2.seconds),
              Text("After continuing you will recieve a mail that contains a link to recover your account in the inbox.", style: GoogleFonts.abel(fontSize: 16)).animate().fadeIn(duration: 2.seconds),
              const SizedBox(height: 30),
              CustomTextField(controller: _emailController, hint: "E-mail"),
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
                              Text("Link Sent", style: GoogleFonts.abel(fontSize: 20, fontWeight: FontWeight.bold)).animate().shimmer(duration: 5.seconds, color: blue),
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
                          Text("Continue", style: GoogleFonts.abel(fontSize: 20, fontWeight: FontWeight.bold)),
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
  }
}
