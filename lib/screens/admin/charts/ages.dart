import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/error/error_room.dart';

import '../../../stuff/classes.dart';
import '../../../stuff/globals.dart';

class AgeTracker extends StatefulWidget {
  const AgeTracker({super.key});

  @override
  State<AgeTracker> createState() => _AgeTrackerState();
}

class _AgeTrackerState extends State<AgeTracker> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.landscapeLeft]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
    super.dispose();
  }

  final GlobalKey _ageKey = GlobalKey();

  Future<List<Map<String, dynamic>>> getCountOfData() async {
    final List<Map<String, dynamic>> data = <Map<String, dynamic>>[];
    for (final List<int> range in const <List<int>>[
      [18, 28],
      [28, 38],
      [38, 48],
      [48, 53],
    ]) {
      final start = DateTime.now().subtract(Duration(days: range[1] * 365));
      final end = DateTime.now().subtract(Duration(days: range[0] * 365));
      final startTimestamp = Timestamp.fromDate(start);
      final endTimestamp = Timestamp.fromDate(end);

      int maleCount = 0;
      int femaleCount = 0;

      await FirebaseFirestore.instance.collection('users').where('date_of_birth', isGreaterThanOrEqualTo: startTimestamp).where('date_of_birth', isLessThan: endTimestamp).where('gender', isEqualTo: 'm').count().get().then((AggregateQuerySnapshot value) {
        maleCount = value.count;
      });
      await FirebaseFirestore.instance.collection('users').where('date_of_birth', isGreaterThanOrEqualTo: startTimestamp).where('date_of_birth', isLessThan: endTimestamp).where('gender', isEqualTo: 'f').count().get().then((AggregateQuerySnapshot value) {
        femaleCount = value.count;
      });

      data.add({"age": range[0], "male": maleCount, "female": femaleCount});
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 32.0, top: 32.0, bottom: 16.0),
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: getCountOfData(),
                    builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (snapshot.hasData) {
                        List<Map<String, dynamic>> data = snapshot.data!;
                        return StatefulBuilder(
                          key: _ageKey,
                          builder: (BuildContext context, void Function(void Function()) _) {
                            return BarChart(
                              BarChartData(
                                barTouchData: BarTouchData(
                                  enabled: true,
                                  touchCallback: (FlTouchEvent flTouchEvent, BarTouchResponse? barTouchResponse) {},
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (double value, TitleMeta titleMeta) {
                                        final int age = value.toInt();
                                        final int start = age; //(age ~/ 18) * 18;
                                        final int end = start + 10;
                                        return CustomizedText(text: '$start - $end', fontSize: 14, color: white);
                                      },
                                      interval: 10,
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                barGroups: <BarChartGroupData>[
                                  for (final Map<String, dynamic> item in data)
                                    BarChartGroupData(
                                      x: item['age'],
                                      barRods: <BarChartRodData>[
                                        BarChartRodData(
                                          toY: item['male'].toDouble(),
                                          width: 16,
                                          color: Colors.teal,
                                        ),
                                        BarChartRodData(
                                          toY: item['female'].toDouble(),
                                          width: 16,
                                          color: Colors.redAccent,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: blue));
                      } else {
                        return ErrorRoom(error: snapshot.error.toString());
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (final Map<String, dynamic> legend in const <Map<String, dynamic>>[
                      <String, dynamic>{"name": "Male", "color": Colors.teal},
                      <String, dynamic>{"name": "Female", "color": Colors.redAccent}
                    ])
                      Container(
                        margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            _ageKey.currentState!.setState(() {});
                          },
                          child: Row(
                            children: <Widget>[
                              Container(width: 30, height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: legend["color"])),
                              const SizedBox(width: 10),
                              CustomizedText(text: legend["name"], fontSize: 18, fontWeight: FontWeight.bold, color: white),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 20),
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.all(8.0),
                child: const Center(child: Icon(FontAwesomeIcons.chevronLeft, size: 15, color: white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
