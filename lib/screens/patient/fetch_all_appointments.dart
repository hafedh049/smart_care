import 'dart:math' show pi;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../error/error_room.dart';
import '../../stuff/classes.dart';
import '../../stuff/functions.dart';
import '../../stuff/globals.dart';

class FetchAllAppointments extends StatefulWidget {
  const FetchAllAppointments({super.key});

  @override
  State<FetchAllAppointments> createState() => _FetchAllAppointmentsState();
}

class _FetchAllAppointmentsState extends State<FetchAllAppointments> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _xKey = GlobalKey();
  final GlobalKey _filterKey = GlobalKey();
  final FocusNode _filterNode = FocusNode();
  bool _showClearButton = false;
  @override
  void dispose() {
    _searchController.dispose();
    _filterNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _filterNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: darkBlue,
        extendBody: true,
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(FontAwesomeIcons.chevronLeft, size: 20),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      focusNode: _filterNode,
                      controller: _searchController,
                      onChanged: (String value) {
                        _xKey.currentState!.setState(() => _filterKey.currentState!.setState(() => _showClearButton = value.isEmpty ? false : true));
                      },
                      decoration: InputDecoration(hintText: 'searchAppointments'.tr, border: InputBorder.none, contentPadding: const EdgeInsets.only(left: 8, right: 8)),
                    ),
                  ),
                  StatefulBuilder(
                    key: _xKey,
                    builder: (BuildContext context, void Function(void Function()) setS) {
                      return Visibility(
                        visible: _showClearButton,
                        child: GestureDetector(
                          onTap: () => setS(() {
                            _searchController.clear();
                            _showClearButton = false;
                          }),
                          child: const Padding(padding: EdgeInsets.only(left: 8, right: 8), child: Icon(Icons.clear)),
                        ),
                      );
                    },
                  ),
                  Container(width: 5, height: 48, decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(35)), color: blue)),
                ],
              ),
              const SizedBox(height: 10),
              StatefulBuilder(
                key: _filterKey,
                builder: (BuildContext context, void Function(void Function()) _) {
                  return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance.collection("appointments").where("patientID", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.hasData) {
                        List<QueryDocumentSnapshot<Map<String, dynamic>>> appointmentList = snapshot.data!.docs.where((QueryDocumentSnapshot<Map<String, dynamic>> element) => true).toList();
                        if (appointmentList.isNotEmpty) {
                          return Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                              itemCount: appointmentList.length,
                              itemBuilder: (BuildContext context, int index) => Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(color: dark, borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(width: 5, height: 175, decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: blue)),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              CustomizedText(text: 'appointmentDate'.tr, fontSize: 16, color: white.withOpacity(.6), fontWeight: FontWeight.bold),
                                              const Spacer(),
                                              GestureDetector(onTap: () async => await FirebaseFirestore.instance.collection("appointments").doc(appointmentList[index].id.trim()).delete().then((void value) => showToast(text: 'appointmentisCanceled'.tr)), child: const Icon(Icons.delete, size: 20, color: white)),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(15)), color: blue.withOpacity(.1)),
                                            child: Row(
                                              children: <Widget>[
                                                const Icon(FontAwesomeIcons.clock, size: 15, color: white),
                                                const SizedBox(width: 10),
                                                CustomizedText(text: getDateRepresentation(appointmentList[index].get("appointmentDate").toDate()), fontSize: 14, color: white.withOpacity(.6)),
                                                const SizedBox(width: 5),
                                                CustomizedText(text: appointmentList[index].get("appointmentTime"), fontSize: 14, color: white.withOpacity(.6)),
                                                const SizedBox(width: 5),
                                                CustomizedText(text: appointmentList[index].get("duration"), fontSize: 14, color: white.withOpacity(.6)),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(color: white.withOpacity(.2), height: .8, width: MediaQuery.of(context).size.width - 64),
                                          const SizedBox(height: 10),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              CircleAvatar(radius: 30, backgroundColor: grey.withOpacity(.2), backgroundImage: appointmentList[index].get("doctorImageUrl") == noUser ? null : CachedNetworkImageProvider(appointmentList[index].get("doctorImageUrl")), child: appointmentList[index].get("doctorImageUrl") == noUser ? const Icon(FontAwesomeIcons.user, size: 20, color: grey) : null),
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  CustomizedText(text: 'Dr. ${appointmentList[index].get("doctorName")}', fontSize: 16, fontWeight: FontWeight.bold, color: white),
                                                  const SizedBox(height: 5),
                                                  CustomizedText(text: appointmentList[index].get("doctorSpeciality"), fontSize: 14, fontWeight: FontWeight.bold, color: white.withOpacity(.6)),
                                                  const SizedBox(height: 10),
                                                  Row(children: <Widget>[for (int square = 0; square < 5; square++) Transform.rotate(angle: pi / 4, child: Container(margin: const EdgeInsets.only(right: 8.0), width: 6, height: 6, color: blue))]),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Expanded(child: Center(child: CustomizedText(text: 'noAppointmentsYet'.tr, color: white, fontSize: 25, fontWeight: FontWeight.bold)));
                        }
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return Expanded(child: ListView.builder(itemCount: 30, itemBuilder: (BuildContext context, int index) => const ListTileShimmer()));
                      } else {
                        return ErrorRoom(error: snapshot.error.toString());
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
