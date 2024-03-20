import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../error/error_room.dart';
import '../utils/classes.dart';
import '../utils/globals.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 40),
                  GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronLeft, size: 15, color: grey))),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: snapshot.data!.get("image_url") == noUser ? null : () => showDialog(context: context, builder: (BuildContext context) => AlertDialog(contentPadding: EdgeInsets.zero, content: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)), child: InteractiveViewer(child: CachedNetworkImage(imageUrl: snapshot.data!.get("image_url"), placeholder: (BuildContext context, String url) => const Center(child: Icon(FontAwesomeIcons.user, color: grey, size: 80))))))),
                    child: Center(child: CircleAvatar(backgroundColor: grey.withOpacity(.3), radius: 65, backgroundImage: snapshot.data!.get("image_url") == noUser ? null : CachedNetworkImageProvider(snapshot.data!.get("image_url")), child: snapshot.data!.get("image_url") == noUser ? const Icon(FontAwesomeIcons.user, color: grey, size: 80) : null)),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomizedText(text: snapshot.data!.get("name"), fontSize: 18, fontWeight: FontWeight.bold),
                          const SizedBox(height: 10),
                          Container(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue.withOpacity(.3)), child: Row(children: <Widget>[const Icon(Icons.numbers, size: 18, color: blue), const SizedBox(width: 10), CustomizedText(text: "Age ( ${DateTime.now().difference(snapshot.data!.get('date_of_birth').toDate()).inDays ~/ 365} )", fontSize: 16)])),
                          const SizedBox(height: 10),
                          Container(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue.withOpacity(.3)), child: Row(children: <Widget>[const Icon(FontAwesomeIcons.envelope, size: 15, color: blue), const SizedBox(width: 10), CustomizedText(text: 'E-mail ( ${snapshot.data!.get("email")} )', fontSize: 16)])),
                          const SizedBox(height: 10),
                          Container(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue.withOpacity(.3)), child: Row(children: <Widget>[const Icon(Icons.phone, size: 14, color: blue), const SizedBox(width: 10), CustomizedText(text: 'Phone ( ${snapshot.data!.get("phone_number")} )', fontSize: 16)])),
                          const SizedBox(height: 10),
                          Container(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue.withOpacity(.3)), child: const Row(children: <Widget>[Icon(FontAwesomeIcons.graduationCap, size: 14, color: blue), SizedBox(width: 10), CustomizedText(text: 'Role ( Admin )', fontSize: 16)])),
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
