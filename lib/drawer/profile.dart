import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_care/drawer/admin_profile.dart';
import 'package:smart_care/drawer/doctor_profile.dart';
import 'package:smart_care/drawer/laboratory_profile.dart';
import 'package:smart_care/drawer/patient_profile.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/stuff/globals.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.get("role") == "doctor") {
              return const DoctorProfile();
            } else if (snapshot.data!.get("role") == "patient") {
              return const PatientProfile();
            } else if (snapshot.data!.get("role") == "admin") {
              return const AdminProfile();
            } else {
              return const LaboratoryProfile();
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(color: blue);
          } else {
            return ErrorRoom(error: snapshot.error.toString());
          }
        },
      ),
    );
  }
}
