import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/chat_room.dart';
import 'package:smart_care/screens/doctor/about_doctor.dart';
import 'package:smart_care/stuff/globals.dart';

import '../../stuff/classes.dart';
import '../../stuff/functions.dart';

class FilterList extends StatefulWidget {
  const FilterList({super.key});

  @override
  State<FilterList> createState() => _FilterListState();
}

class _FilterListState extends State<FilterList> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _xKey = GlobalKey();
  final FocusNode _filterNode = FocusNode();
  final GlobalKey _filterKey = GlobalKey();
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
    return Scaffold(
      backgroundColor: darkBlue,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: GestureDetector(
                  onTap: () {
                    if (play == 1) {
                      playNote("tap.wav");
                    }
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
                  decoration: const InputDecoration(hintText: 'Search For Doctors', border: InputBorder.none, contentPadding: EdgeInsets.only(left: 8, right: 8)),
                ),
              ),
              StatefulBuilder(
                key: _xKey,
                builder: (BuildContext context, void Function(void Function()) setS) {
                  return Visibility(
                    visible: _showClearButton,
                    child: GestureDetector(
                      onTap: () => setS(() {
                        if (play == 1) {
                          playNote("tap.wav");
                        }
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
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection("users").where("roles_list", arrayContains: "doctor").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> doctorsList = snapshot.data!.docs.where((QueryDocumentSnapshot<Map<String, dynamic>> element) => element.get("uid") != me["uid"] && element.get("name").contains(_searchController.text.trim())).toList();
                    if (doctorsList.isNotEmpty) {
                      return Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                          itemCount: doctorsList.length,
                          itemBuilder: (BuildContext context, int index) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChatRoom(talkTo: doctorsList[index].data())));
                            },
                            leading: Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    if (play == 1) {
                                      playNote("tap.wav");
                                    }
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AboutDoctor(uid: doctorsList[index].get("uid"))));
                                  },
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: grey.withOpacity(.2),
                                    backgroundImage: doctorsList[index].get("image_url") == noUser ? null : CachedNetworkImageProvider(doctorsList[index].get("image_url")),
                                    child: doctorsList[index].get("image_url") == noUser ? const Icon(FontAwesomeIcons.user, size: 15, color: grey) : null,
                                  ),
                                ),
                                CircleAvatar(radius: 5, backgroundColor: doctorsList[index].get("status") ? green : red),
                              ],
                            ),
                            title: CustomizedText(text: doctorsList[index].get("name"), fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    } else {
                      return const Expanded(child: Center(child: CustomizedText(text: "No Doctors Available", color: white, fontSize: 25, fontWeight: FontWeight.bold)));
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
    );
  }
}
