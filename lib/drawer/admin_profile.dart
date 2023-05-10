import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../error/error_room.dart';
import '../stuff/classes.dart';
import '../stuff/globals.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
