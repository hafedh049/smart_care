import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  @override
  void initState() async {
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.landscapeLeft]);
    super.initState();
  }

  @override
  void dispose() async {
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
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
                        final Map<String, int> serviceCounts = <String, int>{'Expert métier': 0};
                        final List<BarChartGroupData> bars = <BarChartGroupData>[];
                        for (QueryDocumentSnapshot<Map<String, dynamic>> item in snapshot.data!.docs) {
                          String service = item.get('service');
                          if (serviceCounts.containsKey(service)) {
                            serviceCounts[service] = serviceCounts[service]! + 1;
                          }
                        }
                        const Map<int, Color> colors = <int, Color>{16: blue, 12: Colors.tealAccent, 10: red};
                        serviceCounts.forEach((String grade, int count) {
                          bars.add(BarChartGroupData(x: grade.length, barRods: <BarChartRodData>[BarChartRodData(toY: count.toDouble(), color: colors[grade.length])]));
                        });
                        return BarChart(
                          BarChartData(
                            barTouchData: BarTouchData(enabled: true),
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
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
                      <String, dynamic>{"name": "Expert métier", "color": blue},
                    ])
                      Container(
                        margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                        child: Row(
                          children: <Widget>[
                            Container(width: 30, height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: legend["color"])),
                            const SizedBox(width: 10),
                            CustomizedText(text: legend["name"], fontSize: 18, fontWeight: FontWeight.bold, color: white),
                          ],
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
