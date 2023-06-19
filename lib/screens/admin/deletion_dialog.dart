import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';

class Delete extends StatelessWidget {
  const Delete({super.key, required this.userData});
  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(margin: const EdgeInsets.all(8), padding: const EdgeInsets.all(8), decoration: BoxDecoration(border: Border.all(color: Colors.blue, width: 1), borderRadius: BorderRadius.circular(5)), child: CustomizedText(text: userData["name"], fontSize: 16)),
              Container(margin: const EdgeInsets.all(8), padding: const EdgeInsets.all(8), decoration: BoxDecoration(border: Border.all(color: Colors.blue, width: 1), borderRadius: BorderRadius.circular(5)), child: CustomizedText(text: userData["email"], fontSize: 16)),
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(border: Border.all(color: Colors.blue, width: 1), borderRadius: BorderRadius.circular(5)),
                child: CustomizedText(text: userData["uid"], fontSize: 16),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(border: Border.all(color: Colors.blue, width: 1), borderRadius: BorderRadius.circular(5)),
                child: CustomizedText(text: userData["id"], fontSize: 16),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(border: Border.all(color: Colors.blue, width: 1), borderRadius: BorderRadius.circular(5)),
                child: CustomizedText(text: userData["grade"], fontSize: 16),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showConfirmationDialog(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const CustomizedText(text: 'Delete', fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomizedText(text: 'Confirm'.tr, fontSize: 16),
          content: CustomizedText(text: 'Are you sure?'.tr, fontSize: 16),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.of(context).pop(), child: CustomizedText(text: 'Cancel'.tr, fontSize: 16)),
            ElevatedButton(
              onPressed: () async {
                showToast(text: "Wait".tr);
                /*await FirebaseFirestore.instance.collection("users").doc(userData['uid']).delete();
                await FirebaseStorage.instance.ref().child("/profile_pictures/${userData['uid']}").delete();
                await FirebaseStorage.instance.ref().child("/prescriptions/${userData['uid']}/").delete();
                await FirebaseStorage.instance.ref().child("/blood_tests/${userData['uid']}/").delete();

                final QuerySnapshot<Map<String, dynamic>> filledFormsSnapshot = await FirebaseFirestore.instance.collection('filled_forms').where('uid', isEqualTo: userData["uid"]).get();

                final QuerySnapshot<Map<String, dynamic>> bloodTestsSnapshot = await FirebaseFirestore.instance.collection('blood_tests').where('uid', isEqualTo: userData["uid"]).get();

                final QuerySnapshot<Map<String, dynamic>> doctorPrenscriptionsSnapshot = await FirebaseFirestore.instance.collection('prescriptions').where(userData["role"] == 'doctor' ? 'doctorID' : 'uid', isEqualTo: userData["role"] == 'doctor' ? userData["doctorID"] : userData["uid"]).get();

                final QuerySnapshot<Map<String, dynamic>> doctorAppointmentSnapshot = await FirebaseFirestore.instance.collection('appointments').where(userData["role"] == 'doctor' ? 'doctorID' : 'patientID', isEqualTo: userData["role"] == 'doctor' ? userData["doctorID"] : userData["patientID"]).get();

                final List<Future<void>> deleteFutures = <Future<void>>[];
                for (QueryDocumentSnapshot<Map<String, dynamic>> doc in [...bloodTestsSnapshot.docs, ...doctorPrenscriptionsSnapshot.docs, ...doctorAppointmentSnapshot.docs, ...filledFormsSnapshot.docs]) {
                  deleteFutures.add(doc.reference.delete());
                }
                await Future.wait(deleteFutures);*/
                final http.Response response = await http.post(
                  Uri.parse("http://192.168.1.13:80/delete_user"),
                  headers: const <String, String>{'Content-Type': 'application/json'},
                  body: json.encode(<String, dynamic>{"id": me["uid"]}),
                );
                if (response.statusCode == 200) {
                  final Map<String, dynamic> data = json.decode(response.body);
                  showToast(text: data.toString());
                  debugPrint(data.toString());
                } else {
                  showToast(text: 'Request failed with status: ${response.statusCode}');
                  debugPrint('Request failed with status: ${response.statusCode}');
                }

                showToast(text: "User Deleted".tr);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: CustomizedText(text: 'Confirm'.tr, fontSize: 16),
            ),
          ],
        );
      },
    );
  }
}
