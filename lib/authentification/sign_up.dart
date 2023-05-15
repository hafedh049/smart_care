import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:smart_care/screens/screens.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _matriculeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final PageController _fieldsPageController = PageController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _profilePictureKey = GlobalKey();
  final GlobalKey _stepsCompletedkey = GlobalKey();
  final GlobalKey _nextKey = GlobalKey();
  final GlobalKey _previousKey = GlobalKey();
  final GlobalKey _passwordStrenghtKey = GlobalKey();
  final GlobalKey _passwordStrenghtTextKey = GlobalKey();

  String _text = "Weak";
  bool _next = true;
  bool _previous = false;
  String _completePhoneNumber = "";
  File? _profilePicture;
  double _stepsCompleted = 0;

  @override
  void dispose() {
    _fieldsPageController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _matriculeController.dispose();
    _passwordController.dispose();
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
                Row(children: <Widget>[const SizedBox(width: 10), CustomIcon(func: () => Navigator.pop(context), icon: FontAwesomeIcons.chevronLeft), const Spacer(), const CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
                const Row(children: <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[CustomizedText(text: 'signUp'.tr, color: blue, fontWeight: FontWeight.bold), CustomizedText(text: 'form'.tr, fontWeight: FontWeight.bold)]),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) => SizedBox(
                              height: 160,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
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
                                            Navigator.pop(context);
                                            final String path = await takesFromCameraOrGallery(true);

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
                                          Navigator.pop(context);
                                          final String path = await takesFromCameraOrGallery(false);
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
                        child: StatefulBuilder(key: _profilePictureKey, builder: (BuildContext context, void Function(void Function()) func) => CircleAvatar(backgroundColor: grey.withOpacity(.2), radius: 40, child: _profilePicture == null ? const Icon(FontAwesomeIcons.user, color: grey, size: 35) : CircleAvatar(radius: 40, backgroundColor: Colors.transparent, backgroundImage: FileImage(_profilePicture!)))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Stack(children: <Widget>[Container(margin: const EdgeInsets.only(right: 8.0), width: MediaQuery.of(context).size.width, height: 3, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: white.withOpacity(.5))), StatefulBuilder(key: _stepsCompletedkey, builder: (BuildContext context, void Function(void Function()) setS) => AnimatedContainer(duration: 500.ms, width: _stepsCompleted, height: 3, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue)))]),
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
                      Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[CustomizedText(text: 'whatisyourname'.tr, color: white, fontSize: 18), const SizedBox(height: 20), CustomTextField(validator: fieldsValidator["username"], controller: _usernameController, hint: 'name'.tr, prefix: FontAwesomeIcons.userDoctor, type: TextInputType.name)]),
                      Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[CustomizedText(text: 'canyouprovidemewithyouremployeeIDormatricule'.tr, color: white, fontSize: 18), const SizedBox(height: 20), CustomTextField(validator: fieldsValidator["id"], controller: _matriculeController, hint: 'iD'.tr, prefix: FontAwesomeIcons.userSecret)]),
                      Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[CustomizedText(text: 'wouldyoumindsharingyouremailaddresswithme'.tr, color: white, fontSize: 18), const SizedBox(height: 20), CustomTextField(validator: fieldsValidator["email"], controller: _emailController, hint: 'email'.tr, prefix: FontAwesomeIcons.envelope, type: TextInputType.emailAddress)]),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomizedText(text: 'youwillneedtosetupapasswordforyouraccount'.tr, color: white, fontSize: 18),
                          const SizedBox(height: 20),
                          CustomTextField(func: (String text) => _passwordStrenghtKey.currentState!.setState(() {}), validator: fieldsValidator["password"], controller: _passwordController, hint: 'password'.tr, prefix: FontAwesomeIcons.lock, obscured: true),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: StatefulBuilder(
                              key: _passwordStrenghtKey,
                              builder: (BuildContext context, void Function(void Function()) _) {
                                return FlutterPasswordStrength(
                                  strengthCallback: (double strength) {
                                    Future.delayed(
                                      300.ms,
                                      () => _passwordStrenghtTextKey.currentState!.setState(
                                        () {
                                          if (strength >= 0 && strength < .2) {
                                            _text = 'weak'.tr;
                                          } else if (strength > .2 && strength < .8) {
                                            _text = 'medium'.tr;
                                          } else {
                                            _text = 'strong'.tr;
                                          }
                                        },
                                      ),
                                    );
                                  },
                                  password: _passwordController.text.trim(),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          StatefulBuilder(key: _passwordStrenghtTextKey, builder: (BuildContext context, void Function(void Function()) _) => CustomizedText(text: _text, color: white, fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomizedText(text: 'mayIhaveyourphonenumberplease'.tr, color: white, fontSize: 18),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IntlPhoneField(
                              initialCountryCode: "TN",
                              cursorColor: blue,
                              decoration: const InputDecoration(hintText: 'Enter your phone number', border: OutlineInputBorder(borderSide: BorderSide(color: blue)), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)), disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)), errorBorder: OutlineInputBorder(borderSide: BorderSide(color: red))),
                              dropdownTextStyle: GoogleFonts.roboto(fontSize: 16),
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[\d \+]'))],
                              invalidNumberMessage: 'verifyfieldsplease'.tr,
                              textInputAction: TextInputAction.done,
                              onChanged: (PhoneNumber value) => _completePhoneNumber = value.completeNumber,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Center(
                  child: StatefulBuilder(
                    key: _nextKey,
                    builder: (BuildContext context, void Function(void Function()) setS) {
                      return GestureDetector(
                        onTap: _next ? navigate : () => create(setS),
                        child: AnimatedContainer(
                          duration: 500.ms,
                          height: 40,
                          width: MediaQuery.of(context).size.width * .6,
                          decoration: BoxDecoration(color: _next ? blue : white.withOpacity(.5), borderRadius: BorderRadius.circular(5)),
                          child: Padding(padding: const EdgeInsets.all(8.0), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[const Spacer(), CustomizedText(text: _next ? "Continue" : "Sign-In", color: black, fontWeight: FontWeight.bold, fontSize: 20), const Spacer(), const Icon(FontAwesomeIcons.chevronRight, size: 15, color: black)])),
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
                                //rjou3 bitweli
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
                          child: Padding(padding: const EdgeInsets.all(8.0), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[const Icon(FontAwesomeIcons.chevronLeft, size: 15, color: black), const Spacer(), CustomizedText(text: 'back'.tr, color: black, fontWeight: FontWeight.bold, fontSize: 20), const Spacer()])),
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

  void create(void Function(void Function()) setS) async {
    try {
      bool phoneExists = false;
      await FirebaseFirestore.instance.collection("users").where("phone_number", isEqualTo: _completePhoneNumber).count().get().then((AggregateQuerySnapshot value) => phoneExists = value.count == 0 ? false : true);
      if (phoneExists) {
        showToast(text: "This phone number already exists".tr);
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim()).then((UserCredential userCredential) async {
          showToast(text: 'accountCreated'.tr);
          String profilePictureUrl = noUser;
          if (_profilePicture != null) {
            await FirebaseStorage.instance.ref().child("profile_pictures/${userCredential.user!.uid}").putFile(_profilePicture!).then((TaskSnapshot task) async {
              profilePictureUrl = await task.ref.getDownloadURL();
            });
            showToast(text: 'pictureUploaded'.tr);
          }
          await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set({
            "name": _usernameController.text.trim(),
            "id": _matriculeController.text.trim(),
            "role": "patient",
            "uid": FirebaseAuth.instance.currentUser!.uid,
            "image_url": profilePictureUrl,
            "email": _emailController.text.trim(),
            "phone_number": _completePhoneNumber,
            "status": true,
            "date_of_birth": DateTime(1970),
            "about": "A Patient",
            "grade": "",
            "service": "",
            "token": "",
            "hospital": "",
          }).then((void value) async {
            showToast(text: 'dataStored'.tr);
            await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim()).then((UserCredential value) async {
              showToast(text: 'signedInUsingEmailPassword'.tr);
              await getToken();
              await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({"token": userToken}).then((void value) async {
                await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const Screens()), (Route route) => false);
              });
            });
          });
        });
      }
    } catch (_) {
      setS(() => _next = false);
      showToast(text: _.toString());
    }
  }

  void navigate() async {
    if (_formKey.currentState!.validate()) {
      await _fieldsPageController.nextPage(duration: 200.ms, curve: Curves.linear);

      if (_fieldsPageController.page!.toInt() >= 4) {
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
}
