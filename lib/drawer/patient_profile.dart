import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/patient/historic.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';

import '../stuff/functions.dart';

class PatientProfile extends StatelessWidget {
  const PatientProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: darkBlue,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 40),
                  Row(children: <Widget>[const SizedBox(width: 10), CustomIcon(func: () => Navigator.pop(context), icon: FontAwesomeIcons.chevronLeft)]),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: snapshot.data!.get("image_url") == noUser
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                contentPadding: EdgeInsets.zero,
                                content: Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                  child: InteractiveViewer(
                                      child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.get("image_url"),
                                    placeholder: (BuildContext context, String url) => const Center(child: Icon(FontAwesomeIcons.user, color: grey, size: 80)),
                                  )),
                                ),
                              ),
                            );
                          },
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: grey.withOpacity(.3),
                        radius: 65,
                        backgroundImage: snapshot.data!.get("image_url") == noUser ? null : CachedNetworkImageProvider(snapshot.data!.get("image_url")),
                        child: snapshot.data!.get("image_url") == noUser ? const Icon(FontAwesomeIcons.user, color: grey, size: 80) : null,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomizedText(text: snapshot.data!.get("name"), fontSize: 16, fontWeight: FontWeight.bold, color: white),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              const Icon(FontAwesomeIcons.tooth, size: 15, color: blue),
                              const SizedBox(width: 10),
                              Flexible(child: CustomizedText(text: snapshot.data!.get("speciality"), fontSize: 16, color: white.withOpacity(.8))),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              const Icon(Icons.numbers, size: 18, color: blue),
                              const SizedBox(width: 10),
                              CustomizedText(text: "Age ( ${DateTime.now().difference(snapshot.data!.get('date_of_birth').toDate()).inDays ~/ 365} )", fontSize: 16, color: white.withOpacity(.8)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              const Icon(FontAwesomeIcons.locationPinLock, size: 15, color: blue),
                              const SizedBox(width: 10),
                              CustomizedText(text: 'Location ( ${snapshot.data!.get("location").isEmpty ? "Monastir, Tunisia" : snapshot.data!.get("location")} )', fontSize: 16, color: white.withOpacity(.8)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              const Icon(FontAwesomeIcons.envelope, size: 15, color: blue),
                              const SizedBox(width: 10),
                              CustomizedText(text: 'E-mail ( ${snapshot.data!.get("email")} )', fontSize: 16, color: white.withOpacity(.8)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              const Icon(Icons.phone, size: 14, color: blue),
                              const SizedBox(width: 10),
                              CustomizedText(text: 'Phone ( ${snapshot.data!.get("phone_number")} )', fontSize: 16, color: white.withOpacity(.8)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          CustomizedText(text: 'about'.tr, fontSize: 16, fontWeight: FontWeight.bold, color: white),
                          const SizedBox(height: 10),
                          Expanded(
                            child: SingleChildScrollView(
                              child: CustomizedText(text: snapshot.data!.get("about").isEmpty ? "--" : snapshot.data!.get("about"), fontSize: 16, color: white),
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              goTo(const Historic());
                            },
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue),
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(8.0),
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              child: Center(child: CustomizedText(text: 'viewyourhistory'.tr, color: white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: blue));
            } else {
              return ErrorRoom(error: snapshot.error.toString());
            }
          },
        ),
      ),
    );
  }
}
