import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_care/models/user_model.dart';

class DoctorModel extends UserModel {
  final String uid;

  DoctorModel({required this.uid, String? phoneNumber, String? role, String? username, String? email, String? password}) : super(phoneNumber: phoneNumber!, role: role!, username: username!, email: email!, password: password!);

  Future<void> modifyPrescription() async {
    try {
      await FirebaseFirestore.instance.collection('prescriptions').doc(FirebaseAuth.instance.currentUser!.uid).update({});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadPrescription() async {
    try {
      await FirebaseFirestore.instance.collection('prescriptions').doc(FirebaseAuth.instance.currentUser!.uid).set({});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> viewBloodTest() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> bloodTestSnapshot = await FirebaseFirestore.instance.collection('blood_tests').doc(FirebaseAuth.instance.currentUser!.uid).get();
      Map<String, dynamic>? bloodTestData = bloodTestSnapshot.data();
    } catch (e) {
      rethrow;
    }
  }
}
