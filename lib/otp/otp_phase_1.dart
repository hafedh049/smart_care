import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_care/otp/opt_phase_2.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
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
          body: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: <Widget>[const SizedBox(width: 10), CustomIcon(func: () => Navigator.pop(context), icon: FontAwesomeIcons.chevronLeft), const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
                    Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
                    Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), const SizedBox(width: 30)]),
                    const SizedBox(height: 40),
                    Translate(text: AppLocalizations.of(context)!.otp_recovery, color: blue, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
                    Translate(text: AppLocalizations.of(context)!.first_phase, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
                    Translate(text: AppLocalizations.of(context)!.enter_phone_number, fontSize: 16).animate().fadeIn(duration: 500.ms),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InternationalPhoneNumberInput(
                        initialValue: PhoneNumber(isoCode: "TN", dialCode: "+216"),
                        searchBoxDecoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.country,
                          labelStyle: GoogleFonts.abel(color: blue, fontSize: 16, fontWeight: FontWeight.bold),
                          prefix: Padding(padding: const EdgeInsets.only(right: 8.0), child: Icon(FontAwesomeIcons.flag, size: 15, color: blue)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
                        ),
                        autoValidateMode: AutovalidateMode.always,
                        focusNode: _phoneNode,
                        cursorColor: blue,
                        errorMessage: AppLocalizations.of(context)!.not_valid_number,
                        inputBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
                        onInputChanged: (PhoneNumber value) {
                          countryCode = value.dialCode!;
                        },
                        textStyle: GoogleFonts.abel(fontSize: 16),
                        spaceBetweenSelectorAndTextField: 0,
                        textFieldController: _phoneController,
                        selectorTextStyle: GoogleFonts.abel(fontSize: 16),
                        selectorButtonOnErrorPadding: 0,
                        onInputValidated: (bool value) => value ? _phoneNode.unfocus() : null,
                        selectorConfig: const SelectorConfig(leadingPadding: 8.0, selectorType: PhoneInputSelectorType.BOTTOM_SHEET, trailingSpace: false, useEmoji: true, setSelectorButtonAsPrefixIcon: true),
                        inputDecoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.phone_number,
                          labelStyle: GoogleFonts.abel(color: blue, fontSize: 16, fontWeight: FontWeight.bold),
                          prefix: Padding(padding: const EdgeInsets.only(right: 8.0), child: Icon(FontAwesomeIcons.phone, size: 15, color: blue)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
                        ),
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
                                    setS(() => wait = true);
                                    await FirebaseAuth.instance.verifyPhoneNumber(
                                      phoneNumber: "$countryCode${_phoneController.text.trim().replaceAll(RegExp(r' '), '')}",
                                      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {},
                                      verificationFailed: (FirebaseAuthException error) {
                                        setS(() => wait = false);
                                        showToast(error.message!, color: red);
                                      },
                                      timeout: 1.minutes,
                                      forceResendingToken: 1,
                                      codeSent: (String verificationId, int? forceResendingToken) async {
                                        setS(() => wait = false);
                                        showToast("SMS Sent", color: green);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) => OTP(verification: verificationId),
                                          ),
                                        );
                                      },
                                      codeAutoRetrievalTimeout: (String verificationId) {},
                                    );
                                  } else {
                                    showToast(AppLocalizations.of(context)!.verify_fields_please);
                                  }
                                } catch (_) {
                                  setS(() => wait = false);
                                  showToast(_.toString());
                                }
                              },
                              child: AnimatedContainer(
                                duration: 500.ms,
                                height: 40,
                                width: wait ? MediaQuery.of(context).size.width * .35 : MediaQuery.of(context).size.width * .6,
                                decoration: BoxDecoration(color: wait ? green : blue, borderRadius: BorderRadius.circular(25)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      if (!wait) const Spacer(),
                                      Translate(text: wait ? AppLocalizations.of(context)!.sending : AppLocalizations.of(context)!.send_sms, fontWeight: FontWeight.bold, fontSize: 20),
                                      if (!wait) const Spacer(),
                                      if (!wait) CircleAvatar(radius: 17, backgroundColor: darkBlue, child: const Icon(FontAwesomeIcons.chevronRight, size: 15)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    LottieBuilder.asset("assets/phase_1.json"),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
