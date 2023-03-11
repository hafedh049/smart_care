import 'package:flutter/material.dart';
import 'package:smart_care/stuff/globals.dart';

import '../../stuff/classes.dart';

class WorkFlow extends StatefulWidget {
  const WorkFlow({super.key});

  @override
  State<WorkFlow> createState() => _WorkFlowState();
}

class _WorkFlowState extends State<WorkFlow> {
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
            Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
            Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), const SizedBox(width: 30)]),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
