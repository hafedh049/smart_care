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
      onTap: () {
        FocusScope.of(context).unfocus();
      },
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
                  children: <Widget>[
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
                                _deleteTextKey.currentState!.setState(() => _deleteVisibility = true);
                              } else {
                                _deleteVisibility = false;
                              }
                            },
                            controller: _searchController,
                            style: GoogleFonts.roboto(color: white),
                            decoration: InputDecoration(hintText: 'searchForADoctor'.tr, hintStyle: GoogleFonts.roboto(color: grey), border: InputBorder.none),
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
                  future: FirebaseFirestore.instance.collection("chats").doc(me["uid"]).collection("messages").get(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> chatSnapshot) {
                    if (chatSnapshot.hasData) {
                      if (chatSnapshot.data!.docs.isEmpty) {
                        return Center(child: CustomizedText(text: 'noPatientsAvailable'.tr, color: blue, fontSize: 20));
                      } else {
                        Future.delayed(500.ms, () => _textFieldKey.currentState!.setState(() => _disabled = false));
                        return StatefulBuilder(
                          key: _searchKey,
                          builder: (BuildContext context, void Function(void Function()) _) {
                            final List<QueryDocumentSnapshot<Map<String, dynamic>>> patientsList = chatSnapshot.data!.docs;
                            return patientsList.isEmpty
                                ? Center(child: CustomizedText(text: 'noChatsUntilNow'.tr, fontSize: 20, color: white))
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    itemCount: patientsList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                        stream: FirebaseFirestore.instance.collection("users").doc(patientsList[index].id.replaceAll(" ", "")).snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> tileSnapshot) {
                                          if (tileSnapshot.hasData) {
                                            return ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              onTap: () => goTo(ChatRoom(talkTo: tileSnapshot.data!.data()!)),
                                              leading: Stack(
                                                alignment: AlignmentDirectional.bottomEnd,
                                                children: <Widget>[
                                                  CircleAvatar(radius: 25, backgroundColor: grey.withOpacity(.2), backgroundImage: tileSnapshot.data!.get("image_url") == noUser ? null : CachedNetworkImageProvider(tileSnapshot.data!.get("image_url")), child: tileSnapshot.data!.get("image_url") == noUser ? const Icon(FontAwesomeIcons.user, size: 18, color: grey) : null),
                                                  CircleAvatar(radius: 5, backgroundColor: tileSnapshot.data!.get("status") ? green : red),
                                                ],
                                              ),
                                              title: CustomizedText(text: tileSnapshot.data!.get("name"), fontSize: 16, fontWeight: FontWeight.bold),
                                              subtitle: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                                stream: FirebaseFirestore.instance.collection("chats").doc(me["uid"]).collection("messages").doc(patientsList[index].id).snapshots(),
                                                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                                  return CustomizedText(
                                                    text: snapshot.hasData
                                                        ? snapshot.data!.exists
                                                            ? snapshot.data != null
                                                                ? snapshot.data!.get("last_message")["message"]
                                                                : "No messages yet"
                                                            : "No messages yet"
                                                        : snapshot.connectionState == ConnectionState.waiting
                                                            ? "..."
                                                            : snapshot.error.toString(),
                                                    fontSize: 14,
                                                    color: white.withOpacity(.7),
                                                  );
                                                },
                                              ),
                                              trailing: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                                stream: FirebaseFirestore.instance.collection("chats").doc(me["uid"]).collection("messages").doc(patientsList[index].id).snapshots(),
                                                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                                  return CustomizedText(
                                                    text: snapshot.hasData
                                                        ? snapshot.data!.exists
                                                            ? snapshot.data != null
                                                                ? getTimeFromDate(snapshot.data!.get("last_message")["timestamp"].toDate())
                                                                : ""
                                                            : ""
                                                        : snapshot.connectionState == ConnectionState.waiting
                                                            ? ""
                                                            : snapshot.error.toString(),
                                                    fontSize: 14,
                                                    color: white.withOpacity(.7),
                                                  );
                                                },
                                              ),
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
