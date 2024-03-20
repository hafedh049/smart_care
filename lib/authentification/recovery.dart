import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_care/authentification/sign_in.dart';
import 'package:smart_care/utils/classes.dart';
import 'package:smart_care/utils/globals.dart';
import 'package:lottie/lottie.dart';

import '../utils/callbacks.dart';

class Recovery extends StatefulWidget {
  const Recovery({super.key});

  @override
  State<Recovery> createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _phoneNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool wait = false;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneNode.dispose();
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
                LottieBuilder.asset("assets/lottie/recover.json"),
                CustomizedText(text: 'account'.tr, color: blue, fontWeight: FontWeight.bold),
                CustomizedText(text: 'recovery'.tr, fontWeight: FontWeight.bold),
                CustomizedText(text: 'aftercontinuingyouwillrecieveamailthatcontainsalinktorecoveryouraccountintheinbox'.tr, fontSize: 16).animate().fadeIn(duration: 500.ms),
                const SizedBox(height: 10),
                CustomTextField(controller: _emailController, hint: "E-mail", prefix: FontAwesomeIcons.envelope, type: TextInputType.emailAddress),
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
                                setS(() => wait = false);
                                await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim()).then((void value) {
                                  showToast(text: "Password reset email sent to ${_emailController.text.trim()} (If not found check the SPAM section)");
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const SignIn()), (Route route) => false);
                                });
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
                            child: Padding(padding: const EdgeInsets.all(8.0), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Visibility(visible: !wait, child: const Spacer()), CustomizedText(text: wait ? 'done'.tr : 'sendEmail'.tr, color: black, fontWeight: FontWeight.bold, fontSize: 18), Visibility(visible: !wait, child: const Spacer()), Visibility(visible: !wait, child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: black))])),
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
  }
}
