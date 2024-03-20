import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_care/drawer/profile.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/articles.dart';
import 'package:smart_care/screens/patient/fetch_all_appointments.dart';
import 'package:smart_care/screens/patient/filter.dart';
import 'package:smart_care/screens/patient/summary.dart';
import 'package:smart_care/utils/classes.dart';
import 'package:smart_care/utils/globals.dart';

import '../../utils/callbacks.dart';
import '../article.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
              Center(
                child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: <Widget>[
                          GestureDetector(onTap: () async => await goTo(const Profile()), child: CircleAvatar(radius: 30, backgroundImage: snapshot.data!.get("image_url") == noUser ? null : CachedNetworkImageProvider(snapshot.data!.get("image_url")), backgroundColor: grey.withOpacity(.2), child: snapshot.data!.get("image_url") != noUser ? null : const Icon(FontAwesomeIcons.user, color: grey, size: 25))),
                          const SizedBox(height: 15),
                          Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: <Widget>[CustomizedText(text: 'hello'.tr, fontSize: 22), CustomizedText(text: snapshot.data!.get("name"), fontSize: 22, fontWeight: FontWeight.bold)]),
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
                onTap: () async => await goTo(const FilterList()),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(color: grey.withOpacity(.5), borderRadius: const BorderRadius.only(topRight: Radius.circular(7), bottomRight: Radius.circular(7), topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
                  padding: const EdgeInsets.only(left: 8),
                  margin: const EdgeInsets.only(right: 8),
                  child: Row(
                    children: <Widget>[
                      const Padding(padding: EdgeInsets.only(left: 8, right: 8), child: Icon(Icons.search)),
                      const CustomizedText(text: 'Search For Doctors', fontSize: 16, color: grey),
                      const Spacer(),
                      Container(width: 5, height: 48, decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(35)), color: blue)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8, right: 8),
                child: Column(
                  children: <Widget>[
                    Row(children: <Widget>[CustomizedText(text: 'upcomingAppointment'.tr, fontSize: 16, fontWeight: FontWeight.bold), const Spacer(), GestureDetector(onTap: () async => await goTo(const FetchAllAppointments()), child: CustomizedText(text: 'seeAll'.tr, fontSize: 14, color: blue, fontWeight: FontWeight.bold))]),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            future: FirebaseFirestore.instance.collection("appointments").where("patientID", isEqualTo: me["uid"].trim()).limit(1).get(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                              if (snapshot.hasData) {
                                final List<QueryDocumentSnapshot<Map<String, dynamic>>> appointments = snapshot.data!.docs;
                                if (appointments.isEmpty) {
                                  return Container(
                                    height: 180,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: grey.withOpacity(.2), image: const DecorationImage(image: CachedNetworkImageProvider(rodeOfAsclepius), fit: BoxFit.cover)),
                                    child: Center(child: CustomizedText(text: 'noAppointmentsYet'.tr.toUpperCase(), fontSize: 20, fontWeight: FontWeight.bold)),
                                  );
                                } else {
                                  if (snapshot.data!.docs.isNotEmpty) {
                                    final QueryDocumentSnapshot<Map<String, dynamic>> firstAppointment = snapshot.data!.docs.first;
                                    return GestureDetector(
                                      onTap: () async => await goTo(Summary(data: firstAppointment.data())),
                                      child: Container(
                                        height: 180,
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: grey.withOpacity(.2), image: const DecorationImage(image: CachedNetworkImageProvider(rodeOfAsclepius), fit: BoxFit.cover)),
                                        child: Column(
                                          children: <Widget>[
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                CircleAvatar(radius: 50, backgroundImage: firstAppointment.get("doctorImageUrl") == noUser ? null : CachedNetworkImageProvider(firstAppointment.get("doctorImageUrl")), backgroundColor: grey.withOpacity(.2), child: firstAppointment.get("doctorImageUrl") != noUser ? null : const Icon(FontAwesomeIcons.user, color: grey, size: 35)),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                  child: Container(
                                                    decoration: BoxDecoration(color: blue.withOpacity(.2), borderRadius: BorderRadius.circular(15)),
                                                    padding: const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        CustomizedText(text: firstAppointment.get("doctorName"), fontSize: 16, fontWeight: FontWeight.bold),
                                                        const SizedBox(height: 5),
                                                        CustomizedText(text: firstAppointment.get("doctorSpeciality").isEmpty ? "Not Set Yet." : firstAppointment.get("doctorSpeciality"), fontSize: 14, color: grey.withOpacity(.8)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue),
                                              height: 30,
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(FontAwesomeIcons.calendar, size: 12, color: grey.withOpacity(.6)),
                                                  const SizedBox(width: 10),
                                                  CustomizedText(text: getDateRepresentation(firstAppointment.get("appointmentDate").toDate()), fontSize: 14, fontWeight: FontWeight.bold),
                                                  const Spacer(),
                                                  Icon(FontAwesomeIcons.clock, size: 12, color: grey.withOpacity(.6)),
                                                  const SizedBox(width: 10),
                                                  CustomizedText(text: "${'at'.tr} ${firstAppointment.get('appointmentTime')}", fontSize: 14),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: <Widget>[LottieBuilder.asset("assets/lottie/notFound.json", height: 300), const SizedBox(height: 20), Center(child: CustomizedText(text: "No Appointments Yet.".tr, fontSize: 18))]));
                                  }
                                }
                              } else if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator(color: blue));
                              } else {
                                return ErrorRoom(error: snapshot.error.toString());
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async => await goTo(const FilterList()),
                          child: Container(
                            height: 180,
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                            width: 40,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: grey.withOpacity(.2), image: const DecorationImage(image: CachedNetworkImageProvider(rodeOfAsclepius), fit: BoxFit.cover)),
                            child: const Center(child: CustomizedText(text: "+", fontSize: 30, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8, right: 8),
                child: Column(
                  children: <Widget>[
                    Row(children: <Widget>[CustomizedText(text: 'articles'.tr, fontSize: 16, fontWeight: FontWeight.bold), const Spacer(), GestureDetector(onTap: () async => await goTo(const Articles()), child: CustomizedText(text: 'seeAll'.tr, fontSize: 14, color: blue, fontWeight: FontWeight.bold))]),
                    const SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance.collection("articles").limit(2).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.isNotEmpty) {
                            final QueryDocumentSnapshot<Map<String, dynamic>> firstArtical = snapshot.data!.docs[Random().nextInt(snapshot.data!.docs.length)];
                            return GestureDetector(
                              onTap: () async => await goTo(Article(article: firstArtical.data())),
                              child: Row(
                                children: <Widget>[
                                  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue), height: 20, width: 20),
                                  const SizedBox(width: 10),
                                  Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: CustomizedText(text: firstArtical.get("title"), fontSize: 16, fontWeight: FontWeight.bold))),
                                  const SizedBox(width: 10),
                                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue), height: 20, width: 20, child: const Center(child: Icon(FontAwesomeIcons.chevronRight, size: 10))),
                                ],
                              ),
                            );
                          } else {
                            return Container(height: 80, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: grey.withOpacity(.2)), child: Center(child: CustomizedText(text: 'noArticles'.tr, fontSize: 16, fontWeight: FontWeight.bold)));
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
              SizedBox(height: MediaQuery.of(context).padding.bottom > 0 ? 100 : 80)
            ],
          ),
        ),
      ),
    );
  }
}
