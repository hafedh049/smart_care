// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/stuff/globals.dart';

import '../../stuff/classes.dart';

class WorkFlow extends StatefulWidget {
  const WorkFlow({super.key});

  @override
  State<WorkFlow> createState() => _WorkFlowState();
}

class _WorkFlowState extends State<WorkFlow> {
  final PageController _flowController = PageController();
  final GlobalKey _nextPrevKey = GlobalKey();
  bool _left = false;
  final Map<int, String> _choices = <int, String>{0: ""};
  String _conduiteATenir = "";

  @override
  void dispose() {
    _choices.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
            Row(children: const <Widget>[Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), SizedBox(width: 50)]),
            Row(children: const <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
            const SizedBox(height: 10),
            Expanded(
              child: PageView.builder(
                itemCount: workflow.length,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (int page) {
                  _nextPrevKey.currentState!.setState(() {
                    _left = page > 0 ? true : false;
                  });
                },
                controller: _flowController,
                itemBuilder: (BuildContext context, int index) {
                  return StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return !workflow[index].containsKey("title")
                          ? CustomizedText(text: workflow[index]["end"], fontSize: 18, color: white, fontWeight: FontWeight.bold)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CustomizedText(text: workflow[index]["title"], fontSize: 25, color: blue, fontWeight: FontWeight.bold),
                                const SizedBox(height: 20),
                                for (Map<String, dynamic> option in workflow[index]["options"])
                                  GestureDetector(
                                    onTap: () {
                                      _(() => _choices[index] = option["content"]);
                                      Future.delayed(300.ms, () {
                                        for (int page = _flowController.page!.round(); page <= option["redirectTo"]; page++) {
                                          _flowController.jumpToPage(page);
                                        }
                                        if (workflow[option["redirectTo"]].containsKey("end")) {
                                          _conduiteATenir = workflow[option["redirectTo"]]["end"];
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Radio<String>(
                                            value: option["content"],
                                            groupValue: _choices[index],
                                            onChanged: (String? value) {
                                              _(() => _choices[index] = value!);
                                              Future.delayed(300.ms, () {
                                                for (int page = _flowController.page!.round(); page <= option["redirectTo"]; page++) {
                                                  _flowController.jumpToPage(page);
                                                }
                                                if (workflow[option["redirectTo"]].containsKey("end")) {
                                                  _conduiteATenir = workflow[option["redirectTo"]]["end"];
                                                }
                                              });
                                            },
                                            activeColor: blue,
                                          ),
                                          const SizedBox(width: 20),
                                          Flexible(child: CustomizedText(text: option["content"], fontSize: 18, color: white, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: StatefulBuilder(
                key: _nextPrevKey,
                builder: (BuildContext context, void Function(void Function()) _) {
                  return IgnorePointer(
                    ignoring: !_left,
                    child: AnimatedOpacity(
                      duration: 500.ms,
                      opacity: _left ? 1 : 0,
                      child: GestureDetector(
                        onTap: () {
                          _choices.removeWhere((int key, String value) => key == _flowController.page!.round());
                          _flowController.jumpToPage(_choices.keys.lastWhere((int element) => element < _flowController.page!.round(), orElse: () => _flowController.page!.round()));
                        },
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: _left ? blue.withOpacity(.8) : grey.withOpacity(.8)),
                          width: MediaQuery.of(context).size.width * .2,
                          height: 40,
                          child: const Center(child: Icon(FontAwesomeIcons.chevronLeft, size: 25, color: white)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            LayoutBuilder(builder: (BuildContext __, BoxConstraints _) => AnimatedContainer(duration: 500.ms, height: MediaQuery.of(context).padding.bottom > 0 ? 100 : 80)),
          ],
        ),
      ),
    );
  }
}
