import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:smart_care/authentification/pwd_strength.dart';

import '../../utils/classes.dart';
import '../../utils/callbacks.dart';
import '../../utils/globals.dart';

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
  final List<bool> _rolesList = <bool>[false, false, false];

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
        body: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
                  const Row(children: <Widget>[Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), SizedBox(width: 50)]),
                  const Row(children: <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
                  const SizedBox(height: 20),
                  const Padding(padding: EdgeInsets.only(right: 8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[CustomizedText(text: "ADD", color: blue, fontWeight: FontWeight.bold), CustomizedText(text: "USER", fontWeight: FontWeight.bold)])),
                  const SizedBox(height: 30),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[CustomizedText(text: 'whatisyourname'.tr, fontSize: 18), const SizedBox(height: 10), CustomTextField(controller: _usernameController, hint: 'name'.tr, prefix: FontAwesomeIcons.userDoctor, type: TextInputType.name)],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[CustomizedText(text: 'canyouprovidemewithyouremployeeIDormatricule'.tr, fontSize: 18), const SizedBox(height: 10), CustomTextField(controller: _idController, hint: 'iD'.tr, prefix: FontAwesomeIcons.userSecret)],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[CustomizedText(text: 'wouldyoumindsharingyouremailaddresswithme'.tr, fontSize: 18), const SizedBox(height: 10), CustomTextField(controller: _emailController, hint: 'email'.tr, prefix: FontAwesomeIcons.envelope, type: TextInputType.emailAddress)],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomizedText(text: 'youwillneedtosetupapasswordforyouraccount'.tr, fontSize: 18),
                      const SizedBox(height: 10),
                      CustomTextField(func: (String text) => _passwordStrenghtKey.currentState!.setState(() {}), controller: _passwordController, hint: 'password'.tr, prefix: FontAwesomeIcons.lock, obscured: true),
                      const SizedBox(height: 10),
                      Padding(padding: const EdgeInsets.only(right: 8), child: StatefulBuilder(key: _passwordStrenghtKey, builder: (BuildContext context, void Function(void Function()) _) => PasswordStrength(password: _passwordController.text.trim()))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomizedText(text: 'mayIhaveyourphonenumberplease'.tr, fontSize: 18),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
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
                          CustomizedText(text: 'pleaseselectyourrolefromthefollowingoptions'.tr, fontSize: 18),
                          const SizedBox(height: 20),
                          CheckboxListTile(activeColor: blue, value: _rolesList[0], title: CustomizedText(text: 'doctor'.tr, fontSize: 16), onChanged: (bool? value) => setState(() => _rolesList[0] = (_rolesList[0]) ? false : true)),
                          const SizedBox(height: 10),
                          CheckboxListTile(activeColor: blue, value: _rolesList[1], title: CustomizedText(text: 'patient'.tr, fontSize: 16), onChanged: (bool? value) => setState(() => _rolesList[1] = (_rolesList[1]) ? false : true)),
                          const SizedBox(height: 10),
                          CheckboxListTile(activeColor: blue, value: _rolesList[2], title: CustomizedText(text: 'Laboratory'.tr, fontSize: 16), onChanged: (bool? value) => setState(() => _rolesList[2] = (_rolesList[2]) ? false : true)),
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
                                    "hospital": "",
                                    "password": _passwordController.text.trim(),
                                    "phone_number": _phoneController.text.trim(),
                                    "status": false,
                                    "date_of_birth": DateTime(1970),
                                    "about": "",
                                    "service": "Expert métier",
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
                            child: const Padding(padding: EdgeInsets.all(8), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Spacer(), CustomizedText(text: "ADD", color: black, fontWeight: FontWeight.bold, fontSize: 20), Spacer(), Icon(FontAwesomeIcons.chevronRight, size: 15, color: black)])),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
