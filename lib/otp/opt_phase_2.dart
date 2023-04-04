// ignore_for_file: use_build_context_synchronously

import 'package:clipboard_listener/clipboard_listener.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_care/authentification/choices_box.dart';
import '../stuff/classes.dart';
import '../stuff/globals.dart';

class OTP extends StatefulWidget {
  const OTP({super.key, required this.verification});
  final String verification;
  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final OtpFieldController _otpFieldController = OtpFieldController();
  String data = "";
  bool wait = false;
  final GlobalKey _buttonBuilder = GlobalKey();
  @override
  void initState() {
    ClipboardListener.addListener(() async {
      _buttonBuilder.currentState!.setState(() => wait = true);
      ClipboardData? clipboard = await Clipboard.getData("text/plain");
      if (clipboard != null && clipboard.text != null && clipboard.text!.isNotEmpty && clipboard.text!.contains(RegExp(r'^\d+$'))) {
        data = clipboard.text!;
        _otpFieldController.set(data.split(RegExp(r"")));
        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verification, smsCode: data);
        await FirebaseAuth.instance.signInWithCredential(credential).then((UserCredential value) async {
          _buttonBuilder.currentState!.setState(() => wait = false);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const ChoicesBox()), (Route route) => false);
        });
      }
    });
    ClipboardListener.removeListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setS) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: darkBlue,
          body: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: <Widget>[const SizedBox(width: 10), CustomIcon(func: () => Navigator.pop(context), icon: FontAwesomeIcons.chevronLeft), const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
                Row(children: const <Widget>[Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), SizedBox(width: 50)]),
                Row(children: const <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
                const SizedBox(height: 40),
                CustomizedText(text: AppLocalizations.of(context)!.waitFor, color: blue, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
                CustomizedText(text: AppLocalizations.of(context)!.sMSNotification, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
                CustomizedText(text: AppLocalizations.of(context)!.thepinfieldswillautomaticallybefilledwhensmsisintercepted, fontSize: 16).animate().fadeIn(duration: 500.ms),
                const SizedBox(height: 40),
                IgnorePointer(
                  ignoring: true,
                  child: OTPTextField(
                    length: 6,
                    outlineBorderRadius: 5,
                    controller: _otpFieldController,
                    width: MediaQuery.of(context).size.width,
                    fieldWidth: 40,
                    style: GoogleFonts.abel(fontSize: 17),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.box,
                    otpFieldStyle: OtpFieldStyle(
                      backgroundColor: darkBlue,
                      borderColor: white,
                      disabledBorderColor: Colors.white.withOpacity(.5),
                      enabledBorderColor: white,
                      errorBorderColor: Colors.red,
                      focusBorderColor: blue,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: StatefulBuilder(
                    key: _buttonBuilder,
                    builder: (BuildContext context, void Function(void Function()) setS) {
                      return IgnorePointer(
                        ignoring: wait,
                        child: AnimatedContainer(
                          duration: 500.ms,
                          height: 40,
                          width: wait ? MediaQuery.of(context).size.width * .35 : MediaQuery.of(context).size.width * .6,
                          decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Visibility(visible: !wait, child: const Spacer()),
                                CustomizedText(text: wait ? "Signing-In ..." : "Sign-In", color: black, fontWeight: FontWeight.bold, fontSize: 20),
                                Visibility(visible: !wait, child: const Spacer()),
                                Visibility(visible: !wait, child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: black)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Center(child: LottieBuilder.asset("assets/shield.json")),
              ],
            ),
          ),
        );
      },
    );
  }
}
