import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/article.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../stuff/classes.dart';

class Articles extends StatefulWidget {
  const Articles({super.key});

  @override
  State<Articles> createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  final GlobalKey _typeKey = GlobalKey();
  final List<String> _types = const <String>["All", "Politics", "Sport", "Education", "Health", "World", "Gaming", "Astronomy"];
  String _type = "All";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: darkBlue,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.only(top: 36.0),
                decoration: BoxDecoration(color: dark, borderRadius: BorderRadius.circular(5)),
                child: const Icon(FontAwesomeIcons.chevronLeft, size: 25, color: white),
              ),
            ),
            const SizedBox(height: 30),
            CustomizedText(text: AppLocalizations.of(context)!.discover, color: white, fontSize: 24, fontWeight: FontWeight.bold),
            const SizedBox(height: 10),
            CustomizedText(text: AppLocalizations.of(context)!.newsfromallarroundtheworld, color: white.withOpacity(.6), fontSize: 14),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) _) {
                  return Row(
                    children: <Widget>[
                      for (String type in _types)
                        GestureDetector(
                          onTap: () {
                            if (_type != type) {
                              _(() => _typeKey.currentState!.setState(() => _type = type));
                            }
                          },
                          child: AnimatedContainer(
                            duration: 500.ms,
                            margin: const EdgeInsets.only(right: 12.0),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: _type == type ? blue : grey),
                            child: CustomizedText(text: type, color: white, fontSize: 16),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection("articles").orderBy("publishedAt", descending: true).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    return StatefulBuilder(
                      key: _typeKey,
                      builder: (BuildContext context, void Function(void Function()) _) {
                        final List<QueryDocumentSnapshot<Map<String, dynamic>>> articles = snapshot.data!.docs.where((QueryDocumentSnapshot<Map<String, dynamic>> article) => article.get("topic").contains(_type == "All" ? "" : _type)).toList();
                        if (articles.isNotEmpty) {
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: articles.length,
                            itemBuilder: (BuildContext context, int index) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: GestureDetector(
                                onTap: () {
                                  goTo(Article(article: articles[index].data()));
                                  //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Article(article: articles[index].data())));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 90,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(image: CachedNetworkImageProvider(articles[index].get("urlToImage")), fit: BoxFit.cover),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue.withOpacity(.2)),
                                            child: CustomizedText(text: articles[index].get("topic"), color: white, fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          CustomizedText(text: articles[index].get("title"), color: white, fontSize: 18, fontWeight: FontWeight.bold),
                                          CustomizedText(text: getDateRepresentation(DateTime.parse(articles[index].get("publishedAt"))), color: white.withOpacity(.8), fontSize: 14),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Center(child: CustomizedText(text: AppLocalizations.of(context)!.noArticlesYet, color: white, fontSize: 18, fontWeight: FontWeight.bold));
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
            )
          ],
        ),
      ),
    );
  }
}
