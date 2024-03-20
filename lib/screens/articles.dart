import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/article.dart';
import 'package:smart_care/utils/callbacks.dart';
import 'package:smart_care/utils/globals.dart';
import 'package:http/http.dart' as http;

import '../utils/classes.dart';

class Articles extends StatefulWidget {
  const Articles({super.key});

  @override
  State<Articles> createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  Future<List<Map<String, dynamic>>> _fetchNews() async {
    String url = 'https://newsapi.org/v2/everything?q=healthcare&apiKey=$newsApiKey';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> articleData = data['articles'];
      List<Map<String, dynamic>> articles = [];
      for (Map<String, dynamic> article in articleData) {
        Map<String, dynamic> articleMap = {
          'title': article['title'],
          'description': article['description'],
          'url': article['url'],
          'urlToImage': article['urlToImage'],
          'content': article['content'],
          'author': article['author'],
          'publishedAt': article['publishedAt'],
        };
        articles.add(articleMap);
      }
      return articles;
    } else {
      return Future.error(response.reasonPhrase!);
    }
  }

  final GlobalKey _typeKey = GlobalKey();
  final List<String> _types = const <String>["All", "Health"];
  String _type = "All";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.only(top: 36), padding: const EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronLeft, size: 25))),
            const SizedBox(height: 30),
            CustomizedText(text: 'discover'.tr, fontSize: 24, fontWeight: FontWeight.bold),
            const SizedBox(height: 10),
            CustomizedText(text: 'newsfromallarroundtheworld'.tr, color: grey.withOpacity(.6), fontSize: 14),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) _) {
                  return Row(
                    children: <Widget>[
                      for (String type in _types)
                        GestureDetector(
                          onTap: () => _type != type ? _(() => _typeKey.currentState!.setState(() => _type = type)) : null,
                          child: AnimatedContainer(duration: 500.ms, margin: const EdgeInsets.only(right: 12), padding: const EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: _type == type ? blue : grey), child: CustomizedText(text: type, fontSize: 16)),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchNews(),
                builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    return StatefulBuilder(
                      key: _typeKey,
                      builder: (BuildContext context, void Function(void Function()) _) {
                        final List<Map<String, dynamic>> articles = snapshot.data!;
                        if (articles.isNotEmpty) {
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: articles.length,
                            itemBuilder: (BuildContext context, int index) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: GestureDetector(
                                onTap: () async => await goTo(Article(article: articles[index])),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 90,
                                      height: 100,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), image: articles[index]["urlToImage"] != null ? DecorationImage(image: CachedNetworkImageProvider(articles[index]["urlToImage"]), fit: BoxFit.cover) : null),
                                      child: articles[index]["urlToImage"] == null ? const Center(child: Icon(FontAwesomeIcons.userDoctor, size: 35, color: grey)) : null,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(padding: const EdgeInsets.all(4.0), decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue.withOpacity(.2)), child: const CustomizedText(text: "Health Care", fontSize: 16, fontWeight: FontWeight.bold)),
                                          Flexible(child: CustomizedText(text: articles[index]["title"], fontSize: 18, fontWeight: FontWeight.bold)),
                                          CustomizedText(text: getDateRepresentation(DateTime.parse(articles[index]["publishedAt"])), color: grey.withOpacity(.8), fontSize: 14),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Center(child: CustomizedText(text: 'noArticlesYet'.tr, fontSize: 18, fontWeight: FontWeight.bold));
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
            ),
          ],
        ),
      ),
    );
  }
}
