import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_tree/comment_tree.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/doctor/patient_folder.dart';
import 'package:smart_care/screens/doctor/prescription.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../articles.dart';

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
              stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 50,
                      backgroundImage: snapshot.data!.get("image_url") == noUser ? null : CachedNetworkImageProvider(snapshot.data!.get("image_url")),
                      backgroundColor: grey.withOpacity(.2),
                      child: snapshot.data!.get("image_url") != noUser ? null : const Icon(FontAwesomeIcons.user, color: grey, size: 35),
                    ),
                    title: CustomizedText(text: AppLocalizations.of(context)!.welcome, color: white.withOpacity(.7), fontSize: 14),
                    subtitle: CustomizedText(text: snapshot.data!.get("name"), color: white, fontSize: 18),
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ListTileShimmer();
                } else {
                  return ErrorRoom(error: snapshot.error.toString());
                }
              },
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: CustomizedText(text: "Appointments", color: white, fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Appointments',
                  prefixIcon: const Icon(Icons.search, color: grey, size: 15),
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
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  content: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                          child: Center(
                                            child: CommentTreeWidget<Tree, Tree>(
                                              Tree(text: data[index].get("patientName"), icon: null),
                                              <Tree>[Tree(text: "Filled Forms", icon: FontAwesomeIcons.table), Tree(text: "Prescriptions", icon: FontAwesomeIcons.folder), Tree(text: "Blood Tests", icon: FontAwesomeIcons.folder)],
                                              treeThemeData: const TreeThemeData(lineColor: grey, lineWidth: 1),
                                              avatarRoot: (BuildContext context, Tree _) => PreferredSize(
                                                preferredSize: const Size.fromRadius(18),
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: data[index].get("patientImageUrl") == noUser ? null : CachedNetworkImageProvider(data[index].get("patientImageUrl")),
                                                  backgroundColor: grey.withOpacity(.2),
                                                  child: data[index].get("patientImageUrl") != noUser ? null : const Icon(FontAwesomeIcons.user, color: grey, size: 15),
                                                ),
                                              ),
                                              avatarChild: (BuildContext context, Tree value) => PreferredSize(
                                                preferredSize: const Size.fromRadius(18),
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: grey.withOpacity(.2),
                                                  child: Icon(value.icon, color: grey, size: 15),
                                                ),
                                              ),
                                              contentChild: (BuildContext context, Tree value) {
                                                return Center(
                                                  child: GestureDetector(
                                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PatientFolder(collection: value.text!, patientId: data[index].get("patientID"), icon: value.icon!))),
                                                    child: Container(
                                                      padding: const EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(15)),
                                                      child: CustomizedText(text: value.text!, fontSize: 18, fontWeight: FontWeight.bold, color: white),
                                                    ),
                                                  ),
                                                );
                                              },
                                              contentRoot: (BuildContext context, Tree value) {
                                                return Container(
                                                  padding: const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(15)),
                                                  child: Center(child: CustomizedText(text: value.text!, fontSize: 18, fontWeight: FontWeight.bold, color: white)),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () => Navigator.pop(context),
                                              child: Container(
                                                padding: const EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: grey),
                                                child: const CustomizedText(text: "Cancel", color: white, fontSize: 16),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                padding: const EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue),
                                                child: const CustomizedText(text: "Close Folder Permanently", color: white, fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Prescription(patientID: data[index].get("patientID"))));
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: green.withOpacity(.2)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: const <Widget>[
                                                CustomizedText(text: "Make Prescription", color: white, fontSize: 16),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
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
                                    child: data[index].get("patientImageUrl") == noUser ? const Icon(FontAwesomeIcons.user, color: grey, size: 25) : null,
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
                                            const Icon(FontAwesomeIcons.ellipsis, color: grey, size: 22),
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
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => Row(children: <Widget>[Expanded(child: Container(margin: const EdgeInsets.symmetric(vertical: 8.0), height: .2, color: white))]),
                      );
                    } else {
                      return const Center(child: CustomizedText(text: "No Appointments From Patients Yet.", color: white, fontSize: 18, fontWeight: FontWeight.bold));
                    }
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: blue));
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
                      const CustomizedText(text: "Articles", fontSize: 16, color: white, fontWeight: FontWeight.bold),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Articles())),
                        child: const CustomizedText(text: "See All", fontSize: 14, color: blue, fontWeight: FontWeight.bold),
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
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  content: SizedBox(
                                    height: 400,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            height: 200,
                                            decoration: BoxDecoration(
                                              color: grey.withOpacity(.2),
                                              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(35)),
                                              image: DecorationImage(image: CachedNetworkImageProvider(firstArtical.get("image_url")), fit: BoxFit.cover),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CustomizedText(text: firstArtical.get("title"), fontSize: 16, color: blue, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SingleChildScrollView(child: CustomizedText(text: firstArtical.get("description"), fontSize: 14, color: white)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
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
                                  child: const Center(child: Icon(FontAwesomeIcons.chevronRight, size: 10, color: white)),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            height: 80,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: white.withOpacity(.2)),
                            child: const Center(child: CustomizedText(text: 'No Articles.', fontSize: 16, color: white, fontWeight: FontWeight.bold)),
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
            LayoutBuilder(builder: (BuildContext context, BoxConstraints boxConstraints) => SizedBox(height: MediaQuery.of(context).padding.bottom > 0 ? 120 : 80)),
          ],
        ),
      ),
    );
  }
}
