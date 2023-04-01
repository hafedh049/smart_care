import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/drawer/account.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/stuff/globals.dart';

import '../stuff/classes.dart';

class SmartSettings extends StatelessWidget {
  const SmartSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: darkBlue,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                child: const Icon(FontAwesomeIcons.chevronLeft, size: 15, color: grey),
              ),
            ),
            const SizedBox(height: 10),
            const CustomizedText(text: "Settings", fontSize: 40, fontWeight: FontWeight.bold, color: white),
            const SizedBox(height: 60),
            const CustomizedText(text: "Account", fontSize: 20, fontWeight: FontWeight.bold, color: white),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Account()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: grey.withOpacity(.2),
                    child: const Icon(FontAwesomeIcons.user, color: grey, size: 15),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                          if (snapshot.hasData) {
                            return CustomizedText(text: snapshot.data!.get("name"), fontSize: 18, color: white);
                          } else if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(width: 120, height: 9, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white)).animate(onComplete: (AnimationController controller) => controller.repeat(period: 2.seconds)).shimmer(color: grey, colors: <Color>[white, grey]);
                          } else {
                            return ErrorRoom(error: snapshot.error.toString());
                          }
                        },
                      ),
                      CustomizedText(text: "Personal Info", fontSize: 12, color: white.withOpacity(.6)),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                    child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const CustomizedText(text: "Settings", fontSize: 20, fontWeight: FontWeight.bold, color: white),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blue.shade900.withOpacity(.2),
                  child: Icon(FontAwesomeIcons.user, color: Colors.blue.shade900, size: 15),
                ),
                const CustomizedText(text: "Language", fontSize: 18, color: white),
                CustomizedText(text: "English", fontSize: 12, color: white.withOpacity(.6)),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                  child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: grey),
                ),
              ],
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                {
                  ;
                }
              },
              child: StatefulBuilder(builder: (BuildContext context, void Function(void Function()) _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.orange.withOpacity(.2),
                      child: const Icon(FontAwesomeIcons.bell, color: Colors.orange, size: 15),
                    ),
                    const CustomizedText(text: "Sounds", fontSize: 18, color: white),
                    CustomizedText(text: play == 1 ? "Enabled" : "Disabled", fontSize: 12, color: white.withOpacity(.6)),
                    Switch(
                      activeThumbImage: const AssetImage("assets/play.png"),
                      inactiveThumbImage: const AssetImage("assets/mute.png"),
                      value: play == 1 ? true : false,
                      onChanged: (bool value) async {
                        if (value) {
                          await db!.execute("UPDATE SMART_CARE SET AUDIO = 1;");
                        } else {
                          await db!.execute("UPDATE SMART_CARE SET AUDIO = 0;");
                        }
                        _(() => play = value ? 1 : 0);
                      },
                      activeTrackColor: blue,
                      activeColor: white,
                      inactiveTrackColor: grey,
                    )
                  ],
                );
              }),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                {
                  ;
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: blue.withOpacity(.2),
                    child: const Icon(FontAwesomeIcons.moon, color: blue, size: 15),
                  ),
                  const CustomizedText(text: "Dark Mode", fontSize: 18, color: white),
                  CustomizedText(text: "On", fontSize: 12, color: white.withOpacity(.6)),
                  Switch(
                    activeThumbImage: const AssetImage("assets/moon.png"),
                    inactiveThumbImage: const AssetImage("assets/sun.png"),
                    value: darkTheme == 1 ? true : false,
                    onChanged: (bool value) => darkTheme = value ? 1 : 0,
                    activeTrackColor: blue,
                    activeColor: white,
                    inactiveTrackColor: grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                {
                  ;
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.pink.withOpacity(.2),
                    child: const Icon(FontAwesomeIcons.earthAfrica, color: Colors.pink, size: 15),
                  ),
                  const CustomizedText(text: "Help", fontSize: 18, color: white),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                    child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
