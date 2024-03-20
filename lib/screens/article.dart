import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:smart_care/utils/globals.dart';

import '../utils/classes.dart';

class Article extends StatelessWidget {
  const Article({super.key, required this.article});
  final Map<String, dynamic> article;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * .6,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(borderRadius: const BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(35)), image: article["urlToImage"] != null ? DecorationImage(image: CachedNetworkImageProvider(article["urlToImage"]), fit: BoxFit.cover) : null),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 30),
                  GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronLeft, size: 15))),
                  const Spacer(),
                  Container(padding: const EdgeInsets.all(8.0), decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(15)), child: const CustomizedText(text: "Health Care", fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  CustomizedText(text: article["title"], fontSize: 24, fontWeight: FontWeight.bold),
                  const SizedBox(height: 10),
                  CustomizedText(text: "${'trending'.tr} >> ${GetTimeAgo.parse(DateTime.parse(article["publishedAt"]))}", fontSize: 14),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * .5),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: blue.withOpacity(.9), borderRadius: const BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(35))),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            CustomizedText(text: article["source"] != null ? article["source"]["name"] : "UNKNOWN", fontSize: 24, fontWeight: FontWeight.bold),
                            if (article["source"] != null) const SizedBox(width: 10),
                            if (article["source"] != null) const Stack(alignment: AlignmentDirectional.center, children: <Widget>[Icon(FontAwesomeIcons.certificate, color: blue, size: 20), Icon(FontAwesomeIcons.check, size: 12)]),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CustomizedText(text: 'author'.tr, fontSize: 18, fontWeight: FontWeight.bold),
                            const SizedBox(width: 10),
                            Flexible(child: CustomizedText(text: '"${article["author"] ?? 'UNKWNOWN'}"', fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CustomizedText(text: 'description'.tr, fontSize: 16),
                                const SizedBox(height: 5),
                                CustomizedText(text: article["description"], fontSize: 16),
                                const SizedBox(height: 10),
                                const CustomizedText(text: "Content", fontSize: 16),
                                const SizedBox(height: 5),
                                CustomizedText(text: article["content"], fontSize: 16),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
