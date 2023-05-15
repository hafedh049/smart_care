import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../stuff/classes.dart';
import '../../stuff/functions.dart';
import '../../stuff/globals.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _passwordStrenghtKey = GlobalKey();
  final GlobalKey _passwordStrenghtTextKey = GlobalKey();
  String _text = "";
  Color _color = red;
  final List<bool> _rolesList = <bool>[false, true];

  @override
  void dispose() {
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
                  Row(children: <Widget>[CustomIcon(func: () => Navigator.pop(context), icon: FontAwesomeIcons.chevronLeft), const Spacer(), const CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
                  const Row(children: <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
                  const SizedBox(height: 20),
                  const Padding(padding: EdgeInsets.only(right: 8.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[CustomizedText(text: "ADD", color: blue, fontWeight: FontWeight.bold), CustomizedText(text: "USER", fontWeight: FontWeight.bold)])),
                  const SizedBox(height: 30),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[CustomizedText(text: 'whatisyourname'.tr, color: white, fontSize: 18), const SizedBox(height: 10), CustomTextField(validator: fieldsValidator["username"], controller: _usernameController, hint: 'name'.tr, prefix: FontAwesomeIcons.userDoctor, type: TextInputType.name)],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[CustomizedText(text: 'canyouprovidemewithyouremployeeIDormatricule'.tr, color: white, fontSize: 18), const SizedBox(height: 10), CustomTextField(validator: fieldsValidator["id"], controller: _idController, hint: 'iD'.tr, prefix: FontAwesomeIcons.userSecret)],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[CustomizedText(text: 'wouldyoumindsharingyouremailaddresswithme'.tr, color: white, fontSize: 18), const SizedBox(height: 10), CustomTextField(validator: fieldsValidator["email"], controller: _emailController, hint: 'email'.tr, prefix: FontAwesomeIcons.envelope, type: TextInputType.emailAddress)],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomizedText(text: 'youwillneedtosetupapasswordforyouraccount'.tr, color: white, fontSize: 18),
                      const SizedBox(height: 10),
                      CustomTextField(func: (String text) => _passwordStrenghtKey.currentState!.setState(() {}), validator: fieldsValidator["password"], controller: _passwordController, hint: 'password'.tr, prefix: FontAwesomeIcons.lock, obscured: true),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: StatefulBuilder(
                          key: _passwordStrenghtKey,
                          builder: (BuildContext context, void Function(void Function()) _) {
                            return FlutterPasswordStrength(
                              backgroundColor: transparent,
                              strengthCallback: (double strength) {
                                Future.delayed(
                                  300.ms,
                                  () => _passwordStrenghtTextKey.currentState!.setState(
                                    () {
                                      if (strength >= 0 && strength < .2) {
                                        _text = 'weak'.tr;
                                        _color = red;
                                      } else if (strength > .2 && strength < .8) {
                                        _text = 'medium'.tr;
                                        _color = blue;
                                      } else {
                                        _text = 'strong'.tr;
                                        _color = green;
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
                      StatefulBuilder(key: _passwordStrenghtTextKey, builder: (BuildContext context, void Function(void Function()) _) => CustomizedText(text: _text, color: _color, fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomizedText(text: 'mayIhaveyourphonenumberplease'.tr, color: white, fontSize: 18),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IntlPhoneField(
                          initialCountryCode: "TN",
                          controller: _phoneController,
                          cursorColor: blue,
                          decoration: const InputDecoration(hintText: 'Enter your phone number', border: OutlineInputBorder(borderSide: BorderSide(color: blue)), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)), disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)), errorBorder: OutlineInputBorder(borderSide: BorderSide(color: red))),
                          initialValue: "eg: +216 23 566 502",
                          dropdownTextStyle: GoogleFonts.roboto(fontSize: 16),
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[\d \+]'))],
                          invalidNumberMessage: 'verifyfieldsplease'.tr,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) setS) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CustomizedText(text: 'pleaseselectyourrolefromthefollowingoptions'.tr, color: white, fontSize: 18),
                          const SizedBox(height: 20),
                          CheckboxListTile(activeColor: blue, value: _rolesList[0], title: CustomizedText(text: 'doctor'.tr, fontSize: 16, color: white), onChanged: (bool? value) => setState(() => _rolesList[0] = (_rolesList[0]) ? false : true)),
                          const SizedBox(height: 10),
                          CheckboxListTile(activeColor: blue, value: _rolesList[1], title: CustomizedText(text: 'patient'.tr, fontSize: 16, color: white), onChanged: (bool? value) => setState(() => _rolesList[1] = (_rolesList[1]) ? false : true)),
                          const SizedBox(height: 10),
                          CheckboxListTile(activeColor: blue, value: _rolesList[2], title: CustomizedText(text: 'laboratory'.tr, fontSize: 16, color: white), onChanged: (bool? value) => setState(() => _rolesList[2] = (_rolesList[2]) ? false : true)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) setS) {
                        return GestureDetector(
                          onTap: () async {
                            try {
                              if (_formKey.currentState!.validate() && _rolesList.any((bool element) => element == true)) {
                                await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim()).then((UserCredential userCredential) async {
                                  showToast(text: 'accountCreated'.tr);
                                  await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set({
                                    "name": _usernameController.text.trim(),
                                    "id": _idController.text.trim(),
                                    "role": _rolesList[0] ? "doctor" : "patient",
                                    "uid": FirebaseAuth.instance.currentUser!.uid,
                                    "image_url": noUser,
                                    "email": _emailController.text.trim(),
                                    "password": _passwordController.text.trim(),
                                    "phone_number": _phoneController.text.trim(),
                                    "status": false,
                                    "date_of_birth": DateTime(1970),
                                    "about": "",
                                    "service": "",
                                    "grade": "",
                                    "token": "",
                                  });
                                });
                              } else {
                                showToast(text: 'verifyfieldsplease'.tr);
                              }
                            } catch (_) {
                              showToast(text: _.toString());
                            }
                          },
                          child: AnimatedContainer(
                            duration: 500.ms,
                            height: 40,
                            width: MediaQuery.of(context).size.width * .6,
                            decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5)),
                            child: const Padding(padding: EdgeInsets.all(8.0), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Spacer(), CustomizedText(text: "ADD", color: black, fontWeight: FontWeight.bold, fontSize: 20), Spacer(), Icon(FontAwesomeIcons.chevronRight, size: 15, color: black)])),
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
      ),
    );
  }
}
