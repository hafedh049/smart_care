import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/screens.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';

class ChoicesBox extends StatelessWidget {
  const ChoicesBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width,
            height: 300,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: grey.withOpacity(.2)),
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance.collection("health_care_professionals").doc(FirebaseAuth.instance.currentUser!.uid).get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  final List<dynamic> roles = snapshot.data!.get("roles_list");
                  if (roles.length == 1) {
                    return const Screens(firstScreen: 0);
                  }
                  final List<bool> rolesList = List.generate(roles.length, (int index) => false);
                  bool ignore = false;
                  return StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) setS) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CustomizedText(text: "Continue As", fontSize: 25, color: blue, fontWeight: FontWeight.bold),
                          const SizedBox(height: 10),
                          for (int role = 0; role < roles.length; role++)
                            IgnorePointer(
                              ignoring: ignore,
                              child: CheckboxListTile(
                                checkColor: darkBlue,
                                checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                title: CustomizedText(text: roles[role][0].toUpperCase() + roles[role].substring(1), fontSize: 16, color: white),
                                value: rolesList[role],
                                onChanged: (bool? value) async {
                                  setS(() {
                                    rolesList[role] = value!;
                                    ignore = true;
                                  });
                                  await FirebaseFirestore.instance.collection("health_care_professionals").doc(FirebaseAuth.instance.currentUser!.uid).update({"role": roles[role]}).then(
                                    (void value) async => await Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Screens(firstScreen: 0))),
                                  );
                                },
                              ),
                            ),
                        ],
                      );
                    },
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: blue));
                } else {
                  return ErrorRoom(error: snapshot.error.toString());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
