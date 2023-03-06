// ignore_for_file: must_be_immutable

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/screens/home.dart';

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  final PageController _screensController = PageController();
  final List<Map<String, dynamic>> _screens = <Map<String, dynamic>>[
    {"screen": const Home(), "icon": FontAwesomeIcons.house},
    {"screen": const Home(), "icon": FontAwesomeIcons.house},
    {"screen": const Home(), "icon": FontAwesomeIcons.house},
    {"screen": const Home(), "icon": FontAwesomeIcons.house},
  ];
  int _activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: _screens.map((Map<String, dynamic> page) => page["icon"] as IconData).toList(),
        activeIndex: _activeIndex,
        height: 0,
        onTap: (int page) {
          _activeIndex = page;
          _screensController.animateToPage(page, duration: 300.ms, curve: Curves.linear);
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              controller: _screensController,
              children: _screens.map((Map<String, dynamic> page) => page["screen"] as Widget).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
