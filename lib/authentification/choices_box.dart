import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_care/authentification/sign_in.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/screens.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';

class ChoicesBox extends StatelessWidget {
  const ChoicesBox({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          final List<dynamic> roles = snapshot.data!.get("roles_list");
          if (roles.length == 1) {
            return const Screens();
          } else {
            final List<bool> rolesList = List.generate(roles.length, (int index) => false);
            bool ignore = false;
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
                    child: StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) setS) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CustomizedText(text: 'continueAs'.tr, fontSize: 25, color: blue, fontWeight: FontWeight.bold),
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
                                    //lahne bch na3ml mise à jour bch yben lil user eli houwa checka role ml roles
                                    setS(() {
                                      rolesList[role] = value!;
                                      ignore = true;
                                    });
                                    //na fl firestore 3andi list des roles w 3andi current_role lina maw el user 5tar role bch n7ot el current role lil role eli 5tarou
                                    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({"role": roles[role]}).then(
                                      (void value) async {
                                        //ba3ed net3ada lil screens mte3i
                                        await Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Screens()));
                                      },
                                    );
                                  },
                                ),
                              ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const SignIn())),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5)),
                                child: const Icon(FontAwesomeIcons.chevronLeft, color: white, size: 25),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          //fi 7alet future mizel makmelch n7otou loading indicator
          return const Center(child: CircularProgressIndicator(color: blue));
        } else {
          //fi 7alet sar error naffichouh fi page wa7dou
          return ErrorRoom(error: snapshot.error.toString());
        }
      },
    );
  }
}
