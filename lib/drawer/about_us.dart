import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';

import '../stuff/functions.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                if (play == 1) {
                  playNote("tap.wav");
                }
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                child: Icon(FontAwesomeIcons.chevronLeft, size: 15, color: grey),
              ),
            ),
            const SizedBox(height: 30),
            Center(child: CustomizedText(text: "About Us", fontSize: 35, color: blue, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            AnimatedTextKit(
              totalRepeatCount: 1,
              animatedTexts: <AnimatedText>[
                TypewriterAnimatedText(
                  aboutUs,
                  textStyle: GoogleFonts.roboto(
                    fontSize: 14,
                    color: white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
