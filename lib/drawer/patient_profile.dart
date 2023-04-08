import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/patient/historic.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientProfile extends StatelessWidget {
  const PatientProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: darkBlue,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    decoration: BoxDecoration(
                      color: grey.withOpacity(.2),
                      image: snapshot.data!.get("image_url") == noUser ? null : DecorationImage(image: CachedNetworkImageProvider(snapshot.data!.get("image_url")), fit: BoxFit.cover),
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
                    ),
                    child: Stack(
                      children: <Widget>[
                        if (snapshot.data!.get("image_url") == noUser) const Center(child: Icon(FontAwesomeIcons.user, color: grey, size: 80)),
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(color: darkBlue, borderRadius: BorderRadius.circular(5)),
                              child: const Icon(FontAwesomeIcons.chevronLeft, size: 15, color: white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomizedText(text: snapshot.data!.get("name"), fontSize: 25, fontWeight: FontWeight.bold, color: white),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            const Icon(FontAwesomeIcons.tooth, size: 25, color: blue),
                            const SizedBox(width: 10),
                            Flexible(child: CustomizedText(text: snapshot.data!.get("speciality"), fontSize: 18, color: white.withOpacity(.8))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            const Icon(Icons.numbers, size: 25, color: blue),
                            const SizedBox(width: 10),
                            CustomizedText(text: "Age ( ${DateTime.now().difference(snapshot.data!.get('date_of_birth').toDate()).inDays ~/ 365} )", fontSize: 18, color: white.withOpacity(.8)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            const Icon(FontAwesomeIcons.locationPinLock, size: 25, color: blue),
                            const SizedBox(width: 10),
                            CustomizedText(text: 'Location ( ${snapshot.data!.get("location").isEmpty ? "Monastir, Tunisia" : snapshot.data!.get("location")} )', fontSize: 18, color: white.withOpacity(.8)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            const Icon(FontAwesomeIcons.envelope, size: 25, color: blue),
                            const SizedBox(width: 10),
                            CustomizedText(text: 'E-mail ( ${snapshot.data!.get("email")} )', fontSize: 18, color: white.withOpacity(.8)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            const Icon(Icons.phone, size: 20, color: blue),
                            const SizedBox(width: 10),
                            CustomizedText(text: 'Phone ( ${snapshot.data!.get("phone_number")} )', fontSize: 18, color: white.withOpacity(.8)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomizedText(text: AppLocalizations.of(context)!.about, fontSize: 20, fontWeight: FontWeight.bold, color: white),
                        const SizedBox(height: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            child: CustomizedText(text: snapshot.data!.get("about").isEmpty ? "--" : snapshot.data!.get("about"), fontSize: 18, color: white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            goTo(const Historic());
                            //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Historic()));
                          },
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue),
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(8.0),
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            child: Center(child: CustomizedText(text: AppLocalizations.of(context)!.viewyourhistory, color: white, fontSize: 18, fontWeight: FontWeight.bold)),
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
            return const ContainerShimmer();
          } else {
            return ErrorRoom(error: snapshot.error.toString());
          }
        },
      ),
    );
  }
}
