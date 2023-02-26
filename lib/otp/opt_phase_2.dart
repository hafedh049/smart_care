import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:sms_advanced/sms_advanced.dart';

import '../stuff/classes.dart';
import '../stuff/globals.dart';

class OTP extends StatefulWidget {
  const OTP({super.key});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final OtpFieldController _otpFieldController = OtpFieldController();
  @override
  void initState() {
    receiver.onSmsReceived!.listen((SmsMessage msg) => _otpFieldController.set(msg.body!.split('')));
    Future.delayed(3.seconds, () {
      _otpFieldController.set("12345".split(''));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setS) {
        return Scaffold(
          key: otp2ScaffoldKey,
          drawer: HealthDrawer(
            func: () {
              otp2ScaffoldKey.currentState!.closeDrawer();
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
                  Translate(text: "Wait For", color: blue, fontWeight: FontWeight.bold, to: language).animate().fadeIn(duration: 2.seconds),
                  Translate(text: "SMS Notification.", fontWeight: FontWeight.bold, to: language).animate().fadeIn(duration: 2.seconds),
                  Translate(text: "The pin fields will automatically be filled when sms is intercepted.", fontSize: 16, to: language).animate().fadeIn(duration: 2.seconds),
                  const SizedBox(height: 40),
                  IgnorePointer(
                    ignoring: true,
                    child: OTPTextField(
                      length: 5,
                      outlineBorderRadius: 5,
                      controller: _otpFieldController,
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 40,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.abel(fontSize: 17),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.box,
                      onChanged: (String pin) {},
                      onCompleted: (String pin) {},
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
                    child: GestureDetector(
                      onTap: () async {
                        //await sendSms("23566502", "TEST");
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
                              Translate(text: "Sign-In", fontSize: 20, fontWeight: FontWeight.bold, to: language),
                              const Spacer(),
                              CircleAvatar(radius: 17, backgroundColor: darkBlue, child: const Icon(FontAwesomeIcons.chevronRight, size: 15)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(child: LottieBuilder.asset("assets/shield.json")),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
