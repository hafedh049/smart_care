import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_tree/comment_tree.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/doctor/patient_folder.dart';
import 'package:smart_care/screens/doctor/prescription.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';

import '../articles.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _filterKey = GlobalKey();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
            const SizedBox(height: 10),
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  return ListTile(
                    leading: CircleAvatar(radius: 50, backgroundImage: snapshot.data!.get("image_url") == noUser ? null : CachedNetworkImageProvider(snapshot.data!.get("image_url")), backgroundColor: grey.withOpacity(.2), child: snapshot.data!.get("image_url") != noUser ? null : const Icon(FontAwesomeIcons.user, color: grey, size: 35)),
                    title: CustomizedText(text: 'welcome'.tr, color: grey.withOpacity(.7), fontSize: 14),
                    subtitle: CustomizedText(text: "Dr. ${snapshot.data!.get("name")}", fontSize: 18),
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ListTileShimmer();
                } else {
                  return ErrorRoom(error: snapshot.error.toString());
                }
              },
            ),
            const SizedBox(height: 10),
            Padding(padding: const EdgeInsets.only(left: 12), child: CustomizedText(text: 'appointments'.tr, fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Padding(padding: const EdgeInsets.all(8), child: TextField(controller: _searchController, onChanged: (String value) => _filterKey.currentState!.setState(() {}), decoration: InputDecoration(labelText: 'Search Appointments', prefixIcon: const Icon(Icons.search, color: grey, size: 15), border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))))),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection("appointments").where("doctorID", isEqualTo: FirebaseAuth.instance.currentUser!.uid).limit(10).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    return StatefulBuilder(
                      key: _filterKey,
                      builder: (BuildContext context, void Function(void Function()) _) {
                        final List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshot.data!.docs.where((QueryDocumentSnapshot<Map<String, dynamic>> element) => element.get("patientName").contains(_searchController.text.trim())).toList();
                        data.sort((QueryDocumentSnapshot<Map<String, dynamic>> a, QueryDocumentSnapshot<Map<String, dynamic>> b) => a.get("createdAt").toDate().millisecondsSinceEpoch > b.get("createdAt").toDate().millisecondsSinceEpoch ? 1 : -1);
                        if (data.isNotEmpty) {
                          return Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.all(8),
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
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                child: Center(
                                                  child: CommentTreeWidget<Tree, Tree>(
                                                    Tree(text: data[index].get("patientName"), icon: null),
                                                    <Tree>[Tree(text: 'filledForms'.tr, icon: FontAwesomeIcons.table), Tree(text: 'prescriptions'.tr, icon: FontAwesomeIcons.folder), Tree(text: 'bloodTests'.tr, icon: FontAwesomeIcons.staffSnake)],
                                                    treeThemeData: const TreeThemeData(lineColor: grey, lineWidth: 1),
                                                    avatarRoot: (BuildContext context, Tree _) => PreferredSize(preferredSize: const Size.fromRadius(18), child: CircleAvatar(radius: 20, backgroundImage: data[index].get("patientImageUrl") == noUser ? null : CachedNetworkImageProvider(data[index].get("patientImageUrl")), backgroundColor: grey.withOpacity(.2), child: data[index].get("patientImageUrl") != noUser ? null : const Icon(FontAwesomeIcons.user, color: grey, size: 15))),
                                                    avatarChild: (BuildContext context, Tree value) => PreferredSize(preferredSize: const Size.fromRadius(18), child: CircleAvatar(radius: 20, backgroundColor: grey.withOpacity(.2), child: Icon(value.icon, color: grey, size: 15))),
                                                    contentChild: (BuildContext context, Tree value) => Center(child: GestureDetector(onTap: () async => await goTo(PatientFolder(collection: value.text!, patientId: data[index].get("patientID"), icon: value.icon!)), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(15)), child: CustomizedText(text: value.text!, fontSize: 18, fontWeight: FontWeight.bold)))),
                                                    contentRoot: (BuildContext context, Tree value) => Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(15)), child: Center(child: CustomizedText(text: value.text!, fontSize: 18, fontWeight: FontWeight.bold))),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  GestureDetector(onTap: () => Navigator.pop(context), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: grey), child: CustomizedText(text: 'cancel'.tr, fontSize: 16))),
                                                  const SizedBox(width: 10),
                                                  GestureDetector(onTap: () async => await data[index].reference.delete().then((void value) => Navigator.pop(context)), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue), child: CustomizedText(text: 'closeFolderPermanently'.tr, fontSize: 16))),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              GestureDetector(
                                                onTap: () async => await goTo(Prescription(patientID: data[index].get("patientID"))),
                                                child: Container(
                                                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: green.withOpacity(.2)),
                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[CustomizedText(text: 'makePrescription'.tr, fontSize: 16)]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: grey.withOpacity(.1)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Flexible(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(width: 5, height: 80, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue)),
                                              const SizedBox(width: 10),
                                              CircleAvatar(radius: 30, backgroundColor: grey.withOpacity(.2), backgroundImage: data[index].get("patientImageUrl") == noUser ? null : CachedNetworkImageProvider(data[index].get("patientImageUrl")), child: data[index].get("patientImageUrl") == noUser ? const Icon(FontAwesomeIcons.user, color: grey, size: 25) : null),
                                              const SizedBox(width: 10),
                                              Container(width: 1, height: 80, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: grey.withOpacity(.2))),
                                              const SizedBox(width: 10),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(children: <Widget>[CustomizedText(text: data[index].get("patientName"), fontSize: 18, fontWeight: FontWeight.bold), const Spacer(), const Icon(FontAwesomeIcons.ellipsis, color: grey, size: 22)]),
                                                    const SizedBox(height: 10),
                                                    Container(padding: const EdgeInsets.symmetric(horizontal: 8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue.withOpacity(.2)), child: CustomizedText(text: getDateRepresentation(data[index].get("appointmentDate").toDate()), fontSize: 16)),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      children: <Widget>[
                                                        Container(padding: const EdgeInsets.symmetric(horizontal: 8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue.withOpacity(.2)), child: CustomizedText(text: data[index].get("appointmentTime"), fontSize: 14)),
                                                        const Spacer(),
                                                        Container(padding: const EdgeInsets.symmetric(horizontal: 8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue.withOpacity(.2)), child: CustomizedText(text: data[index].get("duration"), fontSize: 14)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (!data[index].get("confirmed")) const SizedBox(height: 10),
                                        if (!data[index].get("confirmed"))
                                          Center(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () async {
                                                    await data[index].reference.update(<String, bool>{"confirmed": true});
                                                    showToast(text: "Appointment approved".tr);
                                                  },
                                                  child: Container(
                                                    width: 60,
                                                    height: 45,
                                                    padding: const EdgeInsets.all(12),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.green),
                                                    child: const Center(child: Icon(FontAwesomeIcons.check, size: 20, color: white)),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                GestureDetector(
                                                  onTap: () async {
                                                    await data[index].reference.delete();
                                                    showToast(text: "Appointment deleted".tr);
                                                  },
                                                  child: Container(
                                                    width: 60,
                                                    height: 45,
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: red),
                                                    child: const Center(child: Icon(FontAwesomeIcons.x, size: 20, color: white)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) => Row(children: <Widget>[Expanded(child: Container(margin: const EdgeInsets.symmetric(vertical: 8), height: .2))]),
                            ),
                          );
                        } else {
                          return Center(child: LottieBuilder.asset("assets/lottie/notFound.json"));
                        }
                      },
                    );
                  } else {
                    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: <Widget>[LottieBuilder.asset("assets/lottie/notFound.json", height: 300), const SizedBox(height: 20), Center(child: CustomizedText(text: "No Appointments Yet.".tr, fontSize: 18))]));
                  }
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: blue));
                } else {
                  return ErrorRoom(error: snapshot.error.toString());
                }
              },
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 8, right: 8),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CustomizedText(text: 'articles'.tr, fontSize: 16, fontWeight: FontWeight.bold),
                      const Spacer(),
                      GestureDetector(onTap: () async => await goTo(const Articles()), child: CustomizedText(text: 'seeAll'.tr, fontSize: 14, color: blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance.collection("articles").limit(2).get(),
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
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(height: 200, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: const BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(35)), image: DecorationImage(image: CachedNetworkImageProvider(firstArtical.get("image_url")), fit: BoxFit.cover))),
                                          const SizedBox(height: 10),
                                          Padding(padding: const EdgeInsets.all(8), child: CustomizedText(text: firstArtical.get("title"), fontSize: 16, color: blue, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 10),
                                          Expanded(child: Padding(padding: const EdgeInsets.all(8), child: SingleChildScrollView(child: CustomizedText(text: firstArtical.get("description"), fontSize: 14)))),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
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
                          return Container(height: 80, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: grey.withOpacity(.2)), child: const Center(child: CustomizedText(text: 'No Articles.', fontSize: 16, fontWeight: FontWeight.bold)));
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
