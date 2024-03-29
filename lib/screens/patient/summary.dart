import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_care/utils/globals.dart';

import '../../utils/classes.dart';
import '../../utils/callbacks.dart';

class Summary extends StatelessWidget {
  const Summary({super.key, required this.data});
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronLeft, size: 15, color: grey))),
            const SizedBox(height: 20),
            CustomizedText(text: 'summary'.tr, fontSize: 30, fontWeight: FontWeight.bold),
            const SizedBox(height: 40),
            CustomizedText(text: 'bookingInfo'.tr, fontSize: 18, fontWeight: FontWeight.bold),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: <Widget>[
                  CircleAvatar(radius: 20, backgroundColor: grey.withOpacity(.2), child: const Icon(FontAwesomeIcons.calendar, size: 15, color: grey)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CustomizedText(text: 'dateTime'.tr, fontSize: 16, fontWeight: FontWeight.bold),
                      const SizedBox(height: 5),
                      CustomizedText(text: getDateRepresentation(data["appointmentDate"].toDate()), fontSize: 14, color: grey.withOpacity(.6)),
                      const SizedBox(height: 5),
                      CustomizedText(text: data["appointmentTime"], fontSize: 14, color: grey.withOpacity(.6)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Container(color: white.withOpacity(.2), height: .8, width: MediaQuery.of(context).size.width)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: <Widget>[
                  CircleAvatar(radius: 20, backgroundColor: grey.withOpacity(.2), child: const Icon(FontAwesomeIcons.dna, size: 15, color: grey)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CustomizedText(text: 'appointmentType'.tr, fontSize: 16, fontWeight: FontWeight.bold),
                      const SizedBox(height: 5),
                      CustomizedText(text: data["type"], fontSize: 14, color: grey.withOpacity(.6)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Container(color: white.withOpacity(.2), height: .8, width: MediaQuery.of(context).size.width)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: <Widget>[
                  CircleAvatar(radius: 20, backgroundColor: grey.withOpacity(.2), child: const Icon(FontAwesomeIcons.clock, size: 15, color: grey)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CustomizedText(text: 'duration'.tr, fontSize: 16, fontWeight: FontWeight.bold),
                      const SizedBox(height: 5),
                      CustomizedText(text: data["duration"], fontSize: 14, color: grey.withOpacity(.6)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Container(color: white.withOpacity(.2), height: .8, width: MediaQuery.of(context).size.width)),
            const SizedBox(height: 40),
            CustomizedText(text: 'doctorInfo'.tr, fontSize: 18, fontWeight: FontWeight.bold),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: <Widget>[
                  CircleAvatar(radius: 20, backgroundColor: grey.withOpacity(.2), backgroundImage: data["doctorImageUrl"] == noUser ? null : CachedNetworkImageProvider(data["doctorImageUrl"]), child: data["doctorImageUrl"] == noUser ? const Icon(FontAwesomeIcons.user, size: 15, color: grey) : null),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CustomizedText(text: "Dr. ${data["doctorName"]}", fontSize: 16, fontWeight: FontWeight.bold),
                      const SizedBox(height: 5),
                      Row(children: <Widget>[for (int square = 0; square < 5; square++) Transform.rotate(angle: pi / 4, child: Container(margin: const EdgeInsets.only(right: 8), width: 6, height: 6, color: blue))]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
