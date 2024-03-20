import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_care/utils/classes.dart';
import 'package:smart_care/utils/globals.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronLeft, size: 15, color: grey))),
              const SizedBox(height: 30),
              CustomizedText(text: "aboutUs".tr, fontSize: 35, color: blue, fontWeight: FontWeight.bold),
              const SizedBox(height: 20),
              AnimatedTextKit(totalRepeatCount: 1, displayFullTextOnTap: true, animatedTexts: <AnimatedText>[TypewriterAnimatedText(aboutUs, textStyle: GoogleFonts.roboto(fontSize: 16))]),
            ],
          ),
        ),
      ),
    );
  }
}
