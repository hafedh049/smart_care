import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../stuff/classes.dart';

class Article extends StatelessWidget {
  const Article({super.key, required this.article});
  final Map<String, dynamic> article;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * .6,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(35)),
              image: DecorationImage(image: CachedNetworkImageProvider(article["urlToImage"]!), fit: BoxFit.cover),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Container(
                      decoration: BoxDecoration(color: dark, borderRadius: BorderRadius.circular(5)),
                      child: CustomIcon(func: () => Navigator.pop(context), icon: FontAwesomeIcons.chevronLeft),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(15)),
                    child: CustomizedText(text: article["topic"], color: white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  CustomizedText(text: article["title"], color: white, fontSize: 24, fontWeight: FontWeight.bold),
                  const SizedBox(height: 10),
                  CustomizedText(text: "${AppLocalizations.of(context)!.trending} >> ${GetTimeAgo.parse(DateTime.parse(article["publishedAt"]))}", color: white, fontSize: 14),
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
                  decoration: const BoxDecoration(color: dark, borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(35))),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: grey.withOpacity(.2),
                              backgroundImage: CachedNetworkImageProvider(article["sourceUrl"]),
                            ),
                            const SizedBox(width: 10),
                            CustomizedText(text: article["source"]["name"], color: white, fontSize: 24, fontWeight: FontWeight.bold),
                            const SizedBox(width: 10),
                            Stack(
                              alignment: AlignmentDirectional.center,
                              children: const <Widget>[
                                Icon(FontAwesomeIcons.certificate, color: blue, size: 20),
                                Icon(FontAwesomeIcons.check, color: white, size: 12),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CustomizedText(text: AppLocalizations.of(context)!.author, color: white, fontSize: 18, fontWeight: FontWeight.bold),
                            const SizedBox(width: 10),
                            Flexible(child: CustomizedText(text: '"${article["author"]}"', color: white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (article["description"].isNotEmpty) CustomizedText(text: AppLocalizations.of(context)!.description, color: white, fontSize: 16),
                                if (article["description"].isNotEmpty) const SizedBox(height: 5),
                                if (article["description"].isNotEmpty) CustomizedText(text: article["description"], color: white, fontSize: 16),
                                if (article["description"].isNotEmpty) const SizedBox(height: 10),
                                const CustomizedText(text: "Content", color: white, fontSize: 16),
                                const SizedBox(height: 5),
                                CustomizedText(text: article["content"], color: white, fontSize: 16),
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
