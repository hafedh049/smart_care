import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_care/models/user_model.dart';

class PatientModel extends UserModel {
  final String uid;
  PatientModel({required this.uid, required String phoneNumber, required String role, required String username, required String email, required String password}) : super(phoneNumber: phoneNumber, role: role, username: username, email: email, password: password);

  Future<void> downloadPrescription() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> prescriptionSnapshot = await FirebaseFirestore.instance.collection('prescriptions').doc(FirebaseAuth.instance.currentUser!.uid).get();
      Map<String, dynamic>? prescriptionData = prescriptionSnapshot.data();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fillForm() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> patientSnapshot = await FirebaseFirestore.instance.collection('patients').doc(FirebaseAuth.instance.currentUser!.uid).get();
      Map<String, dynamic>? patientData = patientSnapshot.data();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> askForAppointment() async {
    try {
      await FirebaseFirestore.instance.collection('appointments').add({'patientId': FirebaseAuth.instance.currentUser!.uid});
    } catch (e) {
      rethrow;
    }
  }
}
