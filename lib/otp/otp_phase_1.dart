import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:smart_care/otp/opt_phase_2.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:lottie/lottie.dart';
import '../stuff/classes.dart';
import '../stuff/globals.dart';

class OTPView extends StatefulWidget {
  const OTPView({super.key});

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool wait = false;
  String _fullPhoneNumber = "";
  final TextEditingController _phoneController = TextEditingController();
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
                Row(children: <Widget>[const SizedBox(width: 10), CustomIcon(func: () => Navigator.pop(context), icon: FontAwesomeIcons.chevronLeft), const Spacer(), const CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
                const Row(children: <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
                const SizedBox(height: 40),
                CustomizedText(text: 'oTPRecovery'.tr, color: blue, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
                CustomizedText(text: 'firstPhase'.tr, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
                CustomizedText(text: 'pleaseenteryourphonenumbertosendOTPcode'.tr, fontSize: 16).animate().fadeIn(duration: 500.ms),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IntlPhoneField(
                    initialCountryCode: "TN",
                    cursorColor: blue,
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number'.tr,
                      border: const OutlineInputBorder(borderSide: BorderSide(color: blue)),
                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: blue)),
                      disabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: blue)),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: blue)),
                      errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: red)),
                    ),
                    dropdownTextStyle: GoogleFonts.roboto(fontSize: 16),
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[\d \+]'))],
                    invalidNumberMessage: 'verifyfieldsplease'.tr,
                    dropdownDecoration: const BoxDecoration(),
                    textInputAction: TextInputAction.done,
                    onChanged: (PhoneNumber value) => _fullPhoneNumber = value.completeNumber,
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) setS) {
                      return IgnorePointer(
                        ignoring: wait,
                        child: GestureDetector(
                          onTap: () async {
                            try {
                              if (_formKey.currentState!.validate()) {
                                QuerySnapshot<Map<String, dynamic>> samples = await FirebaseFirestore.instance.collection("users").where("phone_number", isEqualTo: _fullPhoneNumber).limit(1).get();
                                if (samples.docs.isNotEmpty) {
                                  setS(() => wait = true);
                                  await FirebaseAuth.instance.signInWithEmailAndPassword(email: samples.docs.first.get("email"), password: samples.docs.first.get("password"));
                                  await FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber: _fullPhoneNumber,
                                    verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {},
                                    verificationFailed: (FirebaseAuthException error) {
                                      setS(() => wait = false);
                                      showToast(text: error.message!, color: red);
                                    },
                                    timeout: const Duration(seconds: 1),
                                    forceResendingToken: 1,
                                    codeSent: (String verificationId, int? forceResendingToken) async {
                                      setS(() => wait = false);
                                      showToast(text: 'sMSSent'.tr, color: blue);
                                      await goTo(OTP(verification: verificationId, email: samples.docs.first.get("email")));
                                    },
                                    codeAutoRetrievalTimeout: (String verificationId) {},
                                  );
                                } else {
                                  showToast(text: 'nouserlinkedtothisaccountpleasecreateone'.tr, color: red);
                                }
                              } else {
                                showToast(text: 'verifyfieldsplease'.tr, color: red);
                              }
                            } catch (_) {
                              setS(() => wait = false);
                              showToast(text: _.toString());
                            }
                          },
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
                                  CustomizedText(text: wait ? 'sending'.tr : 'sendSms'.tr, color: black, fontWeight: FontWeight.bold, fontSize: 20),
                                  Visibility(visible: !wait, child: const Spacer()),
                                  Visibility(visible: !wait, child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: black)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                LottieBuilder.asset("assets/lottie/phase_1.json"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
