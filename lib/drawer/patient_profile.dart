import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/screens/screens.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';

class PatientProfile extends StatelessWidget {
  const PatientProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            decoration: BoxDecoration(
              color: blue,
              image: DecorationImage(image: CachedNetworkImageProvider(noUser), fit: BoxFit.cover),
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
            ),
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(5)),
                  child: Icon(FontAwesomeIcons.chevronLeft, size: 15, color: darkBlue),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomizedText(text: "Hafedh Gunichi", fontSize: 20, fontWeight: FontWeight.bold, color: white),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.tooth, size: 15, color: white),
                      const SizedBox(width: 10),
                      CustomizedText(text: 'Tooth Specialist', fontSize: 14, color: white.withOpacity(.8)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(Icons.numbers, size: 15, color: white),
                      const SizedBox(width: 10),
                      CustomizedText(text: 'Age ( ${34} )', fontSize: 14, color: white.withOpacity(.8)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.locationPin, size: 15, color: white),
                      const SizedBox(width: 10),
                      CustomizedText(text: 'Location ( ${"Monastir, Tunisie"} )', fontSize: 14, color: white.withOpacity(.8)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomizedText(text: "About", fontSize: 20, fontWeight: FontWeight.bold, color: white),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SizedBox(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CustomizedText(text: "The patient with tooth pain arrived at the dentist's office in distress. After a thorough examination, the dentist discovered a cavity that required immediate attention. With a quick and painless procedure, the tooth was filled, and the patient was able to leave with a smile on their face.", fontSize: 14, color: white),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const Screens(firstScreen: 4)), (Route route) => route.isFirst == true);
                    },
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue),
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: Center(child: CustomizedText(text: "View your history", color: white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
