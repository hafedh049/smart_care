// ignore_for_file: invalid_use_of_protected_member

import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:smart_care/authentification/sign_in.dart';
import 'package:smart_care/screens/screens.dart';
import 'package:smart_care/utils/classes.dart';
import 'package:smart_care/utils/globals.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: must_be_immutable
class PrimaryPrevention extends StatelessWidget {
  PrimaryPrevention({super.key});

  final cs.CarouselController _carouselController = cs.CarouselController();
  final GlobalKey _carousselKey = GlobalKey();
  final GlobalKey _smoothKey = GlobalKey();
  final GlobalKey _textKey = GlobalKey();
  int _activeIndex = 0;
  final List<Map<String, String>> _preventions = <Map<String, String>>[
    {"image": "1.jfif", "tag": '🟦⬛ Lavage avec eau savonneuse.'},
    {"image": "2.jfif", "tag": '🟦⬛Trempage / Eau de Javel, Dakin, Bétadine... Pendant 5 minutes.'},
    {"image": "3.jfif", "tag": '🟦⬛ Rinçage abondamment à l’eau pendant 10 minutes (en cas de projection sur une muqueuse).'},
    {"image": "4.jfif", "tag": '🟦⬛ Ne pas re-capuchonner les aiguilles.'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StatefulBuilder(
                key: _carousselKey,
                builder: (BuildContext context, void Function(void Function()) setS) => cs.CarouselSlider.builder(
                  itemCount: _preventions.length,
                  itemBuilder: (BuildContext context, int index, int realIndex) => Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/primaly_preventions/${_preventions[index]['image']}"), fit: BoxFit.cover), borderRadius: BorderRadius.circular(5))),
                  carouselController: _carouselController,
                  options: cs.CarouselOptions(
                    autoPlayAnimationDuration: 200.ms,
                    autoPlay: true,
                    viewportFraction: 1,
                    onPageChanged: (int index, cs.CarouselPageChangedReason reason) => _smoothKey.currentState!.setState(() => _textKey.currentState!.setState(() => _activeIndex = index)),
                    height: MediaQuery.of(context).size.height,
                    pauseAutoPlayInFiniteScroll: true,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 220,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: darkBlue.withOpacity(.8), borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 20),
                StatefulBuilder(key: _textKey, builder: (BuildContext context, void Function(void Function()) setS) => CustomizedText(text: _preventions[_activeIndex]["tag"]!, color: white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                StatefulBuilder(
                  key: _smoothKey,
                  builder: (BuildContext context, void Function(void Function()) setS) {
                    return AnimatedSmoothIndicator(
                      activeIndex: _activeIndex,
                      count: _preventions.length,
                      onDotClicked: (int index) => _carouselController.animateToPage(index),
                      effect: const ExpandingDotsEffect(activeDotColor: blue, dotColor: white, dotHeight: 10, dotWidth: 10, radius: 15, strokeWidth: 2),
                    );
                  },
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () async {
                    userData!.put("first_time", false);
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => FirebaseAuth.instance.currentUser != null ? const Screens() : const SignIn()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .6,
                    height: 60,
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue),
                    child: Center(child: CustomizedText(text: 'getStarted'.tr, color: black, fontWeight: FontWeight.bold, fontSize: 25)),
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
