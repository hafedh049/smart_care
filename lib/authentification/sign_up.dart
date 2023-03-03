// ignore_for_file: use_build_context_synchronously

import 'package:clipboard_listener/clipboard_listener.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../home/home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FocusNode _phoneNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _jobLocationController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool wait = false;
  String countryCode = "";
  @override
  void dispose() {
    _specialityController.dispose();
    _phoneNode.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _jobLocationController.dispose();
    _serviceController.dispose();
    _cinController.dispose();
    _idController.dispose();
    _passwordController.dispose();
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
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(children: <Widget>[const SizedBox(width: 10), CustomIcon(func: () => Navigator.pop(context), icon: FontAwesomeIcons.chevronLeft), const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
                    Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
                    Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), const SizedBox(width: 30)]),
                    const SizedBox(height: 60),
                    Translate(text: AppLocalizations.of(context)!.sign_up, color: blue, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
                    Translate(text: AppLocalizations.of(context)!.form, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
                    Translate(text: AppLocalizations.of(context)!.to_create_this_form, fontSize: 16).animate().fadeIn(duration: 500.ms),
                    const SizedBox(height: 30),
                    CustomTextField(validator: fieldsValidators["username"], controller: _usernameController, hint: AppLocalizations.of(context)!.username, prefix: FontAwesomeIcons.userDoctor, type: TextInputType.name),
                    const SizedBox(height: 10),
                    CustomTextField(validator: fieldsValidators["service"], controller: _serviceController, hint: AppLocalizations.of(context)!.service, prefix: FontAwesomeIcons.servicestack),
                    const SizedBox(height: 10),
                    CustomTextField(validator: fieldsValidators["job location"], controller: _jobLocationController, hint: AppLocalizations.of(context)!.job_location, prefix: FontAwesomeIcons.locationPin),
                    const SizedBox(height: 10),
                    CustomTextField(validator: fieldsValidators["cin"], controller: _cinController, hint: AppLocalizations.of(context)!.cin, prefix: FontAwesomeIcons.idBadge, type: TextInputType.number),
                    const SizedBox(height: 10),
                    CustomTextField(validator: fieldsValidators["id"], controller: _idController, hint: AppLocalizations.of(context)!.id, prefix: FontAwesomeIcons.userSecret),
                    const SizedBox(height: 10),
                    CustomTextField(validator: fieldsValidators["email"], controller: _emailController, hint: AppLocalizations.of(context)!.e_mail, prefix: FontAwesomeIcons.envelope, type: TextInputType.emailAddress),
                    const SizedBox(height: 10),
                    CustomTextField(validator: fieldsValidators["password"], controller: _passwordController, hint: AppLocalizations.of(context)!.password, prefix: FontAwesomeIcons.lock, obscured: true),
                    const SizedBox(height: 10),
                    StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) setS) {
                        return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const SizedBox(height: 10),
                                        ...specialityList
                                            .map((String speciality_) => GestureDetector(
                                                  onTap: () {
                                                    setS(() => _specialityController.text = speciality_);
                                                    Navigator.pop(context);
                                                  },
                                                  child: SizedBox(
                                                    height: 40,
                                                    child: Translate(text: speciality_, color: white, fontSize: 16, fontWeight: FontWeight.bold),
                                                  ),
                                                ))
                                            .toList(),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: CustomTextField(controller: _specialityController, hint: AppLocalizations.of(context)!.speciality, prefix: FontAwesomeIcons.bomb, validator: fieldsValidators["speciality"], readonly: true));
                      },
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InternationalPhoneNumberInput(
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
                        initialValue: PhoneNumber(isoCode: "TN", dialCode: "+216"),
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
                    const SizedBox(height: 10),
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
                                    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim()).then((UserCredential userCredential) async {
                                      await FirebaseFirestore.instance.collection("health_care_professionals").doc(FirebaseAuth.instance.currentUser!.uid).set({
                                        "account_creation_date": Timestamp.now(),
                                        "medical_professional_name": _usernameController.text.trim(),
                                        "service": _serviceController.text.trim(),
                                        "job_location": _jobLocationController.text.trim(),
                                        "cin": _cinController.text.trim(),
                                        "id": _idController.text.trim(),
                                        "email": _emailController.text.trim(),
                                        "password": _passwordController.text.trim(),
                                        "speciality": _specialityController.text.trim(),
                                        "phone_number": "$countryCode${_phoneController.text.replaceAll(RegExp(r''), '').trim()}",
                                      }).then((void value) async {
                                        // Obtain the Google sign-in credentials
                                        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
                                        final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
                                        final OAuthCredential googleCredential = GoogleAuthProvider.credential(
                                          accessToken: googleAuth.accessToken,
                                          idToken: googleAuth.idToken,
                                        );
                                        // Link the email/password account with the Google account
                                        await userCredential.user!.linkWithCredential(googleCredential);

                                        await FirebaseAuth.instance.verifyPhoneNumber(
                                          forceResendingToken: 1,
                                          timeout: 30.ms,
                                          phoneNumber: "$countryCode${_phoneController.text.replaceAll(RegExp(r''), '').trim()}",
                                          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
                                          verificationFailed: (FirebaseAuthException error) {},
                                          codeSent: (String verificationId, int? forceResendingToken) {
                                            ClipboardListener.addListener(() async {
                                              ClipboardData? clipboard = await Clipboard.getData("text/plain");
                                              if (clipboard != null && clipboard.text != null && clipboard.text!.isNotEmpty && clipboard.text!.contains(RegExp(r'^\d+$'))) {
                                                String sms = clipboard.text!;
                                                PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: sms);
                                                await userCredential.user!.linkWithCredential(credential);
                                              }
                                            });
                                            ClipboardListener.removeListener(() {});
                                          },
                                          codeAutoRetrievalTimeout: (String verificationId) {},
                                        );
                                        setS(() => wait = false);
                                        showToast(AppLocalizations.of(context)!.account_created);
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Home()));
                                      });
                                    });
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
                                      Translate(text: wait ? AppLocalizations.of(context)!.connecting : AppLocalizations.of(context)!.sign_in, fontWeight: FontWeight.bold, fontSize: 20),
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
                    const SizedBox(height: 10),
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
