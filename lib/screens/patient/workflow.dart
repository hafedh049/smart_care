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
  bool _right = false;
  int _lastVisitedPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
            Row(children: const <Widget>[Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), SizedBox(width: 50)]),
            Row(children: const <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
            const SizedBox(height: 10),
            Expanded(
              child: PageView.builder(
                itemCount: 10,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (int page) {
                  print(page);
                  _nextPrevKey.currentState!.setState(() {
                    _left = page > 0 ? true : false;
                  });
                },
                controller: _flowController,
                itemBuilder: (BuildContext context, int index) {
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10),
            StatefulBuilder(
              key: _nextPrevKey,
              builder: (BuildContext context, void Function(void Function()) _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                      visible: _left,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: _left ? blue.withOpacity(.8) : grey.withOpacity(.8)),
                          width: MediaQuery.of(context).size.width * .2,
                          height: 40,
                          child: const Center(child: Icon(FontAwesomeIcons.chevronLeft, size: 25, color: white)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Visibility(
                      visible: _right,
                      child: GestureDetector(
                        onTap: () {
                          _(() => _lastVisitedPage += 1);
                        },
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: _right ? blue.withOpacity(.8) : grey.withOpacity(.8)),
                          width: MediaQuery.of(context).size.width * .2,
                          height: 40,
                          child: const Center(child: Icon(FontAwesomeIcons.chevronRight, size: 25, color: white)),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            LayoutBuilder(builder: (BuildContext __, BoxConstraints _) => AnimatedContainer(duration: 500.ms, height: MediaQuery.of(context).padding.bottom > 0 ? 100 : 80)),
          ],
        ),
      ),
    );
  }
}
