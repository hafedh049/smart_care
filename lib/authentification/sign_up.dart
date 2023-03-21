// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:clipboard_listener/clipboard_listener.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_care/authentification/choices_box.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FocusNode _phoneNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final PageController _fieldsPageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _profilePictureKey = GlobalKey();
  final GlobalKey _stepsCompletedkey = GlobalKey();
  final GlobalKey _nextKey = GlobalKey();
  final GlobalKey _previousKey = GlobalKey();
  bool _next = true;
  bool _previous = false;
  String _countryCode = "";
  File? _profilePicture;
  double _stepsCompleted = 0;
  final List<bool> _rolesList = <bool>[false, true];

  @override
  void dispose() {
    _fieldsPageController.dispose();
    _phoneNode.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (play == 1) {
          playNote("tap.wav");
        }
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: darkBlue,
        body: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
                Row(children: <Widget>[const SizedBox(width: 10), CustomIcon(func: () => Navigator.pop(context), icon: FontAwesomeIcons.chevronLeft), const Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
                Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), const SizedBox(width: 30)]),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomizedText(text: AppLocalizations.of(context)!.sign_up, color: blue, fontWeight: FontWeight.bold),
                          CustomizedText(text: AppLocalizations.of(context)!.form, fontWeight: FontWeight.bold),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (play == 1) {
                            playNote("tap.wav");
                          }
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) => SizedBox(
                              height: 160,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomIcon(
                                      size: 25,
                                      func: () {
                                        if (_profilePicture != null) {
                                          _profilePictureKey.currentState!.setState(() {
                                            _profilePicture = null;
                                          });
                                        }
                                        Navigator.pop(context);
                                      },
                                      icon: FontAwesomeIcons.x),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      CustomIcon(
                                          size: 25,
                                          func: () async {
                                            final String path = await takesFromCameraOrGallery(true);
                                            Navigator.pop(context);
                                            if (path.isNotEmpty) {
                                              _profilePictureKey.currentState!.setState(() {
                                                _profilePicture = File(path);
                                              });
                                            }
                                          },
                                          icon: FontAwesomeIcons.camera),
                                      CustomIcon(
                                        size: 25,
                                        func: () async {
                                          final String path = await takesFromCameraOrGallery(false);
                                          Navigator.pop(context);
                                          if (path.isNotEmpty) {
                                            _profilePictureKey.currentState!.setState(() {
                                              _profilePicture = File(path);
                                            });
                                          }
                                        },
                                        icon: Icons.image,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: StatefulBuilder(
                          key: _profilePictureKey,
                          builder: (BuildContext context, void Function(void Function()) func) {
                            return CircleAvatar(
                              backgroundColor: grey.withOpacity(.2),
                              radius: 40,
                              child: _profilePicture == null ? Icon(FontAwesomeIcons.user, color: grey, size: 35) : CircleAvatar(radius: 40, backgroundColor: Colors.transparent, backgroundImage: FileImage(_profilePicture!)),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Stack(
                  children: <Widget>[
                    Container(margin: const EdgeInsets.only(right: 8.0), width: MediaQuery.of(context).size.width, height: 3, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: white.withOpacity(.5))),
                    StatefulBuilder(
                      key: _stepsCompletedkey,
                      builder: (BuildContext context, void Function(void Function()) setS) {
                        return AnimatedContainer(duration: 500.ms, width: _stepsCompleted, height: 3, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue));
                      },
                    )
                  ],
                ),
                const SizedBox(height: 40),
                Flexible(
                  child: PageView(
                    controller: _fieldsPageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (int page) {
                      _stepsCompletedkey.currentState!.setState(() {
                        _stepsCompleted = (MediaQuery.of(context).size.width - 16) * page / 5;
                      });
                    },
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomizedText(text: "What is your name?", color: white, fontSize: 18),
                          const SizedBox(height: 20),
                          CustomTextField(validator: fieldsValidatorsFunction("username", context), controller: _usernameController, hint: AppLocalizations.of(context)!.username, prefix: FontAwesomeIcons.userDoctor, type: TextInputType.name),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomizedText(text: "Can you provide me with your employee ID or matricule?", color: white, fontSize: 18),
                          const SizedBox(height: 20),
                          CustomTextField(validator: fieldsValidatorsFunction("id", context), controller: _idController, hint: AppLocalizations.of(context)!.id, prefix: FontAwesomeIcons.userSecret),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomizedText(text: "Would you mind sharing your email address with me?", color: white, fontSize: 18),
                          const SizedBox(height: 20),
                          CustomTextField(validator: fieldsValidatorsFunction("email", context), controller: _emailController, hint: AppLocalizations.of(context)!.e_mail, prefix: FontAwesomeIcons.envelope, type: TextInputType.emailAddress),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomizedText(text: "You will need to set up a password for your account.", color: white, fontSize: 18),
                          const SizedBox(height: 20),
                          CustomTextField(validator: fieldsValidatorsFunction("password", context), controller: _passwordController, hint: AppLocalizations.of(context)!.password, prefix: FontAwesomeIcons.lock, obscured: true),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomizedText(text: "May I have your phone number, please?", color: white, fontSize: 18),
                          const SizedBox(height: 20),
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
                                _countryCode = value.dialCode!;
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
                        ],
                      ),
                      StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) setS) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomizedText(text: "Please select your role from the following options.", color: white, fontSize: 18),
                              const SizedBox(height: 40),
                              CheckboxListTile(
                                activeColor: blue,
                                value: _rolesList[0],
                                title: CustomizedText(text: "Doctor", fontSize: 16, color: white),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (!_rolesList[0]) {
                                      _rolesList[0] = true;
                                    } else {
                                      _rolesList[0] = false;
                                    }
                                  });
                                },
                              ),
                              const SizedBox(height: 10),
                              CheckboxListTile(
                                activeColor: blue,
                                value: _rolesList[1],
                                title: CustomizedText(text: "Patient", fontSize: 16, color: white),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (!_rolesList[1]) {
                                      _rolesList[1] = true;
                                    } else {
                                      _rolesList[1] = false;
                                    }
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Center(
                  child: StatefulBuilder(
                    key: _nextKey,
                    builder: (BuildContext context, void Function(void Function()) setS) {
                      return GestureDetector(
                        onTap: _next
                            ? () async {
                                if (play == 1) {
                                  playNote("tap.wav");
                                }
                                if (_formKey.currentState!.validate()) {
                                  await _fieldsPageController.nextPage(duration: 200.ms, curve: Curves.linear);

                                  if (_fieldsPageController.page!.toInt() >= 5) {
                                    _nextKey.currentState!.setState(() {
                                      _next = false;
                                    });
                                  } else {
                                    _nextKey.currentState!.setState(() {
                                      _next = true;
                                    });
                                    _previousKey.currentState!.setState(() {
                                      _previous = true;
                                    });
                                  }
                                }
                              }
                            : () async {
                                try {
                                  if (_rolesList.any((bool element) => element == true)) {
                                    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim()).then((UserCredential userCredential) async {
                                      showToast(AppLocalizations.of(context)!.account_created);
                                      String profilePictureUrl = noUser;
                                      if (_profilePicture != null) {
                                        await FirebaseStorage.instance.ref().child("profile_pictures/${userCredential.user!.uid}").putFile(_profilePicture!).then((TaskSnapshot task) async {
                                          profilePictureUrl = await task.ref.getDownloadURL();
                                        });
                                        showToast("Picture Uploaded");
                                      }
                                      await FirebaseFirestore.instance.collection("health_care_professionals").doc(FirebaseAuth.instance.currentUser!.uid).set({
                                        "account_creation_date": Timestamp.now(),
                                        "medical_professional_name": _usernameController.text.trim(),
                                        "id": _idController.text.trim(),
                                        "role": "patient",
                                        "roles_list": <String>[if (_rolesList[0]) "doctor", if (_rolesList[1]) "patient"],
                                        "uid": FirebaseAuth.instance.currentUser!.uid,
                                        "image_url": profilePictureUrl,
                                        "email": _emailController.text.trim(),
                                        "password": _passwordController.text.trim(),
                                        "phone_number": "$_countryCode${_phoneController.text.replaceAll(RegExp(r' '), '').trim()}",
                                        "status": true,
                                        "years_of_experience": "20",
                                        "patients_checked_list": [],
                                        "location": "",
                                        "speciality": "Chiropractors and massage therapists",
                                        "rating": "0",
                                        "schedules_list": [],
                                        "available_time": ["--", "--"],
                                        "age": "35",
                                        "gender": "m",
                                        "about": "",
                                      }).then((void value) async {
                                        showToast("Data Stored");
                                        // Obtain the Google sign-in credentials
                                        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
                                        final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
                                        final OAuthCredential googleCredential = GoogleAuthProvider.credential(
                                          accessToken: googleAuth.accessToken,
                                          idToken: googleAuth.idToken,
                                        );
                                        showToast("Signed With Google");
                                        // Link the email/password account with the Google account
                                        await userCredential.user!.linkWithCredential(googleCredential);
                                        showToast("Account Linked With Google");

                                        await FirebaseAuth.instance.verifyPhoneNumber(
                                          forceResendingToken: 1,
                                          timeout: 30.ms,
                                          phoneNumber: "$_countryCode${_phoneController.text.replaceAll(RegExp(r' '), '').trim()}",
                                          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
                                          verificationFailed: (FirebaseAuthException error) {},
                                          codeSent: (String verificationId, int? forceResendingToken) async {
                                            ClipboardListener.addListener(() async {
                                              ClipboardData? clipboard = await Clipboard.getData("text/plain");
                                              if (clipboard != null && clipboard.text != null && clipboard.text!.isNotEmpty && clipboard.text!.contains(RegExp(r'^\d+$'))) {
                                                String sms = clipboard.text!;
                                                PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: sms);
                                                await userCredential.user!.linkWithCredential(credential);
                                                showToast("Account Linked With Phone Number");
                                              }
                                            });
                                            ClipboardListener.removeListener(() {});
                                            await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim()).then((UserCredential value) async {
                                              showToast("Signed-In Using E-mail & Password");
                                              await FirebaseFirestore.instance.collection("health_care_professionals").doc(FirebaseAuth.instance.currentUser!.uid).update({"status": true}).then((void value) async {
                                                await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const ChoicesBox()), (Route route) => route.isFirst);
                                              });
                                            });
                                          },
                                          codeAutoRetrievalTimeout: (String verificationId) {},
                                        );
                                      });
                                    });
                                  } else {
                                    showToast(AppLocalizations.of(context)!.verify_fields_please);
                                  }
                                } catch (_) {
                                  setS(() => _next = false);
                                  showToast(_.toString());
                                }
                              },
                        child: AnimatedContainer(
                          duration: 500.ms,
                          height: 40,
                          width: MediaQuery.of(context).size.width * .6,
                          decoration: BoxDecoration(color: _next ? blue : white.withOpacity(.5), borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Spacer(),
                                CustomizedText(text: _next ? "Continue" : AppLocalizations.of(context)!.sign_in, color: black, fontWeight: FontWeight.bold, fontSize: 20),
                                const Spacer(),
                                Icon(FontAwesomeIcons.chevronRight, size: 15, color: black),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: StatefulBuilder(
                    key: _previousKey,
                    builder: (BuildContext context, void Function(void Function()) setS) {
                      return GestureDetector(
                        onTap: _previous
                            ? () async {
                                if (play == 1) {
                                  playNote("tap.wav");
                                }
                                await _fieldsPageController.previousPage(duration: 200.ms, curve: Curves.linear);
                                if (_fieldsPageController.page!.toInt() == _fieldsPageController.initialPage) {
                                  _previousKey.currentState!.setState(() {
                                    _previous = false;
                                  });
                                } else {
                                  _previousKey.currentState!.setState(() {
                                    _previous = true;
                                  });
                                  _nextKey.currentState!.setState(() {
                                    _next = true;
                                  });
                                }
                              }
                            : null,
                        child: AnimatedContainer(
                          duration: 500.ms,
                          height: 40,
                          width: MediaQuery.of(context).size.width * .6,
                          decoration: BoxDecoration(color: _previous ? blue : white.withOpacity(.5), borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.chevronLeft, size: 15, color: black),
                                const Spacer(),
                                CustomizedText(text: "Back", color: black, fontWeight: FontWeight.bold, fontSize: 20),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
