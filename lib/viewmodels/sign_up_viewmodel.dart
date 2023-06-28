import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:smart_care/models/user_model.dart' show UserModel;

class SignUpViewModel extends GetxController {
  final UserModel _user = UserModel(email: '', phoneNumber: '', password: '', role: '', username: '');

  String email = '';
  String phone = '';
  String username = '';
  String password = '';

  void getData() {
    email = _user.email;
    phone = _user.phoneNumber;
    username = _user.username;
    password = _user.password;
  }

  bool verify() {
    if (email.isEmpty || phone.isEmpty || username.isEmpty || password.isEmpty) {
      showError('Please fill in all fields.');
      return false;
    }
    return true;
  }

  void createUser() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      showMessage();
      saveUserData();
    } catch (error) {
      showError('Failed to create user. Please try again.');
    }
  }

  void showError(String message) {
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red, textColor: Colors.white);
  }

  void showMessage() {
    Fluttertoast.showToast(msg: "Operation Terminated Successfully.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.green, textColor: Colors.white);
  }

  void setState() {
    update();
  }

  void saveUserData() async {
    try {
      final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
      final DocumentReference userDocRef = usersCollection.doc(email);
      final Map<String, dynamic> userData = {
        'email': email,
        'phone': phone,
        'username': username,
      };
      await userDocRef.set(userData);
      showMessage();
    } catch (error) {
      showError('Failed to save user data. Please try again.');
    }
  }
}
