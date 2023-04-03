import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/stuff/globals.dart';

class DiseasesTracker extends StatefulWidget {
  const DiseasesTracker({super.key});

  @override
  State<DiseasesTracker> createState() => _DiseasesTrackerState();
}

class _DiseasesTrackerState extends State<DiseasesTracker> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.landscapeLeft]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
    Future.delayed(300.ms);
    super.dispose();
  }

  final List<Map<String, dynamic>> _data = const [
    <String, dynamic>{'name': 'HIV', 'color': Colors.orange, 'value': 25, 'icon': FontAwesomeIcons.virusCovid},
    <String, dynamic>{'name': 'Hepatitis B', 'color': Colors.yellow, 'value': 35, 'icon': FontAwesomeIcons.lungsVirus},
    <String, dynamic>{'name': 'Hepatitis C', 'color': Colors.red, 'value': 39, 'icon': FontAwesomeIcons.virus},
    <String, dynamic>{"name": "Others", "value": 1, "color": grey, 'icon': FontAwesomeIcons.disease},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 32.0, top: 32.0, bottom: 16.0),
        child: Stack(
          children: <Widget>[
            PieChart(
              PieChartData(
                borderData: FlBorderData(border: Border.all(color: grey.withOpacity(.2))),
                centerSpaceRadius: 25,
                sectionsSpace: 15,
                sections: _data
                    .map(
                      (Map<String, dynamic> data) => PieChartSectionData(
                        color: data['color'],
                        value: data['value'],
                        title: data['name'],
                        badgePositionPercentageOffset: 0,
                        radius: 15,
                        badgeWidget: CircleAvatar(
                          radius: 18,
                          backgroundColor: data['color'],
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: grey.withOpacity(.3),
                            child: Icon(data['icon'], size: 15, color: grey),
                          ),
                        ),
                        showTitle: true,
                        titlePositionPercentageOffset: .5,
                        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: white),
                      ),
                    )
                    .toList(),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.all(8.0),
                child: const Center(
                  child: Icon(FontAwesomeIcons.chevronLeft, size: 15, color: white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
