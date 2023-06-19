import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_care/models/user_model.dart';

import '../screens/screens.dart';
import '../stuff/functions.dart';
import '../stuff/globals.dart';

class SignUpViewModel extends GetxController {
  final Rx<UserModel> _model = UserModel().obs;
  UserModel get model => _model.value;
  set model(UserModel value) => _model.value = value;

  String get name => _model.value.name;
  set name(String value) {
    _model.update((UserModel? val) {
      val!.name = value;
    });
  }

  String get id => _model.value.id;
  set id(String value) {
    _model.update((UserModel? val) {
      val!.id = value;
    });
  }

  String get role => _model.value.role;
  set role(String value) {
    _model.update((UserModel? val) {
      val!.role = value;
    });
  }

  String get uid => _model.value.uid;
  set uid(String value) {
    _model.update((UserModel? val) {
      val!.uid = value;
    });
  }

  String get imageUrl => _model.value.imageUrl;
  set imageUrl(String value) {
    _model.update((UserModel? val) {
      val!.imageUrl = value;
    });
  }

  String get email => _model.value.email;
  set email(String value) {
    _model.update((UserModel? val) {
      val!.email = value;
    });
  }

  String get password => _model.value.password;
  set password(String value) {
    _model.update((UserModel? val) {
      val!.password = value;
    });
  }

  String get phoneNumber => _model.value.phoneNumber;
  set phoneNumber(String value) {
    _model.update((UserModel? val) {
      val!.phoneNumber = value;
    });
  }

  bool get status => _model.value.status;
  set status(bool value) {
    _model.update((UserModel? val) {
      val!.status = value;
    });
  }

  DateTime get dateOfBirth => _model.value.dateOfBirth;
  set dateOfBirth(DateTime value) {
    _model.update((UserModel? val) {
      val!.dateOfBirth = value;
    });
  }

  String get about => _model.value.about;
  set about(String value) {
    _model.update((UserModel? val) {
      val!.about = value;
    });
  }

  String get grade => _model.value.grade;
  set grade(String value) {
    _model.update((UserModel? val) {
      val!.grade = value;
    });
  }

  String get service => _model.value.service;
  set service(String value) {
    _model.update((UserModel? val) {
      val!.service = value;
    });
  }

  String get token => _model.value.token;
  set token(String value) {
    _model.update((UserModel? val) {
      val!.token = value;
    });
  }

  String get hospital => _model.value.hospital;
  set hospital(String value) {
    _model.update((UserModel? val) {
      val!.hospital = value;
    });
  }

  void create(BuildContext context, File? profilePicture, void Function() func) async {
    try {
      bool phoneExists = false;
      await FirebaseFirestore.instance.collection("users").where("phone_number", isEqualTo: phoneNumber).count().get().then((AggregateQuerySnapshot value) => phoneExists = value.count == 0 ? false : true);
      if (phoneExists) {
        showToast(text: "This phone number already exists".tr);
      } else {
        print(model.toJson());
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((UserCredential userCredential) async {
          showToast(text: 'accountCreated'.tr);
          if (profilePicture != null) {
            await FirebaseStorage.instance.ref().child("profile_pictures/${userCredential.user!.uid}").putFile(profilePicture).then((TaskSnapshot task) async {
              imageUrl = await task.ref.getDownloadURL();
            });
            showToast(text: 'pictureUploaded'.tr);
          }
          uid = FirebaseAuth.instance.currentUser!.uid;
          await FirebaseFirestore.instance.collection("users").doc(uid).set(model.toJson()).then((void value) async {
            showToast(text: 'dataStored'.tr);
            await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((UserCredential value) async {
              showToast(text: 'signedInUsingEmailPassword'.tr);
              await getToken();
              role = "patient";
              token = userToken;
              await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({"token": userToken}).then((void value) async {
                await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const Screens()), (Route route) => false);
              });
            });
          });
        });
      }
    } catch (_) {
      func();
      showToast(text: _.toString());
    }
  }
}
