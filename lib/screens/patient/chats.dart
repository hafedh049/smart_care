import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
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
  final GlobalKey _deleteTextKey = GlobalKey();
  bool _disabled = true;
  bool _deleteVisibility = false;
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
            children: <Widget>[
              Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
              const Row(children: <Widget>[Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), SizedBox(width: 50)]),
              const Row(children: <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
              const SizedBox(height: 10),
              Container(
                height: 50,
                margin: const EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(color: grey.withOpacity(.1), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    const Icon(Icons.search, color: grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatefulBuilder(
                        key: _textFieldKey,
                        builder: (BuildContext context, void Function(void Function()) _) {
                          return TextField(
                            readOnly: _disabled,
                            onChanged: (String value) {
                              _searchKey.currentState!.setState(() {});
                              if (_searchController.text.isNotEmpty) {
                                _deleteTextKey.currentState!.setState(() {
                                  _deleteVisibility = true;
                                });
                              } else {
                                _deleteVisibility = false;
                              }
                            },
                            controller: _searchController,
                            style: GoogleFonts.roboto(color: white),
                            decoration: InputDecoration(hintText: 'searchForDoctors'.tr, hintStyle: GoogleFonts.roboto(color: grey), border: InputBorder.none),
                          );
                        },
                      ),
                    ),
                    StatefulBuilder(key: _deleteTextKey, builder: (BuildContext context, void Function(void Function()) _) => Visibility(visible: _deleteVisibility, child: IconButton(icon: const Icon(Icons.close, color: grey), onPressed: () => _searchController.clear()))),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance.collection("chats").where("participants", arrayContains: me["uid"]).get(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> chatSnapshot) {
                    if (chatSnapshot.hasData) {
                      if (chatSnapshot.data!.docs.isEmpty) {
                        return const Center(child: CustomizedText(text: "No doctors available now.", color: blue, fontSize: 20));
                      } else {
                        Future.delayed(500.ms, () => _textFieldKey.currentState!.setState(() => _disabled = false));
                        return StatefulBuilder(
                          key: _searchKey,
                          builder: (BuildContext context, void Function(void Function()) _) {
                            final List<QueryDocumentSnapshot<Map<String, dynamic>>> doctorsList = chatSnapshot.data!.docs.where((QueryDocumentSnapshot<Map<String, dynamic>> element) {
                              final List<dynamic> namesList = element.get("names");
                              namesList.remove(me["name"]);
                              return namesList.first.toLowerCase().contains(_searchController.text.toLowerCase().trim());
                            }).toList();
                            return doctorsList.isEmpty
                                ? Center(child: CustomizedText(text: 'noChatsUntilNow'.tr, fontSize: 20, color: white))
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    itemCount: doctorsList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final List<dynamic> uidsList = doctorsList[index].get("participants");
                                      uidsList.remove(me["uid"]);
                                      return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                        future: FirebaseFirestore.instance.collection("users").doc(uidsList.first).get(),
                                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> tileSnapshot) {
                                          if (tileSnapshot.hasData) {
                                            return ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              onTap: () => goTo(ChatRoom(talkTo: tileSnapshot.data!.data()!)),
                                              leading: Stack(
                                                alignment: AlignmentDirectional.bottomEnd,
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage: tileSnapshot.data!.get("image_url") == noUser ? null : CachedNetworkImageProvider(tileSnapshot.data!.get("image_url")),
                                                    backgroundColor: grey.withOpacity(.2),
                                                    child: tileSnapshot.data!.get("image_url") != noUser ? null : const Icon(FontAwesomeIcons.user, color: grey, size: 25),
                                                  ),
                                                  CircleAvatar(radius: 5, backgroundColor: tileSnapshot.data!.get("status") ? green : red),
                                                ],
                                              ),
                                              title: CustomizedText(text: tileSnapshot.data!.get("name"), fontSize: 16, fontWeight: FontWeight.bold),
                                              subtitle: SizedBox(height: 40, child: CustomizedText(text: doctorsList[index].get("last_message")["message"], fontSize: 14, color: white.withOpacity(.7))),
                                              trailing: CustomizedText(text: getTimeFromDate(doctorsList[index].get("last_message")["timestamp"].toDate()), fontSize: 14, color: white.withOpacity(.7)),
                                            );
                                          } else if (tileSnapshot.connectionState == ConnectionState.waiting) {
                                            return const ListTileShimmer();
                                          } else {
                                            return ErrorRoom(error: tileSnapshot.error.toString());
                                          }
                                        },
                                      );
                                    },
                                  );
                          },
                        );
                      }
                    } else if (chatSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: blue));
                    } else {
                      return ErrorRoom(error: chatSnapshot.error.toString());
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
