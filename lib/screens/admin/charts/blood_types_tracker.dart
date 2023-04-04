import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';

class BloodTypeTracker extends StatefulWidget {
  const BloodTypeTracker({super.key});

  @override
  State<BloodTypeTracker> createState() => _BloodTypeTrackerState();
}

class _BloodTypeTrackerState extends State<BloodTypeTracker> {
  @override
  void initState() {
    _timer = Timer.periodic(
      5.seconds,
      (Timer timer) {
        if (mounted) {
          _bloodKey.currentState!.setState(() {
            for (int day = 0; day < 7; day++) {
              _bloodTypes[_bloodIndex]["spots"][day] = double.parse((Random().nextDouble() * 120).toStringAsFixed(2));
            }
          });
        }
      },
    );
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.landscapeLeft]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
    _timer.cancel();
    super.dispose();
  }

  final List<Map<String, dynamic>> _bloodTypes = [
    <String, dynamic>{
      "blood_type": "A+",
      "spots": <double>[25.0, 30.0, 35.0, 40.0, 45.0, 50.0, 55.0],
      "color": const Color(0xFFFF9800),
    },
    <String, dynamic>{
      "blood_type": "A-",
      "spots": <double>[15.0, 20.0, 25.0, 30.0, 35.0, 40.0, 45.0],
      "color": const Color(0xFFCDDC39),
    },
    <String, dynamic>{
      "blood_type": "B+",
      "spots": <double>[20.0, 25.0, 30.0, 35.0, 40.0, 45.0, 50.0],
      "color": const Color(0xFF4CAF50),
    },
    <String, dynamic>{
      "blood_type": "B-",
      "spots": <double>[10.0, 15.0, 20.0, 25.0, 30.0, 35.0, 40.0],
      "color": const Color(0xFF2196F3),
    },
    <String, dynamic>{
      "blood_type": "AB+",
      "spots": <double>[5.0, 10.0, 15.0, 20.0, 25.0, 30.0, 35.0],
      "color": const Color(0xFF673AB7),
    },
    <String, dynamic>{
      "blood_type": "AB-",
      "spots": <double>[3.0, 6.0, 9.0, 12.0, 15.0, 18.0, 21.0],
      "color": const Color(0xFFF44336),
    },
    <String, dynamic>{
      "blood_type": "O+",
      "spots": <double>[30.0, 35.0, 40.0, 45.0, 50.0, 55.0, 60.0],
      "color": const Color(0xFFFFEB3B),
    },
    <String, dynamic>{
      "blood_type": "O-",
      "spots": <double>[20.0, 25.0, 30.0, 35.0, 40.0, 45.0, 50.0],
      "color": const Color(0xFF795548),
    },
  ];
  final GlobalKey _bloodKey = GlobalKey();
  int _bloodIndex = 0;
  late final Timer _timer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 32.0, top: 32.0, bottom: 16.0),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: StatefulBuilder(
                    key: _bloodKey,
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  return Container(margin: const EdgeInsets.only(top: 4.0), child: CustomizedText(text: weekDayPredictor[(value + .1).ceil()]!, fontSize: 14, color: white));
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          minX: 0,
                          maxX: 6,
                          minY: 0,
                          maxY: (_bloodTypes.map((Map<String, dynamic> type) => (type["spots"].reduce((double value, double element) => value < element ? element : value) / 10).ceil() * 10).reduce((dynamic value, dynamic element) => value < element ? element : value) / 10).ceil() * 10.0,
                          lineBarsData: [
                            LineChartBarData(
                              spots: <FlSpot>[for (int item = 0; item < _bloodTypes[_bloodIndex]["spots"].length; item++) FlSpot(item.toDouble(), _bloodTypes[_bloodIndex]["spots"][item])],
                              isCurved: true,
                              color: _bloodTypes[_bloodIndex]["color"],
                              barWidth: 1,
                              isStrokeCapRound: true,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(show: true, color: _bloodTypes[_bloodIndex]["color"].withOpacity(0.2), spotsLine: BarAreaSpotsLine(show: true, flLineStyle: FlLine(color: white, dashArray: <int>[5], strokeWidth: .6))),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (int index = 0; index < _bloodTypes.length; index++)
                      Container(
                        margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            if (_bloodIndex != index) {
                              if (mounted) {
                                _bloodKey.currentState!.setState(() => _bloodIndex = index);
                              }
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              Container(width: 30, height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: _bloodTypes[index]["color"])),
                              const SizedBox(width: 10),
                              CustomizedText(text: _bloodTypes[index]["blood_type"], fontSize: 18, fontWeight: FontWeight.bold, color: white),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
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
