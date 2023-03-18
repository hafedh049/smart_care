// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/stuff/functions.dart';

import '../stuff/classes.dart';
import '../stuff/globals.dart';

class Account extends StatelessWidget {
  Account({super.key});
  String _gender = "m";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: darkBlue,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: Icon(FontAwesomeIcons.x, size: 15, color: grey)),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Container(width: 40, height: 40, decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5)), child: Icon(FontAwesomeIcons.check, size: 15, color: white)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CustomizedText(text: "Account", fontSize: 40, fontWeight: FontWeight.bold, color: white),
              const SizedBox(height: 60),
              GestureDetector(
                onTap: () {},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomizedText(text: "Photo", fontSize: 14, color: grey),
                    const SizedBox(width: 80),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircleAvatar(radius: 50, backgroundColor: grey.withOpacity(.2), child: Icon(FontAwesomeIcons.user, color: grey, size: 35)),
                        const SizedBox(height: 10),
                        CustomizedText(text: "Upload Picture", fontSize: 14, color: blue),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: <Widget>[
                    CustomizedText(text: "Name", fontSize: 14, color: grey),
                    const SizedBox(width: 80),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CustomizedText(text: "Hafedh Gunichi", fontSize: 18, color: white),
                          const SizedBox(height: 5),
                          Container(height: .1, color: white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setS) {
                  return Row(
                    children: <Widget>[
                      CustomizedText(text: "Gender", fontSize: 14, color: grey),
                      const SizedBox(width: 72),
                      GestureDetector(onTap: () => setS(() => _gender = "m"), child: CircleAvatar(radius: 25, backgroundColor: _gender == "m" ? blue : grey.withOpacity(.2), child: Icon(FontAwesomeIcons.mars, color: _gender == "m" ? white : grey, size: 20))),
                      const SizedBox(width: 10),
                      GestureDetector(onTap: () => setS(() => _gender = "f"), child: CircleAvatar(radius: 25, backgroundColor: _gender == "f" ? blue : grey.withOpacity(.2), child: Icon(FontAwesomeIcons.venus, color: _gender == "f" ? white : grey, size: 20))),
                    ],
                  );
                },
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: <Widget>[
                    CustomizedText(text: "Age", fontSize: 14, color: grey),
                    const SizedBox(width: 90),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CustomizedText(text: "28", fontSize: 18, color: white),
                          const SizedBox(height: 5),
                          Container(height: .1, color: white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: <Widget>[
                    CustomizedText(text: "E-mail", fontSize: 14, color: grey),
                    const SizedBox(width: 75),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CustomizedText(text: "hafedhgunichi@gmail.com", fontSize: 18, color: white),
                          const SizedBox(height: 5),
                          Container(height: .1, color: white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: <Widget>[
                    CustomizedText(text: "Password", fontSize: 14, color: grey),
                    const SizedBox(width: 55),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CustomizedText(text: "*************", fontSize: 18, color: white),
                          const SizedBox(height: 5),
                          Container(height: .1, color: white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        height: MediaQuery.of(context).size.height * .6,
                        child: CardSwiper(
                          isLoop: true,
                          duration: 100.ms,
                          padding: EdgeInsets.zero,
                          cards: <Widget>[
                            for (Map<String, dynamic> speciality in specialityListFunction(context))
                              GestureDetector(
                                onTap: () {
                                  showToast(speciality["speciality"]);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: darkBlue,
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(speciality["url"]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Row(
                  children: <Widget>[
                    CustomizedText(text: "Speciality", fontSize: 14, color: grey),
                    const SizedBox(width: 55),
                    CustomizedText(text: "Hafedh Gunichi", fontSize: 18, color: white),
                    const SizedBox(width: 25),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                      child: Icon(FontAwesomeIcons.chevronRight, size: 15, color: grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
