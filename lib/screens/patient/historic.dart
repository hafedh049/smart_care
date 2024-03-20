import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_tree/comment_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/utils/classes.dart';
import 'package:smart_care/utils/callbacks.dart';
import 'package:smart_care/utils/globals.dart';
import 'package:http/http.dart';

import 'filled_form_template.dart';

class Historic extends StatefulWidget {
  const Historic({super.key});

  @override
  State<Historic> createState() => _HistoricState();
}

class _HistoricState extends State<Historic> {
  final Map<String, String> _collections = const <String, String>{
    "Filled Forms": "filled_forms",
    "Blood Tests": "blood_tests",
    "Prescriptions": "prescriptions",
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
              const Row(children: <Widget>[Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), SizedBox(width: 50)]),
              const Row(children: <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
              const SizedBox(height: 10),
              CommentTreeWidget<String, Map<String, dynamic>>(
                me["name"],
                const <Map<String, dynamic>>[
                  <String, dynamic>{"avatar": FontAwesomeIcons.squareCheck, "child": "Filled Forms"},
                  <String, dynamic>{"avatar": FontAwesomeIcons.prescription, "child": "Prescriptions"},
                  <String, dynamic>{"avatar": FontAwesomeIcons.vial, "child": "Blood Tests"}
                ],
                treeThemeData: const TreeThemeData(lineColor: blue, lineWidth: 1),
                avatarRoot: (BuildContext context, String avatarRoot) => PreferredSize(
                  preferredSize: const Size.fromRadius(20),
                  child: CircleAvatar(
                    backgroundColor: grey.withOpacity(.2),
                    backgroundImage: me["image_url"] == noUser ? null : CachedNetworkImageProvider(me["image_url"]),
                    child: me["image_url"] != noUser ? null : const Icon(FontAwesomeIcons.user, size: 18, color: blue),
                  ),
                ),
                contentRoot: (BuildContext context, String contentRoot) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                  child: Center(child: CustomizedText(text: me["name"], fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                avatarChild: (BuildContext context, Map<String, dynamic> avatarChild) => PreferredSize(
                  preferredSize: const Size.fromRadius(20),
                  child: CircleAvatar(backgroundColor: grey.withOpacity(.2), child: Icon(avatarChild["avatar"]!, size: 18, color: blue)),
                ),
                contentChild: (BuildContext context, Map<String, dynamic> contentChild) {
                  bool expanded = false;
                  return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance.collection(_collections[contentChild["child"]!]!).where("uid", isEqualTo: me["uid"]).get(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (!snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: CustomizedText(text: contentChild["child"]!, fontSize: 16, fontWeight: FontWeight.bold),
                        );
                      } else if (snapshot.hasData) {
                        final List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshot.data!.docs;
                        data.sort((QueryDocumentSnapshot<Map<String, dynamic>> a, QueryDocumentSnapshot<Map<String, dynamic>> b) => a.get("timestamp").toDate().millisecondsSinceEpoch > b.get("timestamp").toDate().millisecondsSinceEpoch ? 1 : -1);
                        return StatefulBuilder(
                          builder: (BuildContext context, void Function(void Function()) _) {
                            return GestureDetector(
                              onTap: () => _(() => expanded = !expanded),
                              child: AnimatedContainer(
                                duration: 300.ms,
                                decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        CustomizedText(text: contentChild["child"]!, fontSize: 16, fontWeight: FontWeight.bold),
                                        const Spacer(),
                                        Icon(expanded ? FontAwesomeIcons.chevronDown : FontAwesomeIcons.chevronLeft, size: 15),
                                      ],
                                    ),
                                    Visibility(
                                      visible: expanded,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const SizedBox(height: 10),
                                          for (int index = 0; index < data.length; index++)
                                            GestureDetector(
                                              onTap: () async {
                                                if (contentChild["child"] == "Filled Forms") {
                                                  try {
                                                    final pw.Document pdfDoc = pw.Document();
                                                    pdfDoc.addPage(pw.Page(build: (pw.Context context) => FormTemplate(data: data[index].get("choices")), pageFormat: PdfPageFormat.legal));
                                                    showToast(text: "Opening File...");
                                                    final path = await getTemporaryDirectory().then((Directory dir) async {
                                                      final file = File('${dir.path}/example.pdf');
                                                      return file.writeAsBytes(await pdfDoc.save()).then((void _) => file.path);
                                                    });
                                                    await OpenFilex.open(path);
                                                  } catch (e) {
                                                    showToast(text: 'Error opening PDF: $e');
                                                  }
                                                } else {
                                                  try {
                                                    final bytes = await get(Uri.parse(data[index].get('url')));
                                                    final path = await getTemporaryDirectory().then((Directory dir) {
                                                      final file = File('${dir.path}/example.pdf');
                                                      return file.writeAsBytes(bytes.bodyBytes).then((void _) => file.path);
                                                    });
                                                    await OpenFilex.open(path, type: bytes.headers['content-type']);
                                                  } catch (e) {
                                                    showToast(text: 'Error opening PDF: $e');
                                                  }
                                                }
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(8),
                                                margin: const EdgeInsets.only(bottom: 8),
                                                decoration: BoxDecoration(color: grey.withOpacity(.1), borderRadius: BorderRadius.circular(5)),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5)), width: 1, height: 60),
                                                    const SizedBox(width: 10),
                                                    Icon(
                                                      contentChild["child"] == "Blood Tests"
                                                          ? FontAwesomeIcons.filePdf
                                                          : contentChild["child"] == "Filled Forms"
                                                              ? FontAwesomeIcons.f
                                                              : FontAwesomeIcons.slack,
                                                      size: 35,
                                                      color: blue,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: <Widget>[
                                                          CustomizedText(text: "${contentChild["child"]!.substring(0, contentChild["child"]!.length - 1)} ${index + 1}", fontSize: 16, fontWeight: FontWeight.bold),
                                                          const SizedBox(height: 5),
                                                          CustomizedText(text: getTimeFromDate(data[index].get("timestamp").toDate()), fontSize: 12, color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.8)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTileShimmer();
                      } else {
                        return ErrorRoom(error: snapshot.error.toString());
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
