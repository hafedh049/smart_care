import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/drawer/profile.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/articles.dart';
import 'package:smart_care/screens/patient/fetch_all_appointments.dart';
import 'package:smart_care/screens/patient/filter.dart';
import 'package:smart_care/screens/patient/summary.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../stuff/functions.dart';
import '../article.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
              Center(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection("health_care_professionals").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Profile()));
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: snapshot.data!.get("image_url") == noUser ? null : CachedNetworkImageProvider(snapshot.data!.get("image_url")),
                              backgroundColor: grey.withOpacity(.2),
                              child: snapshot.data!.get("image_url") != noUser ? null : Icon(FontAwesomeIcons.user, color: grey, size: 25),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const CustomizedText(text: "Hello, ", fontSize: 22),
                              CustomizedText(text: snapshot.data!.get("medical_professional_name"), fontSize: 22, fontWeight: FontWeight.bold),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.locationPin, size: 15, color: blue),
                              const SizedBox(width: 10),
                              CustomizedText(text: snapshot.data!.get("location").isNotEmpty ? snapshot.data!.get("location") : "Monastir, Tunisie", fontSize: 16, color: grey),
                            ],
                          ),
                        ],
                      );
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return const AvatarUsernameLocationShimmer();
                    } else {
                      return ErrorRoom(error: snapshot.error.toString());
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  if (play == 1) {
                    playNote("tap.wav");
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const FilterList()));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(color: grey.withOpacity(.5), borderRadius: const BorderRadius.only(topRight: Radius.circular(7), bottomRight: Radius.circular(7), topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
                  padding: const EdgeInsets.only(left: 8),
                  margin: const EdgeInsets.only(right: 8),
                  child: Row(
                    children: <Widget>[
                      const Padding(padding: EdgeInsets.only(left: 8, right: 8), child: Icon(Icons.search)),
                      CustomizedText(text: 'Search For Doctors', fontSize: 16, color: grey),
                      const Spacer(),
                      Container(width: 5, height: 48, decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(35)), color: blue)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        height: 150,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue.withOpacity(.7)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CustomizedText(text: "Online Consultation", fontSize: 25, color: white),
                            const SizedBox(height: 20),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: white),
                                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                child: CustomizedText(text: "Find Doctor", fontSize: 16, color: darkBlue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        height: 150,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.amber.shade900.withOpacity(.7)),
                        child: Column(
                          children: <Widget>[
                            CustomizedText(text: "Visit A Doctor Offline", fontSize: 25, color: white),
                            const SizedBox(height: 20),
                            Center(
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: white),
                                padding: const EdgeInsets.all(8.0),
                                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                child: CustomizedText(text: "Appointment", fontSize: 16, color: darkBlue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, right: 8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CustomizedText(text: "Upcoming Appointment", fontSize: 16, color: white, fontWeight: FontWeight.bold),
                        const Spacer(),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const FetchAllAppointments()));
                            },
                            child: CustomizedText(text: "See All", fontSize: 14, color: blue, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance.collection("appointments").where("patientID", isEqualTo: me["uid"].trim()).snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                              if (snapshot.hasData) {
                                final List<QueryDocumentSnapshot<Map<String, dynamic>>> appointments = snapshot.data!.docs;
                                if (appointments.isEmpty) {
                                  return Container(
                                    height: 180,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: white.withOpacity(.2)),
                                    child: Center(child: CustomizedText(text: 'No Appointments Yet.', fontSize: 16, color: white, fontWeight: FontWeight.bold)),
                                  );
                                } else {
                                  final QueryDocumentSnapshot<Map<String, dynamic>> firstAppointment = snapshot.data!.docs.first;
                                  return GestureDetector(
                                    onTap: () {
                                      if (play == 1) {
                                        playNote("tap.wav");
                                      }
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Summary(data: firstAppointment.data())));
                                    },
                                    child: Container(
                                      height: 180,
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: white.withOpacity(.2)),
                                      child: Column(
                                        children: <Widget>[
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                height: 130,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: darkBlue.withOpacity(.2),
                                                  border: Border.all(color: blue),
                                                  borderRadius: BorderRadius.circular(15),
                                                  image: firstAppointment.get("doctorImageUrl") == noUser ? null : DecorationImage(image: CachedNetworkImageProvider(noUser), fit: BoxFit.cover),
                                                ),
                                                child: firstAppointment.get("doctorImageUrl") == noUser ? Center(child: Icon(FontAwesomeIcons.user, size: 60, color: grey)) : null,
                                              ),
                                              const SizedBox(width: 10),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    CustomizedText(text: firstAppointment.get("doctorName"), fontSize: 16, color: white, fontWeight: FontWeight.bold),
                                                    const SizedBox(height: 5),
                                                    CustomizedText(text: firstAppointment.get("doctorSpeciality").isEmpty ? "--" : firstAppointment.get("doctorSpeciality"), fontSize: 14, color: white.withOpacity(.8)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue),
                                            height: 30,
                                            child: Row(
                                              children: <Widget>[
                                                Icon(FontAwesomeIcons.calendar, size: 12, color: white.withOpacity(.6)),
                                                const SizedBox(width: 10),
                                                CustomizedText(text: getDateRepresentation(firstAppointment.get("appointmentDate").toDate()), fontSize: 14, color: white.withOpacity(.6), fontWeight: FontWeight.bold),
                                                const Spacer(),
                                                Icon(FontAwesomeIcons.clock, size: 12, color: white.withOpacity(.6)),
                                                const SizedBox(width: 10),
                                                CustomizedText(text: "At ${firstAppointment.get('appointmentTime')}", fontSize: 14, color: white.withOpacity(.6)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              } else if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator(color: blue));
                              } else {
                                return ErrorRoom(error: snapshot.error.toString());
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            if (play == 1) {
                              playNote("tap.wav");
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const FilterList()));
                          },
                          child: Container(
                            height: 180,
                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
                            width: 40,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: white.withOpacity(.2)),
                            child: Center(child: RotatedBox(quarterTurns: 3, child: CustomizedText(text: 'Make A New', fontSize: 16, color: white, fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, right: 8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CustomizedText(text: "Articles", fontSize: 16, color: white, fontWeight: FontWeight.bold),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Articles())),
                          child: CustomizedText(text: "See All", fontSize: 14, color: blue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance.collection("articles").snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.isNotEmpty) {
                            final QueryDocumentSnapshot<Map<String, dynamic>> firstArtical = snapshot.data!.docs[Random().nextInt(snapshot.data!.docs.length)];
                            return GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Article(article: firstArtical.data()))),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue),
                                    height: 20,
                                    width: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: CustomizedText(text: firstArtical.get("title"), fontSize: 16, color: white, fontWeight: FontWeight.bold))),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue),
                                    height: 20,
                                    width: 20,
                                    child: Center(child: Icon(FontAwesomeIcons.chevronRight, size: 10, color: white)),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              height: 80,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: white.withOpacity(.2)),
                              child: Center(child: CustomizedText(text: 'No Articles.', fontSize: 16, color: white, fontWeight: FontWeight.bold)),
                            );
                          }
                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                          return const ListTileShimmer();
                        } else {
                          return ErrorRoom(error: snapshot.error.toString());
                        }
                      },
                    ),
                  ],
                ),
              ),
              LayoutBuilder(builder: (BuildContext context, BoxConstraints boxConstraints) => SizedBox(height: MediaQuery.of(context).padding.bottom > 0 ? 100 : 80)),
            ],
          ),
        ),
      ),
    );
  }
}
