import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
        title: CustomizedText(text: "Chat Room", fontSize: 16, color: blue, fontWeight: FontWeight.bold),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search, color: blue, size: 20)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
            Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
            Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), const SizedBox(width: 30)]),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection("health_care_professionals").where("role", isEqualTo: "doctor").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    final List<QueryDocumentSnapshot<Map<String, dynamic>>> doctorsList = snapshot.data!.docs;
                    if (doctorsList.isEmpty) {
                      return Center(child: CustomizedText(text: "No Doctors Yet", color: blue, fontSize: 20));
                    } else {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        itemCount: doctorsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ChatRoom())),
                            contentPadding: EdgeInsets.zero,
                            leading: Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: <Widget>[
                                CircleAvatar(radius: 25, backgroundImage: CachedNetworkImageProvider(doctorsList[index].get("image_url"))),
                                CircleAvatar(radius: 5, backgroundColor: doctorsList[index].get("status") ? green : red),
                              ],
                            ),
                            title: CustomizedText(text: doctorsList[index].get("medical_professional_name"), fontSize: 16, fontWeight: FontWeight.bold),
                            subtitle: CustomizedText(text: doctorsList[index].get("last_message").firstWhere((dynamic element) => element["sender"] == doctorsList[index].get("uid") || element["sender"] == FirebaseAuth.instance.currentUser!.uid)["message"], fontSize: 14),
                            trailing: CustomizedText(text: getTimeFromDate(doctorsList[index].get("last_message").firstWhere((dynamic element) => element["sender"] == doctorsList[index].get("uid") || element["sender"] == FirebaseAuth.instance.currentUser!.uid)["timestamp"].toDate()), fontSize: 14),
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
    );
  }
}
