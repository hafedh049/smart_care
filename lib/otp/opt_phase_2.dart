import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:smart_care/screens/screens.dart';
import '../stuff/classes.dart';
import '../stuff/functions.dart';
import '../stuff/globals.dart';

class OTP extends StatefulWidget {
  const OTP({super.key, required this.verification, required this.email});
  final String verification;
  final String email;
  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  bool _wait = false;
  final GlobalKey _buttonBuilder = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Row(children: <Widget>[const SizedBox(width: 10), GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronLeft, size: 15))), const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
              const Row(children: <Widget>[Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), SizedBox(width: 50)]),
              const Row(children: <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
              const SizedBox(height: 40),
              CustomizedText(text: 'waitFor'.tr, color: blue, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
              CustomizedText(text: 'sMSNotification'.tr, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
              CustomizedText(text: 'thepinfieldswillautomaticallybefilledwhensmsisintercepted'.tr, fontSize: 16).animate().fadeIn(duration: 500.ms),
              const SizedBox(height: 40),
              OTPTextField(
                length: 6,
                outlineBorderRadius: 5,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 40,
                onCompleted: (String value) async {
                  try {
                    _buttonBuilder.currentState!.setState(() => _wait = true);
                    if (value.contains(RegExp(r"\d+"))) {
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verification, smsCode: value);
                      if (!(await FirebaseAuth.instance.fetchSignInMethodsForEmail(widget.email)).contains(PhoneAuthProvider.PHONE_SIGN_IN_METHOD)) {
                        await FirebaseAuth.instance.currentUser!.linkWithCredential(credential);
                      }
                      await FirebaseAuth.instance.signInWithCredential(credential).then(
                        (UserCredential value) async {
                          _buttonBuilder.currentState!.setState(() => _wait = false);
                          await getToken();
                          await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({"token": userToken, "status": true}).then((void value) async {
                            await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const Screens()), (Route route) => false);
                          });
                        },
                      );
                    }
                  } catch (e) {
                    _buttonBuilder.currentState!.setState(() => _wait = false);
                    showToast(text: e.toString());
                    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const Screens()), (Route route) => false);
                  }
                },
                style: GoogleFonts.abel(fontSize: 17),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                otpFieldStyle: OtpFieldStyle(backgroundColor: darkBlue, borderColor: white, disabledBorderColor: white.withOpacity(.5), enabledBorderColor: white, errorBorderColor: Colors.red, focusBorderColor: blue),
              ),
              const SizedBox(height: 30),
              Center(
                child: StatefulBuilder(
                  key: _buttonBuilder,
                  builder: (BuildContext context, void Function(void Function()) setS) {
                    return _wait ? const CircularProgressIndicator(color: blue) : const SizedBox();
                  },
                ),
              ),
              Center(child: LottieBuilder.asset("assets/lottie/shield.json")),
            ],
          ),
        ),
      ),
    );
  }
}
