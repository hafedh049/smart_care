import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_care/authentification/recovery.dart';
import 'package:smart_care/views/authentification/sign_up_view.dart';
import 'package:smart_care/screens/screens.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';
import '../stuff/functions.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool wait = false;

  @override
  void dispose() {
    _emailController.dispose();
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
                const Row(children: <Widget>[Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), SizedBox(width: 50)]),
                Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue.withOpacity(.5)), const SizedBox(width: 30)]),
                const SizedBox(height: 20),
                CustomizedText(text: 'welcome'.tr, fontWeight: FontWeight.bold, color: blue).animate().fadeIn(duration: 500.ms),
                CustomizedText(text: 'signInnow'.tr, fontWeight: FontWeight.bold, fontSize: 35).animate().fadeIn(duration: 500.ms),
                CustomizedText(text: 'welcomebackpleasefilltheformtosigninandcontinue'.tr, fontSize: 16).animate().fadeIn(duration: 500.ms),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    const Spacer(),
                    GestureDetector(onTap: () async => await goTo(const Recovery()), child: Container(height: 35, width: 150, decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5)), child: Padding(padding: const EdgeInsets.all(8.0), child: Center(child: CustomizedText(text: 'recoverAccount'.tr, fontSize: 16, color: black, fontWeight: FontWeight.bold))))),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextField(validator: fieldsValidator["email"], controller: _emailController, hint: 'email'.tr, prefix: FontAwesomeIcons.envelope, type: TextInputType.emailAddress),
                const SizedBox(height: 10),
                CustomTextField(validator: fieldsValidator["password"], controller: _passwordController, hint: 'password'.tr, obscured: true, prefix: FontAwesomeIcons.lock),
                const SizedBox(height: 20),
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
                                await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim()).then((UserCredential value) async {
                                  await getToken();
                                  await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({"status": true, "token": userToken}).then((void value) async {
                                    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const Screens()), (Route route) => false);
                                  });
                                });
                              } else {
                                showToast(text: 'verifyfieldsplease'.tr);
                              }
                            } catch (_) {
                              setS(() => wait = false);
                              showToast(text: _.toString(), color: red);
                            }
                          },
                          child: AnimatedContainer(
                            duration: 500.ms,
                            height: 40,
                            width: wait ? MediaQuery.of(context).size.width * .37 : MediaQuery.of(context).size.width * .6,
                            decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Visibility(visible: !wait, child: const Spacer()),
                                  CustomizedText(text: wait ? 'connecting___'.tr : 'signIn'.tr, fontWeight: FontWeight.bold, fontSize: 20, color: black),
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
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () async => await goTo(const SignUp()),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .6,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(color: transparent, borderRadius: BorderRadius.circular(5), border: Border.all(color: blue)),
                      child: Center(child: CustomizedText(text: 'createAccount'.tr, fontWeight: FontWeight.bold, fontSize: 20, color: blue)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Or(),
                const SizedBox(height: 30),
                const GoogleAuth(),
                const SizedBox(height: 10),
                const OTPAuth(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
