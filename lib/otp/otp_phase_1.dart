// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:smart_care/otp/opt_phase_2.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../stuff/classes.dart';
import '../stuff/globals.dart';

class OTPView extends StatefulWidget {
  const OTPView({super.key});

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool wait = false;
  String countryCode = "";

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setS) {
        return Scaffold(
          backgroundColor: darkBlue,
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
                  Row(children: const <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
                  const SizedBox(height: 40),
                  CustomizedText(text: AppLocalizations.of(context)!.oTPRecovery, color: blue, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
                  CustomizedText(text: AppLocalizations.of(context)!.firstPhase, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
                  CustomizedText(text: AppLocalizations.of(context)!.pleaseenteryourphonenumbertosendOTPcode, fontSize: 16).animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IntlPhoneField(
                      initialCountryCode: "TN",
                      controller: _phoneController,
                      cursorColor: blue,
                      decoration: const InputDecoration(
                        hintText: 'Enter your phone number',
                        border: OutlineInputBorder(borderSide: BorderSide(color: blue)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
                        disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
                        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: red)),
                      ),
                      initialValue: "eg: +216 23 566 502",
                      dropdownTextStyle: GoogleFonts.roboto(fontSize: 16),
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[\d \+]'))],
                      invalidNumberMessage: AppLocalizations.of(context)!.verifyfieldsplease,
                      dropdownDecoration: const BoxDecoration(),
                      textInputAction: TextInputAction.done,
                      onChanged: (PhoneNumber value) {},
                      onCountryChanged: (Country value) {},
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
                                  QuerySnapshot<Map<String, dynamic>> samples = await FirebaseFirestore.instance.collection("users").where("phone_number", isEqualTo: "$countryCode${_phoneController.text.trim().replaceAll(RegExp(r' '), '')}").get();
                                  if (samples.docs.isNotEmpty) {
                                    setS(() => wait = true);
                                    await FirebaseAuth.instance.verifyPhoneNumber(
                                      phoneNumber: "$countryCode${_phoneController.text.trim().replaceAll(RegExp(r' '), '')}",
                                      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {},
                                      verificationFailed: (FirebaseAuthException error) {
                                        setS(() => wait = false);
                                        showToast(text: error.message!, color: red);
                                      },
                                      timeout: 1.minutes,
                                      forceResendingToken: 1,
                                      codeSent: (String verificationId, int? forceResendingToken) async {
                                        setS(() => wait = false);
                                        showToast(text: AppLocalizations.of(context)!.sendSms, color: blue);
                                        goTo(OTP(verification: verificationId));
                                        //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => OTP()));
                                      },
                                      codeAutoRetrievalTimeout: (String verificationId) {},
                                    );
                                  } else {
                                    showToast(text: AppLocalizations.of(context)!.nouserlinkedtothisaccountpleasecreateone, color: red);
                                  }
                                } else {
                                  showToast(text: AppLocalizations.of(context)!.verifyfieldsplease, color: red);
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
                                    CustomizedText(text: wait ? AppLocalizations.of(context)!.sending : AppLocalizations.of(context)!.sendSms, color: black, fontWeight: FontWeight.bold, fontSize: 20),
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
        );
      },
    );
  }
}
