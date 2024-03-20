import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:smart_care/utils/globals.dart';

import '../../utils/classes.dart';
import '../../utils/callbacks.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 30),
            const Row(children: <Widget>[Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), SizedBox(width: 50)]),
            const Row(children: <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
            const SizedBox(height: 20),
            CustomizedText(text: 'Home'.tr, fontSize: 35, fontWeight: FontWeight.bold),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                shrinkWrap: true,
                children: charts
                    .map(
                      (Map<String, dynamic> chart) => GestureDetector(
                        onTap: () async => await goTo(chart["widget"]),
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: chart["color"]),
                          height: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(height: 100, width: 5, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: darkBlue)),
                              Expanded(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[CustomizedText(text: chart["name"], color: darkBlue, fontSize: 22, fontWeight: FontWeight.bold), const SizedBox(height: 10), Icon(chart["icon"], size: 25, color: darkBlue)]))),
                              Container(height: 100, width: 5, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: darkBlue)),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) => AnimatedContainer(duration: 700.ms, height: MediaQuery.of(context).padding.bottom > 0 ? 40 : 20)),
          ],
        ),
      ),
    );
  }
}
