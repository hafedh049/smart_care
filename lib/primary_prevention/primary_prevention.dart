// ignore_for_file: use_build_context_synchronously, invalid_use_of_protected_member

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_care/authentification/sign_in.dart';
import 'package:smart_care/screens/screens.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../stuff/functions.dart';

// ignore: must_be_immutable
class PrimaryPrevention extends StatelessWidget {
  PrimaryPrevention({super.key});

  final CarouselController _carouselController = CarouselController();
  final GlobalKey _carousselKey = GlobalKey();
  final GlobalKey _smoothKey = GlobalKey();
  final GlobalKey _textKey = GlobalKey();
  int _activeIndex = 0;
  final List<Map<String, String>> _preventions = <Map<String, String>>[
    {"image": "1.jfif", "tag": '⬛ Lavage avec eau savonneuse.'},
    {"image": "2.jfif", "tag": '⬛ Trempage / Eau de Javel, Dakin, Bétadine... Pendant 5 minutes.'},
    {"image": "3.jfif", "tag": '⬛ Rinçage abondamment à l’eau pendant 10 minutes (en cas de projection sur une muqueuse).'},
    {"image": "4.jfif", "tag": '⬛ Ne pas re-capuchonner les aiguilles.'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StatefulBuilder(
                key: _carousselKey,
                builder: (BuildContext context, void Function(void Function()) setS) {
                  return CarouselSlider.builder(
                    itemCount: _preventions.length,
                    itemBuilder: (BuildContext context, int index, int realIndex) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/${_preventions[index]['image']}"), fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    },
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      autoPlay: true,
                      viewportFraction: 1,
                      onPageChanged: (int index, CarouselPageChangedReason reason) {
                        _smoothKey.currentState!.setState(() {
                          _textKey.currentState!.setState(() {
                            _activeIndex = index;
                          });
                        });
                      },
                      height: MediaQuery.of(context).size.height,
                      pauseAutoPlayInFiniteScroll: true,
                    ),
                  );
                },
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 220,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: darkBlue.withOpacity(.8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 20),
                StatefulBuilder(
                  key: _textKey,
                  builder: (BuildContext context, void Function(void Function()) setS) {
                    return CustomizedText(
                      text: _preventions[_activeIndex]["tag"]!,
                      color: white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    );
                  },
                ),
                const SizedBox(height: 30),
                StatefulBuilder(
                  key: _smoothKey,
                  builder: (BuildContext context, void Function(void Function()) setS) {
                    return AnimatedSmoothIndicator(
                      activeIndex: _activeIndex,
                      count: _preventions.length,
                      onDotClicked: (int index) {
                        _carouselController.animateToPage(index);
                      },
                      effect: ExpandingDotsEffect(
                        activeDotColor: blue,
                        dotColor: white,
                        dotHeight: 10,
                        dotWidth: 10,
                        radius: 15,
                        strokeWidth: 2,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () async {
                    if (play == 1) {
                      playNote("tap.wav");
                    }
                    await db!.update("SMART_CARE", <String, dynamic>{"FIRST_TIME": 0, "AUDIO": 1});

                    if (FirebaseAuth.instance.currentUser != null) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Screens(firstScreen: 0)));
                    } else {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const SignIn()));
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .6,
                    height: 60,
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue),
                    child: Center(child: CustomizedText(text: AppLocalizations.of(context)!.get_started, color: black, fontWeight: FontWeight.bold, fontSize: 25)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
