import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_care/models/user_model.dart';

class BiologistModel extends UserModel {
  final String uid;

  BiologistModel({required String phoneNumber, required String role, required String username, required String email, required String password, required this.uid}) : super(phoneNumber: phoneNumber, role: role, username: username, email: email, password: password);

  Future<void> uploadBloodTest() async {
    try {
      await FirebaseFirestore.instance.collection('blood_tests').doc(uid).set({});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> notifyPatient(String patientID, String doctorID) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').doc(patientID).set({'biologistID': uid, 'doctorID': doctorID});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> notifyDoctor(String patientID, String doctorID) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').doc(doctorID).set({'biologistID': uid, 'patientID': patientID});
    } catch (e) {
      rethrow;
    }
  }
}
