import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/screens/admin/charts/diseases.dart';
import 'package:smart_care/stuff/globals.dart';

import '../../error/error_room.dart';
import '../../stuff/classes.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _patientsKey = GlobalKey();
  final GlobalKey _doctorsKey = GlobalKey();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: darkBlue,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection("users").limit(10).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              final List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshot.data!.docs;
              data.sort((QueryDocumentSnapshot<Map<String, dynamic>> a, QueryDocumentSnapshot<Map<String, dynamic>> b) => a.get("name").compareTo(b.get("name")));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 30),
                  Row(children: const <Widget>[Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), SizedBox(width: 50)]),
                  Row(children: const <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
                  const SizedBox(height: 10),
                  const CustomizedText(text: "Dashboard", fontSize: 25, fontWeight: FontWeight.bold, color: white),
                  const SizedBox(height: 20),
                  StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return TextField(
                        controller: _searchController,
                        onChanged: (String text) {
                          _doctorsKey.currentState!.setState(() {});
                          _patientsKey.currentState!.setState(() {});
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search, color: grey),
                          suffixIcon: _searchController.text.isEmpty
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.clear, color: grey),
                                  onPressed: () {
                                    _(() => _searchController.clear());
                                  },
                                ),
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
                  Expanded(
                    child: StatefulBuilder(
                      key: _patientsKey,
                      builder: (BuildContext context, void Function(void Function()) _) {
                        return SingleChildScrollView(
                          child: CommentTreeWidget<String, Map<String, dynamic>>(
                            "Patients",
                            data.where((QueryDocumentSnapshot<Map<String, dynamic>> element) => element.get("role") == "patient" && element.get("name").contains(_searchController.text.trim())).map((QueryDocumentSnapshot<Map<String, dynamic>> e) => e.data()).toList(),
                            treeThemeData: const TreeThemeData(lineColor: blue, lineWidth: 1),
                            avatarRoot: (BuildContext context, String _) => PreferredSize(preferredSize: const Size.fromRadius(20), child: CircleAvatar(backgroundColor: grey.withOpacity(.2), child: const Icon(FontAwesomeIcons.userInjured, color: grey, size: 18))),
                            contentRoot: (BuildContext context, String _) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                              decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                              child: Center(child: CustomizedText(text: _, fontSize: 14, fontWeight: FontWeight.bold, color: white)),
                            ),
                            avatarChild: (BuildContext context, Map<String, dynamic> _) => PreferredSize(
                              preferredSize: const Size.fromRadius(20),
                              child: CircleAvatar(
                                backgroundColor: grey.withOpacity(.2),
                                backgroundImage: _["image_url"] == noUser ? null : CachedNetworkImageProvider(_["image_url"]),
                                child: _["image_url"] != noUser ? null : const Icon(FontAwesomeIcons.user, color: grey, size: 18),
                              ),
                            ),
                            contentChild: (BuildContext context, Map<String, dynamic> _) {
                              return GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.all(8.0), child: CustomizedText(text: _["name"], color: white, fontSize: 18)));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: StatefulBuilder(
                      key: _doctorsKey,
                      builder: (BuildContext context, void Function(void Function()) _) {
                        return SingleChildScrollView(
                          child: CommentTreeWidget<String, Map<String, dynamic>>(
                            "Doctors",
                            data.where((QueryDocumentSnapshot<Map<String, dynamic>> element) => element.get("role") == "doctor" && element.get("name").contains(_searchController.text.trim())).map((QueryDocumentSnapshot<Map<String, dynamic>> e) => e.data()).toList(),
                            treeThemeData: const TreeThemeData(lineColor: blue, lineWidth: 1),
                            avatarRoot: (BuildContext context, String _) => PreferredSize(preferredSize: const Size.fromRadius(20), child: CircleAvatar(backgroundColor: grey.withOpacity(.2), child: const Icon(FontAwesomeIcons.userDoctor, color: grey, size: 18))),
                            contentRoot: (BuildContext context, String _) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                              decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                              child: Center(child: CustomizedText(text: _, fontSize: 14, fontWeight: FontWeight.bold, color: white)),
                            ),
                            avatarChild: (BuildContext context, Map<String, dynamic> _) => PreferredSize(
                              preferredSize: const Size.fromRadius(20),
                              child: CircleAvatar(
                                backgroundColor: grey.withOpacity(.2),
                                backgroundImage: _["image_url"] == noUser ? null : CachedNetworkImageProvider(_["image_url"]),
                                child: _["image_url"] != noUser ? null : const Icon(FontAwesomeIcons.user, color: grey, size: 18),
                              ),
                            ),
                            contentChild: (BuildContext context, Map<String, dynamic> _) {
                              return GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.all(8.0), child: CustomizedText(text: _["name"], color: white, fontSize: 18)));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const DiseasesTracker() /*const BloodTypeTracker() */ /*const DoctorsPerSpeciality()*/));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5)),
                        child: const CustomizedText(text: "Go To Dashboard", color: white, fontSize: 18),
                      ),
                    ),
                  ),
                  LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) => SizedBox(height: MediaQuery.of(context).padding.bottom > 0 ? 100 : 80)),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const ListTileShimmer();
            } else {
              return ErrorRoom(error: snapshot.error.toString());
            }
          },
        ),
      ),
    );
  }
}
