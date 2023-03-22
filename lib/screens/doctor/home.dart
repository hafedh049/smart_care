import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
            const SizedBox(height: 10),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection("health_care_professionals").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 50,
                      backgroundImage: snapshot.data!.get("image_url") == noUser ? null : CachedNetworkImageProvider(snapshot.data!.get("image_url")),
                      backgroundColor: grey.withOpacity(.2),
                      child: snapshot.data!.get("image_url") != noUser ? null : Icon(FontAwesomeIcons.user, color: grey, size: 35),
                    ),
                    title: CustomizedText(text: AppLocalizations.of(context)!.welcome, color: white.withOpacity(.7), fontSize: 14),
                    subtitle: CustomizedText(text: snapshot.data!.get("medical_professional_name"), color: white, fontSize: 18),
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ListTileShimmer();
                } else {
                  return ErrorRoom(error: snapshot.error.toString());
                }
              },
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: CustomizedText(text: "Appointments", color: white, fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Appointments',
                  prefixIcon: Icon(Icons.search, color: grey, size: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection("appointments").where("doctorID", isEqualTo: FirebaseAuth.instance.currentUser!.uid).orderBy("createdAt", descending: true).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!.docs;
                    if (data.isNotEmpty) {
                      return ListView.separated(
                        padding: const EdgeInsets.all(8.0),
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: grey.withOpacity(.1)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(width: 5, height: 80, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue)),
                                const SizedBox(width: 10),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: grey.withOpacity(.2),
                                  backgroundImage: data[index].get("patientImageUrl") == noUser ? null : CachedNetworkImageProvider(data[index].get("patientImageUrl")),
                                  child: data[index].get("patientImageUrl") == noUser ? Icon(FontAwesomeIcons.user, color: grey, size: 25) : null,
                                ),
                                const SizedBox(width: 10),
                                Container(width: 1, height: 80, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: white.withOpacity(.2))),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          CustomizedText(text: data[index].get("patientName"), color: white, fontSize: 18, fontWeight: FontWeight.bold),
                                          const Spacer(),
                                          GestureDetector(onTap: () {}, child: Icon(FontAwesomeIcons.ellipsis, color: grey, size: 22)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue.withOpacity(.2)),
                                        child: CustomizedText(text: getDateRepresentation(data[index].get("appointmentDate").toDate()), color: white.withOpacity(.8), fontSize: 16),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue.withOpacity(.2)),
                                            child: CustomizedText(text: data[index].get("appointmentTime"), color: white.withOpacity(.8), fontSize: 14),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue.withOpacity(.2)),
                                            child: CustomizedText(text: data[index].get("duration"), color: white.withOpacity(.8), fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => Row(children: <Widget>[Expanded(child: Container(height: 1, color: white))]),
                      );
                    } else {
                      return Center(child: CustomizedText(text: "No Appointments From Patients Yet.", color: white, fontSize: 18, fontWeight: FontWeight.bold));
                    }
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: blue));
                  } else {
                    return ErrorRoom(error: snapshot.error.toString());
                  }
                },
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
                          onTap: () {
                            if (play == 1) {
                              playNote("tap.wav");
                            }
                          },
                          child: CustomizedText(text: "See All", fontSize: 14, color: blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      if (play == 1) {
                        playNote("tap.wav");
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CircleAvatar(radius: 15, backgroundColor: blue, backgroundImage: CachedNetworkImageProvider(noUser)),
                          const Spacer(),
                          CustomizedText(text: 'How to make your teeth stronger naturally', fontSize: 16, color: white, fontWeight: FontWeight.bold),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue),
                            height: 20,
                            child: Center(child: Icon(FontAwesomeIcons.chevronRight, size: 10, color: white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            LayoutBuilder(builder: (BuildContext context, BoxConstraints boxConstraints) => SizedBox(height: MediaQuery.of(context).padding.bottom > 0 ? 120 : 80)),
          ],
        ),
      ),
    );
  }
}
