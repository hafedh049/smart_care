import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:smart_care/authentification/pwd_strength.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:smart_care/view-models/signup_viewmodel.dart';

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

  final SignUpViewModel _viewModel = Get.put(SignUpViewModel());

  bool _next = true;
  bool _previous = false;
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
        body: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
                GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronLeft, size: 15))),
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
                        onTap: () async {
                          await showModalBottomSheet(
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
                                    icon: FontAwesomeIcons.x,
                                  ),
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
                                        icon: FontAwesomeIcons.camera,
                                      ),
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
                        child: StatefulBuilder(key: _profilePictureKey, builder: (BuildContext context, void Function(void Function()) func) => CircleAvatar(backgroundColor: grey.withOpacity(.2), radius: 40, child: _profilePicture == null ? const Icon(FontAwesomeIcons.user, color: grey, size: 35) : CircleAvatar(radius: 40, backgroundColor: transparent, backgroundImage: FileImage(_profilePicture!)))),
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
                      Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[CustomizedText(text: 'whatisyourname'.tr, fontSize: 18), const SizedBox(height: 20), CustomTextField(func: (String text) => _viewModel.name = text, validator: fieldsValidator["username"], controller: _usernameController, hint: 'name'.tr, prefix: FontAwesomeIcons.userDoctor, type: TextInputType.name)]),
                      Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[CustomizedText(text: 'canyouprovidemewithyouremployeeIDormatricule'.tr, fontSize: 18), const SizedBox(height: 20), CustomTextField(func: (String text) => _viewModel.id = text, validator: fieldsValidator["id"], controller: _matriculeController, hint: 'iD'.tr, prefix: FontAwesomeIcons.userSecret)]),
                      Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[CustomizedText(text: 'wouldyoumindsharingyouremailaddresswithme'.tr, fontSize: 18), const SizedBox(height: 20), CustomTextField(func: (String text) => _viewModel.email = text, validator: fieldsValidator["email"], controller: _emailController, hint: 'email'.tr, prefix: FontAwesomeIcons.envelope, type: TextInputType.emailAddress)]),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomizedText(text: 'youwillneedtosetupapasswordforyouraccount'.tr, fontSize: 18),
                          const SizedBox(height: 20),
                          CustomTextField(func: (String text) => _passwordStrenghtKey.currentState!.setState(() => _viewModel.password = text), validator: fieldsValidator["password"], controller: _passwordController, hint: 'password'.tr, prefix: FontAwesomeIcons.lock, obscured: true),
                          const SizedBox(height: 10),
                          Flexible(child: Padding(padding: const EdgeInsets.only(right: 8.0), child: StatefulBuilder(key: _passwordStrenghtKey, builder: (BuildContext context, void Function(void Function()) _) => PasswordStrength(password: _passwordController.text.trim())))),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomizedText(text: 'mayIhaveyourphonenumberplease'.tr, fontSize: 18),
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
                              onChanged: (PhoneNumber value) => _viewModel.phoneNumber = value.completeNumber,
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
                        onTap: _next ? navigate : () => _viewModel.create(context, _profilePicture, () => setS(() => _next = false)),
                        child: AnimatedContainer(
                          duration: 500.ms,
                          height: 40,
                          width: MediaQuery.of(context).size.width * .6,
                          decoration: BoxDecoration(color: _next ? blue : grey.withOpacity(.5), borderRadius: BorderRadius.circular(5)),
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
                          child: Padding(padding: const EdgeInsets.all(8), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[const Icon(FontAwesomeIcons.chevronLeft, size: 15, color: black), const Spacer(), CustomizedText(text: 'back'.tr, color: black, fontWeight: FontWeight.bold, fontSize: 20), const Spacer()])),
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
