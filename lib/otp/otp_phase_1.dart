import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_care/otp/opt_phase_2.dart';
import 'package:health_care/stuff/functions.dart';
import 'package:lottie/lottie.dart';
import '../stuff/classes.dart';
import '../stuff/globals.dart';

class OTPView extends StatefulWidget {
  const OTPView({super.key});

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  final TextEditingController _phoneController = TextEditingController();
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setS) {
        return Scaffold(
          key: otp1ScaffoldKey,
          drawer: HealthDrawer(
            func: () {
              otp1ScaffoldKey.currentState!.closeDrawer();
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
                  Translate(text: "OTP Recovery", color: blue, fontWeight: FontWeight.bold, to: language).animate().fadeIn(duration: 2.seconds),
                  Translate(text: "First Phase.", fontWeight: FontWeight.bold, to: language).animate().fadeIn(duration: 2.seconds),
                  Translate(text: "Please enter your phone number to send OTP code.", fontSize: 16, to: language).animate().fadeIn(duration: 2.seconds),
                  const SizedBox(height: 40),
                  CustomTextField(controller: _phoneController, hint: "Phone Number", to: language, prefix: FontAwesomeIcons.phone, type: TextInputType.phone),
                  const SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        //await sendSms("23566502", "TEST");
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const OTP()));
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
                  LottieBuilder.asset("assets/phase_1.json"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
