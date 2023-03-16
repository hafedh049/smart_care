import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/chat_room.dart';
import 'package:smart_care/stuff/globals.dart';

import '../../stuff/classes.dart';

class FilterList extends StatefulWidget {
  const FilterList({super.key});

  @override
  State<FilterList> createState() => _FilterListState();
}

class _FilterListState extends State<FilterList> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _xKey = GlobalKey();
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
                  onTap: () => Navigator.pop(context),
                  child: const Icon(FontAwesomeIcons.chevronLeft, size: 20),
                ),
              ),
              Expanded(
                child: TextField(
                  focusNode: _filterNode,
                  controller: _searchController,
                  onChanged: (String value) => _xKey.currentState!.setState(() => _showClearButton = value.isEmpty ? false : true),
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
                        _searchController.clear();
                        _showClearButton = false;
                      }),
                      child: const Padding(padding: EdgeInsets.only(left: 8, right: 8), child: Icon(Icons.clear)),
                    ),
                  );
                },
              ),
              Container(width: 5, height: 48, decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(35)), color: blue)),
            ],
          ),
          const SizedBox(height: 10),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection("health_care_professionals").where("role", isEqualTo: "doctor").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                List<QueryDocumentSnapshot<Map<String, dynamic>>> doctorsList = snapshot.data!.docs;
                if (doctorsList.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                      itemCount: doctorsList.length,
                      itemBuilder: (BuildContext context, int index) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChatRoom(talkTo: doctorsList[index].data()))),
                        leading: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ,)),
                              child: CircleAvatar(radius: 25, backgroundImage: CachedNetworkImageProvider(doctorsList[index].get("image_url"))),
                            ),
                            CircleAvatar(radius: 5, backgroundColor: doctorsList[index].get("status") ? green : red),
                          ],
                        ),
                        title: CustomizedText(text: doctorsList[index].get("medical_professional_name"), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                } else {
                  return Center(child: CustomizedText(text: "No Doctors Available", color: white, fontSize: 25, fontWeight: FontWeight.bold));
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(child: ListView.builder(itemCount: 30, itemBuilder: (BuildContext context, int index) => const ListTileShimmer()));
              } else {
                return ErrorRoom(error: snapshot.error.toString());
              }
            },
          )
        ],
      ),
    );
  }
}
