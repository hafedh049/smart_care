import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/admin/deletion_dialog.dart';

import '../../stuff/classes.dart';
import '../../stuff/globals.dart';

class DoctorsList extends StatefulWidget {
  const DoctorsList({super.key});

  @override
  State<DoctorsList> createState() => _DoctorsListState();
}

class _DoctorsListState extends State<DoctorsList> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _doctorsKey = GlobalKey();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 30),
              Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
              const Row(children: <Widget>[Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), SizedBox(width: 50)]),
              const Row(children: <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
              const SizedBox(height: 10),
              StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) _) {
                  return TextField(
                    controller: _searchController,
                    onChanged: (String text) => _doctorsKey.currentState!.setState(() {}),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: grey),
                      suffixIcon: _searchController.text.isEmpty ? null : IconButton(icon: const Icon(Icons.clear), onPressed: () => _(() => _searchController.clear())),
                      hintText: 'Search',
                      filled: true,
                      enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0)), borderSide: BorderSide(width: 2)),
                      focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0)), borderSide: BorderSide(width: 2)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  PreferredSize(preferredSize: const Size.fromRadius(20), child: CircleAvatar(backgroundColor: grey.withOpacity(.2), child: const Icon(FontAwesomeIcons.userDoctor, size: 18))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                      child: const Center(child: CustomizedText(text: "Doctors", fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection("users").where("role", isEqualTo: "doctor").limit(10).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.hasData) {
                      final List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshot.data!.docs;
                      return StatefulBuilder(
                        key: _doctorsKey,
                        builder: (BuildContext context, void Function(void Function()) _) {
                          final List<Map<String, dynamic>> users = data.where((QueryDocumentSnapshot<Map<String, dynamic>> element) => element.get("name").contains(_searchController.text.trim())).map((QueryDocumentSnapshot<Map<String, dynamic>> e) => e.data()).toList();
                          users.sort((Map<String, dynamic> a, Map<String, dynamic> b) => a["name"].compareTo(b["name"]));
                          if (users.isNotEmpty) {
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: users.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () async => showDialog(context: context, builder: (BuildContext context) => Delete(userData: users[index])),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(children: <Widget>[CircleAvatar(radius: 20, backgroundColor: grey.withOpacity(.3), child: const Icon(FontAwesomeIcons.user, size: 15)), const SizedBox(width: 10), CustomizedText(text: users[index]["name"], fontSize: 18)]),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: <Widget>[LottieBuilder.asset("assets/lottie/notFound.json"), const SizedBox(height: 20), const Center(child: CustomizedText(text: "No users yet.", fontSize: 18))]));
                          }
                        },
                      );
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: blue));
                    } else {
                      return ErrorRoom(error: snapshot.error.toString());
                    }
                  },
                ),
              ),
              LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) => AnimatedContainer(duration: 700.ms, height: MediaQuery.of(context).padding.bottom > 0 ? 40 : 20)),
            ],
          ),
        ),
      ),
    );
  }
}
