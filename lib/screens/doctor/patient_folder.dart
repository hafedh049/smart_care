import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_care/stuff/globals.dart';

import '../../error/error_room.dart';
import '../../stuff/classes.dart';
import '../../stuff/functions.dart';

class PatientFolder extends StatefulWidget {
  const PatientFolder({super.key, required this.collection, required this.patientId, required this.icon});
  final String patientId;
  final String collection;
  final IconData icon;

  @override
  State<PatientFolder> createState() => _PatientFolderState();
}

class _PatientFolderState extends State<PatientFolder> {
  final TextEditingController _medicalGuideController = TextEditingController();

  final Map<String, String> _collections = const <String, String>{
    "Filled Forms": "filled_forms",
    "Blood Tests": "blood_tests",
    "Prescriptions": "prescriptions",
  };

  @override
  void dispose() {
    _medicalGuideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
                Row(
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        icon: const Icon(FontAwesomeIcons.chevronLeft, size: 15)),
                    const Spacer(),
                    const CircleAvatar(radius: 12, backgroundColor: blue),
                    const SizedBox(width: 50)
                  ],
                ),
                const Row(children: <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
                const SizedBox(height: 10),
                CommentTreeWidget<String, String>(
                  "",
                  const <String>[""],
                  treeThemeData: const TreeThemeData(lineColor: blue, lineWidth: 1),
                  avatarRoot: (BuildContext context, String _) => PreferredSize(
                    preferredSize: const Size.fromRadius(20),
                    child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance.collection("users").doc(widget.patientId).get(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                        if (snapshot.hasData) {
                          return CircleAvatar(backgroundColor: grey.withOpacity(.2), backgroundImage: snapshot.data!.get("image_url") == noUser ? null : CachedNetworkImageProvider(snapshot.data!.get("image_url")), child: snapshot.data!.get("image_url") != noUser ? null : const Icon(FontAwesomeIcons.user, color: grey, size: 18));
                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox();
                        } else {
                          return ErrorRoom(error: snapshot.error.toString());
                        }
                      },
                    ),
                  ),
                  contentRoot: (BuildContext context, String _) => FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance.collection("users").doc(widget.patientId).get(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.hasData) {
                        return Container(padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0), decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: CustomizedText(text: snapshot.data!.get("name"), fontSize: 16, fontWeight: FontWeight.bold));
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTileShimmer();
                      } else {
                        return ErrorRoom(error: snapshot.error.toString());
                      }
                    },
                  ),
                  avatarChild: (BuildContext context, String _) => PreferredSize(preferredSize: const Size.fromRadius(20), child: CircleAvatar(backgroundColor: grey.withOpacity(.2), child: Icon(widget.icon, size: 18))),
                  contentChild: (BuildContext context, String __) {
                    return AnimatedContainer(
                      duration: 300.ms,
                      decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                      child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance.collection(_collections[widget.collection]!).orderBy("timestamp", descending: true).get(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                          if (snapshot.hasData) {
                            final List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshot.data!.docs;
                            if (data.isEmpty) {
                              return Row(
                                children: <Widget>[
                                  CustomizedText(text: widget.collection, fontSize: 16, fontWeight: FontWeight.bold),
                                  const Spacer(),
                                  CustomizedText(text: "( ${'empty'.tr} )", fontSize: 16, fontWeight: FontWeight.bold),
                                ],
                              );
                            } else {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CustomizedText(text: widget.collection, fontSize: 16, fontWeight: FontWeight.bold),
                                  const SizedBox(height: 10),
                                  for (int index = 0; index < data.length; index++)
                                    GestureDetector(
                                      onLongPress: () {
                                        if (widget.collection == "Filled Forms") {
                                          _medicalGuideController.text = data[index].get("conduite_a_tenir");
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const CustomizedText(text: 'Modify Medical Guide'),
                                              content: TextField(controller: _medicalGuideController),
                                              actions: <Widget>[
                                                TextButton(child: const CustomizedText(text: 'Cancel', fontSize: 16), onPressed: () => Navigator.of(context).pop()),
                                                TextButton(
                                                  child: const CustomizedText(text: 'Confirm', fontSize: 16),
                                                  onPressed: () async {
                                                    await data[index].reference.update({"conduite_a_tenir": _medicalGuideController.text.trim()}).then((void value) => Navigator.of(context).pop());
                                                    sendPushNotificationFCM(token: data[index].get("token"), username: data[index].get("name"), message: "Doctor confirmed your medical guide");
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      onTap: () async {
                                        try {
                                          final bytes = await get(Uri.parse(data[index].get('prescriptionUrl')));
                                          final path = await getTemporaryDirectory().then((Directory dir) {
                                            final file = File('${dir.path}/example.pdf');
                                            return file.writeAsBytes(bytes.bodyBytes).then((void _) => file.path);
                                          });
                                          await OpenFilex.open(path);
                                        } catch (e) {
                                          showToast(text: 'Error opening PDF: $e', color: red);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        margin: const EdgeInsets.only(bottom: 8.0),
                                        decoration: BoxDecoration(color: grey.withOpacity(.1), borderRadius: BorderRadius.circular(5)),
                                        child: Row(
                                          children: <Widget>[
                                            Container(decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5)), width: 1, height: 60),
                                            const SizedBox(width: 10),
                                            const Icon(FontAwesomeIcons.filePdf, size: 35),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  CustomizedText(text: getTimeFromDate(data[index].get("timestamp").toDate()), fontSize: 12),
                                                  const SizedBox(height: 5),
                                                  Flexible(child: CustomizedText(text: "$index", fontSize: 16, fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }
                          } else if (snapshot.connectionState == ConnectionState.waiting) {
                            return const ListTileShimmer();
                          } else {
                            return ErrorRoom(error: snapshot.error.toString());
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
