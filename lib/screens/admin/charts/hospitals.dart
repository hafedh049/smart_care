import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/utils/classes.dart';
import 'package:smart_care/utils/globals.dart';

import '../../../error/error_room.dart';

class Hospitals extends StatefulWidget {
  const Hospitals({super.key});

  @override
  State<Hospitals> createState() => _HospitalsState();
}

class _HospitalsState extends State<Hospitals> {
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
                  child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance.collection('users').limit(10).get(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.hasData) {
                        final Map<String, int> hospitalsCounts = <String, int>{'Ksar Helal': 0, 'Mahdia': 0, 'Monastir': 0};
                        final List<BarChartGroupData> bars = <BarChartGroupData>[];
                        for (QueryDocumentSnapshot<Map<String, dynamic>> item in snapshot.data!.docs) {
                          String hospital = item.get('hospital');
                          if (hospitalsCounts.containsKey(hospital)) {
                            hospitalsCounts[hospital] = hospitalsCounts[hospital]! + 1;
                          }
                        }
                        const Map<int, Color> colors = <int, Color>{6: blue, 8: red, 12: Colors.tealAccent};
                        hospitalsCounts.forEach((String grade, int count) {
                          bars.add(BarChartGroupData(x: grade.length, barRods: <BarChartRodData>[BarChartRodData(toY: count.toDouble(), color: colors[grade.length])]));
                        });
                        return BarChart(
                          BarChartData(
                            barTouchData: BarTouchData(enabled: true),
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (double value, TitleMeta meta) => CustomizedText(fontSize: 14, text: hospitalsCounts.keys.firstWhere((String element) => element.length == value.toInt())),
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: bars,
                          ),
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
                      <String, dynamic>{"name": "Ksar Helal", "color": blue},
                      <String, dynamic>{"name": "Mahdia", "color": Colors.tealAccent},
                      <String, dynamic>{"name": "Monastir", "color": red},
                    ])
                      Container(margin: const EdgeInsets.only(right: 8.0, bottom: 8.0), child: Row(children: <Widget>[Container(width: 30, height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: legend["color"])), const SizedBox(width: 10), CustomizedText(text: legend["name"], fontSize: 18, fontWeight: FontWeight.bold)])),
                  ],
                ),
                const SizedBox(width: 20),
              ],
            ),
            GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)), padding: const EdgeInsets.all(8.0), child: const Center(child: Icon(FontAwesomeIcons.chevronLeft, size: 15)))),
          ],
        ),
      ),
    );
  }
}
