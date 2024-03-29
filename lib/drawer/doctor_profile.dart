import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/utils/classes.dart';
import 'package:smart_care/utils/callbacks.dart';
import 'package:smart_care/utils/globals.dart';

class DoctorProfile extends StatelessWidget {
  const DoctorProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(children: <Widget>[const SizedBox(height: 250), Expanded(child: Container(decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)), color: blue)))]),
          Column(children: <Widget>[const SizedBox(height: 450), Expanded(child: Container(decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)), color: white.withOpacity(.4))))]),
          Padding(
            padding: const EdgeInsets.all(8),
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronLeft, size: 15, color: grey))),
                          CustomizedText(text: 'doctorProfile'.tr, fontSize: 18, fontWeight: FontWeight.bold),
                          GestureDetector(onTap: () {}, child: Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.ellipsisVertical, size: 15, color: grey))),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => showDialog(context: context, builder: (BuildContext context) => AlertDialog(contentPadding: EdgeInsets.zero, content: InteractiveViewer(child: CachedNetworkImage(imageUrl: snapshot.data!.get("image_url"))))),
                            child: CircleAvatar(radius: 50, backgroundImage: snapshot.data!.get("image_url") == noUser ? null : CachedNetworkImageProvider(snapshot.data!.get("image_url")), backgroundColor: grey.withOpacity(.2), child: snapshot.data!.get("image_url") != noUser ? null : const Icon(FontAwesomeIcons.user, color: grey, size: 35)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CustomizedText(text: "Dr. ${snapshot.data!.get("name")}", fontSize: 18, fontWeight: FontWeight.bold),
                                const SizedBox(height: 5),
                                Flexible(child: CustomizedText(text: snapshot.data!.get("grade"), fontSize: 14, color: grey.withOpacity(.8))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Center(child: Container(width: 30, height: 3, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)))),
                      const SizedBox(height: 30),
                      const CustomizedText(text: "Calendar", fontSize: 20, fontWeight: FontWeight.bold),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          for (int day in <int>[DateTime.now().subtract(2.days).day, DateTime.now().subtract(1.days).day, DateTime.now().day, DateTime.now().add(1.days).day, DateTime.now().add(2.days).day])
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: day == DateTime.now().day ? white : transparent),
                              child: day == DateTime.now().day ? Column(children: <Widget>[CustomizedText(text: showWeekDay(day), fontSize: 16, color: darkBlue), const SizedBox(height: 5), CustomizedText(text: "${day < 10 ? '0' : ''}$day", fontSize: 20, fontWeight: FontWeight.bold, color: darkBlue), const SizedBox(height: 5), const CircleAvatar(radius: 4, backgroundColor: blue)]) : Column(children: <Widget>[CustomizedText(text: "${day < 10 ? '0' : ''}$day", fontSize: 20, fontWeight: FontWeight.bold), const SizedBox(height: 10), CustomizedText(text: showWeekDay(day), fontSize: 16)]),
                            ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Center(child: Container(width: 30, height: 3, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)))),
                      const SizedBox(height: 30),
                      CustomizedText(text: 'about'.tr, fontSize: 20, fontWeight: FontWeight.bold),
                      const SizedBox(height: 20),
                      Expanded(child: SizedBox(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [CustomizedText(text: snapshot.data!.get("about").isEmpty ? "Not Set" : snapshot.data!.get("about"), fontSize: 14)])))),
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
        ],
      ),
    );
  }
}
