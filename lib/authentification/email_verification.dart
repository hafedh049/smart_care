// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:smart_care/screens/screens.dart';

import '../utils/callbacks.dart';
import '../utils/classes.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});
  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? _timer;
  Future<void> sendVerificationEmail() async {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    showToast(text: "Link has been sent".tr);
  }

  Future<void> redirectTo() async {
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (Timer timer) async {
        await FirebaseAuth.instance.currentUser!.reload();
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          showToast(text: "E-mail verified successfully.");
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const Screens()), (Route route) => false);
        }
      },
    );
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    sendVerificationEmail();
    redirectTo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomizedText(text: 'An email verification link has been sent to:'.tr, fontSize: 18),
            const SizedBox(height: 10),
            CustomizedText(text: FirebaseAuth.instance.currentUser!.email!, fontSize: 18, fontWeight: FontWeight.bold),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: sendVerificationEmail, child: CustomizedText(text: 'Resend Verification Email'.tr, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
