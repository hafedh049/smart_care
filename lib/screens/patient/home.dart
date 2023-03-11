import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                    leading: CircleAvatar(radius: 25, backgroundImage: CachedNetworkImageProvider(snapshot.data!.get("image_url"))),
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
          ],
        ),
      ),
    );
  }
}
