import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_care/models/user_model.dart';
import 'package:smart_care/otp/opt_phase_2.dart';

class SignInViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  String otp = List.generate(6, (index) => Random().nextInt(10).toString()).join();

  UserModel user = UserModel(phoneNumber: "", role: "", username: "", email: "", password: "");

  void signInEmPass(String email, String password) async {
    try {
      setLoading(true);
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      showError(e.toString());
      print('Sign-in error: $e');
    } finally {
      setLoading(false);
    }
  }

  void signInWithGoogle() async {
    try {
      setLoading(true);
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      OAuthCredential googleCredential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential userCredential = await _auth.signInWithCredential(googleCredential);
    } catch (e) {
      showError(e.toString());
      print('Google sign-in error: $e');
    } finally {
      setLoading(false);
    }
  }

  void signInWithPhone(String phoneNumber) async {
    try {
      setLoading(true);
      ConfirmationResult confirmationResult = await _auth.signInWithPhoneNumber(phoneNumber);
      String verificationId = confirmationResult.verificationId;
      String otp = "115478";
      AuthCredential phoneCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
      UserCredential userCredential = await _auth.signInWithCredential(phoneCredential);
    } catch (e) {
      showError(e.toString());
      print('Phone sign-in error: $e');
    } finally {
      setLoading(false);
    }
  }

  bool verifyOTP(String userOTP) {
    return userOTP == otp;
  }

  void showError(String errorMessage) {
    Get.snackbar('Error', errorMessage, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
  }

  void setLoading(bool value) {
    _isLoading.value = value;
  }

  void goTo(Widget screen) {
    Get.to(screen);
  }

  void updateData(UserCredential userCredential) {
    String userId = userCredential.user!.uid;
    FirebaseFirestore.instance.collection('users').doc(userId).set(user.toJson());
  }

  Map<String, dynamic> getData() {
    return {'email': user.email, 'password': user.password};
  }

  bool validate() {
    bool isEmailValid = GetUtils.isEmail(user.email);
    bool isPasswordValid = GetUtils.isLengthGreaterOrEqual(user.password, 6);

    return isEmailValid && isPasswordValid;
  }

  Future<void> verifyPhone(String phoneNumber) async {
    try {
      setLoading(true);
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
          updateData(userCredential);
        },
        verificationFailed: (FirebaseAuthException e) {
          showError(e.message!);
        },
        codeSent: (String verificationId, int? resendToken) {
          goTo(OTP(verification: verificationId, email: user.email));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          goTo(OTP(verification: verificationId, email: user.email));
        },
      );
    } catch (error) {
      showError(error.toString());
    } finally {
      setLoading(false);
    }
  }

  void setState() {}
}
