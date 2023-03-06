// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/screens/chats.dart';
import 'package:smart_care/screens/historic.dart';
import 'package:smart_care/screens/home.dart';
import 'package:smart_care/screens/upload.dart';
import 'package:smart_care/stuff/classes.dart';

import '../stuff/globals.dart';

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  final PageController _screensController = PageController();
  final List<Map<String, dynamic>> _screens = <Map<String, dynamic>>[
    {"screen": const Home(), "icon": FontAwesomeIcons.house},
    {"screen": const Upload(), "icon": FontAwesomeIcons.camera},
    {"screen": const Chats(), "icon": FontAwesomeIcons.solidMessage},
    {"screen": const Historic(), "icon": FontAwesomeIcons.solidFolder},
  ];
  final GlobalKey _screensKey = GlobalKey();
  int _activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: screensScaffoldKey,
      drawer: HealthDrawer(
        func: () {
          screensScaffoldKey.currentState!.closeDrawer();
        },
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Column(
            children: <Widget>[
              Expanded(
                child: PageView(
                  onPageChanged: (int page) {
                    _screensKey.currentState!.setState(() => _activeIndex = page);
                  },
                  controller: _screensController,
                  children: _screens.map((Map<String, dynamic> page) => page["screen"] as Widget).toList(),
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 30),
              CustomIcon(
                  func: () {
                    screensScaffoldKey.currentState!.openDrawer();
                  },
                  icon: FontAwesomeIcons.ellipsisVertical),
              const Spacer(),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 48.0, left: 8.0, right: 8.0),
                  decoration: BoxDecoration(color: const Color.fromARGB(255, 27, 27, 27), borderRadius: BorderRadius.circular(25)),
                  height: 60,
                  child: StatefulBuilder(
                    key: _screensKey,
                    builder: (BuildContext context, void Function(void Function()) setS) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          for (int screen = 0; screen < _screens.length; screen++)
                            CustomIcon(
                              clicked: _activeIndex == screen ? true : false,
                              func: () {
                                setS(
                                  () {
                                    _activeIndex = screen;
                                    _screensController.jumpToPage(screen);
                                  },
                                );
                              },
                              icon: _screens[screen]["icon"],
                            ),
                        ],
                      );
                    },
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
