import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_care/drawer/account.dart';
import 'package:smart_care/drawer/help_and_faq.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/utils/globals.dart';

import '../utils/classes.dart';
import '../utils/callbacks.dart';

class SmartSettings extends StatelessWidget {
  const SmartSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronLeft, size: 15, color: grey))),
            const SizedBox(height: 10),
            CustomizedText(text: 'settings'.tr, fontSize: 40, fontWeight: FontWeight.bold),
            const SizedBox(height: 60),
            CustomizedText(text: 'account'.tr, fontSize: 20, fontWeight: FontWeight.bold),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () async => await goTo(const Account()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(radius: 25, backgroundColor: grey.withOpacity(.2), child: const Icon(FontAwesomeIcons.user, color: grey, size: 15)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                          if (snapshot.hasData) {
                            return CustomizedText(text: snapshot.data!.get("name"), fontSize: 18);
                          } else if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(width: 120, height: 9, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: grey)).animate(onComplete: (AnimationController controller) => controller.repeat(period: const Duration(seconds: 2))).shimmer(color: grey, colors: <Color>[white, grey]);
                          } else {
                            return ErrorRoom(error: snapshot.error.toString());
                          }
                        },
                      ),
                      CustomizedText(text: 'personalInfo'.tr, fontSize: 12, color: grey.withOpacity(.6)),
                    ],
                  ),
                  Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: grey)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            CustomizedText(text: 'settings'.tr, fontSize: 20, fontWeight: FontWeight.bold),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleAvatar(radius: 25, backgroundColor: Colors.blue.shade900.withOpacity(.2), child: Icon(FontAwesomeIcons.language, color: Colors.blue.shade900, size: 15)),
                CustomizedText(text: 'language'.tr, fontSize: 18),
                CustomizedText(text: 'english'.tr, fontSize: 12, color: grey.withOpacity(.6)),
                Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: grey)),
              ],
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {},
              child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CircleAvatar(radius: 25, backgroundColor: Colors.orange.withOpacity(.2), child: const Icon(FontAwesomeIcons.bell, color: Colors.orange, size: 15)),
                      CustomizedText(text: 'sounds'.tr, fontSize: 18),
                      CustomizedText(text: 'disabled'.tr, fontSize: 12, color: grey.withOpacity(.6)),
                      Switch(
                        activeThumbImage: const AssetImage("assets/icon/play.png"),
                        inactiveThumbImage: const AssetImage("assets/icon/mute.png"),
                        value: false,
                        onChanged: (bool value) async {},
                        activeTrackColor: blue,
                        activeColor: white,
                        inactiveTrackColor: grey,
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CircleAvatar(radius: 25, backgroundColor: blue.withOpacity(.2), child: const Icon(FontAwesomeIcons.moon, color: blue, size: 15)),
                    CustomizedText(text: 'darkMode'.tr, fontSize: 18),
                    CustomizedText(text: userData!.get("dark_theme") ? 'on'.tr : 'off'.tr, fontSize: 12, color: grey.withOpacity(.6)),
                    Switch(
                      activeThumbImage: const AssetImage("assets/icon/moon.png"),
                      inactiveThumbImage: const AssetImage("assets/icon/sun.png"),
                      value: userData!.get("dark_theme"),
                      onChanged: (bool value) async {
                        userData!.put("dark_theme", value);
                        _(() => value ? AdaptiveTheme.of(context).setDark() : AdaptiveTheme.of(context).setLight());
                      },
                      activeTrackColor: blue,
                      activeColor: white,
                      inactiveTrackColor: grey,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () async => await goTo(const HelpAndFAQ()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(radius: 25, backgroundColor: Colors.pink.withOpacity(.2), child: const Icon(FontAwesomeIcons.earthAfrica, color: Colors.pink, size: 15)),
                  CustomizedText(text: "${'help'.tr} & FAQ", fontSize: 18),
                  Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: grey)),
                  const CustomizedText(text: "\t", fontSize: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
