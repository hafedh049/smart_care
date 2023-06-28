import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:smart_care/models/virus_enum.dart';
import 'package:smart_care/stuff/functions.dart';

import '../models/blood_test.dart';

class BloodTestViewModel extends GetxController {
  BloodTest? bloodTest;

  void getData() {
    bloodTest = BloodTest(patientId: "", timestamp: "", virusType: VIRUS.HIV);
  }

  bool verify() {
    if (bloodTest == null) {
      showError('Blood test data is missing.');
      return false;
    }
    if (bloodTest!.patientId.isEmpty) {
      showError('Patient ID is required.');
      return false;
    }
    if (bloodTest!.virusType == null) {
      showError('Virus type is required.');
      return false;
    }

    return true;
  }

  void showError(String msg) {
    showToast(text: msg);
  }

  void sendNotification(idP, idD) {
    sendPushNotificationFCM(token: idP.get("token"), username: idP.get("username"), message: "Blood test uploaded".tr);
    sendPushNotificationFCM(token: idD.get("token"), username: idD.get("username"), message: "Blood test uploaded".tr);
  }

  Future<void> storeBloodTest() async {
    if (verify()) {
      try {
        await FirebaseFirestore.instance.collection("blood_tests").add(bloodTest!.toJson());

        String filePath = 'blood_test/${bloodTest!.patientId}_${bloodTest!.timestamp}.pdf';
        await FirebaseStorage.instance.ref().child(filePath).putBlob(bloodTest!.toJson());

        // Show success message
        showMessage();
      } catch (e) {
        showError('Error occurred while storing blood test.');
        print(e);
      }
    }
  }

  void showMessage() {
    showToast(text: 'Blood test successfully stored.');
  }
}
