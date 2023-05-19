import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_care/error/error_room.dart';

import '../../stuff/classes.dart';
import '../../stuff/functions.dart';
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
              Row(children: <Widget>[GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronLeft, size: 15, color: grey))), const Spacer(), const CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
              const Row(children: <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
              const SizedBox(height: 10),
              StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) _) {
                  return TextField(
                    controller: _searchController,
                    onChanged: (String text) => _doctorsKey.currentState!.setState(() {}),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: grey),
                      suffixIcon: _searchController.text.isEmpty ? null : IconButton(icon: const Icon(Icons.clear, color: grey), onPressed: () => _(() => _searchController.clear())),
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: grey),
                      filled: true,
                      fillColor: white.withOpacity(.2),
                      enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0)), borderSide: BorderSide(color: white, width: 2)),
                      focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0)), borderSide: BorderSide(color: white, width: 2)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  PreferredSize(preferredSize: const Size.fromRadius(20), child: CircleAvatar(backgroundColor: grey.withOpacity(.2), child: const Icon(FontAwesomeIcons.userDoctor, color: grey, size: 18))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                      decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                      child: const Center(child: CustomizedText(text: "Doctors", fontSize: 14, fontWeight: FontWeight.bold, color: white)),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance.collection("users").where("role", isEqualTo: "doctor").get(),
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
                                return Dismissible(
                                  key: ValueKey<String>(users[index]["uid"]),
                                  confirmDismiss: (DismissDirection direction) async => direction == DismissDirection.startToEnd ? true : false,
                                  onDismissed: (DismissDirection direction) async {
                                    if (direction == DismissDirection.startToEnd) {
                                      await FirebaseFirestore.instance.collection("users").doc(users[index]["uid"]).delete().then((void value) async {
                                        await FirebaseStorage.instance.ref().child("/profile_pictures/${users[index]["uid"]}").delete().then((void value) async {
                                          await FirebaseStorage.instance.ref().child("/prescriptions/${users[index]["uid"]}/").delete().then((void value) async {
                                            await FirebaseStorage.instance.ref().child("/blood_tests/${users[index]["uid"]}/").delete().then((void value) {
                                              data.removeAt(index);
                                              showToast(text: "User Deleted");
                                              if (data.isEmpty) {
                                                _(() {});
                                              }
                                            });
                                          });
                                        });
                                      });
                                    }
                                  },
                                  secondaryBackground: Container(color: green, child: const Icon(FontAwesomeIcons.idBadge)),
                                  background: Container(color: red, child: const Icon(FontAwesomeIcons.trash)),
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        CircleAvatar(radius: 20, backgroundColor: grey.withOpacity(.3), child: Icon(FontAwesomeIcons.user, size: 15, color: white.withOpacity(.3))),
                                        const SizedBox(width: 10),
                                        CustomizedText(text: users[index]["name"], fontSize: 18),
                                      ],
                                    ),
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
