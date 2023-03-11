import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/chat_room.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _textFieldKey = GlobalKey();
  bool _disabled = true;
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
        backgroundColor: darkBlue,
        resizeToAvoidBottomInset: false,
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
              Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
              Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), const SizedBox(width: 30)]),
              const SizedBox(height: 10),
              Container(
                height: 50,
                margin: const EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(color: grey.withOpacity(.1), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.search, color: grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatefulBuilder(
                        key: _textFieldKey,
                        builder: (BuildContext context, void Function(void Function()) _) {
                          return TextField(
                            readOnly: _disabled,
                            onChanged: (String value) {
                              _searchKey.currentState!.setState(() {});
                            },
                            controller: _searchController,
                            style: GoogleFonts.roboto(color: white),
                            decoration: InputDecoration(hintText: 'Search Doctors', hintStyle: GoogleFonts.roboto(color: grey), border: InputBorder.none),
                          );
                        },
                      ),
                    ),
                    IconButton(icon: Icon(Icons.close, color: grey), onPressed: () => _searchController.clear()),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection("health_care_professionals").where("role", isEqualTo: "doctor").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(child: CustomizedText(text: "No Doctors Yet", color: blue, fontSize: 20));
                      } else {
                        Future.delayed(500.ms, () => _textFieldKey.currentState!.setState(() => _disabled = false));
                        return StatefulBuilder(
                          key: _searchKey,
                          builder: (BuildContext context, void Function(void Function()) _) {
                            final List<QueryDocumentSnapshot<Map<String, dynamic>>> doctorsList = snapshot.data!.docs
                                .where((
                                  QueryDocumentSnapshot<Map<String, dynamic>> item,
                                ) =>
                                    item.get("medical_professional_name").toLowerCase().contains(_searchController.text.trim().toLowerCase()))
                                .toList();
                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              itemCount: doctorsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChatRoom(talkTo: doctorsList[index].data()))),
                                  child: Row(
                                    children: <Widget>[
                                      Stack(
                                        alignment: AlignmentDirectional.bottomEnd,
                                        children: <Widget>[
                                          CircleAvatar(radius: 25, backgroundImage: CachedNetworkImageProvider(doctorsList[index].get("image_url"))),
                                          CircleAvatar(radius: 5, backgroundColor: doctorsList[index].get("status") ? green : red),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          CustomizedText(text: doctorsList[index].get("medical_professional_name"), fontSize: 16, fontWeight: FontWeight.bold),
                                          CustomizedText(text: doctorsList[index].get("last_message").firstWhere((dynamic element) => element["sender"] == doctorsList[index].get("uid") || element["sender"] == FirebaseAuth.instance.currentUser!.uid)["message"], fontSize: 14, color: white.withOpacity(.7)),
                                        ],
                                      ),
                                      const Spacer(),
                                      CustomizedText(text: getTimeFromDate(doctorsList[index].get("last_message").firstWhere((dynamic element) => element["sender"] == doctorsList[index].get("uid") || element["sender"] == FirebaseAuth.instance.currentUser!.uid)["timestamp"].toDate()), fontSize: 14, color: white.withOpacity(.7)),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        itemCount: 20,
                        itemBuilder: (BuildContext context, int index) => const ListTileShimmer(),
                      );
                    } else {
                      return ErrorRoom(error: snapshot.error.toString());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
