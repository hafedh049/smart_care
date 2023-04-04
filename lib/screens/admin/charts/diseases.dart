import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/stuff/globals.dart';

import '../../../stuff/classes.dart';

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
    super.dispose();
  }

  List<Map<String, dynamic>> _renderDate(BuildContext context) {
    final List<Map<String, dynamic>> data = <Map<String, dynamic>>[
      <String, dynamic>{'name': 'HIV', 'color': blue, 'value': 25, 'icon': FontAwesomeIcons.virusCovid, 'radius': MediaQuery.of(context).size.height * .2, 'is_touched': false},
      <String, dynamic>{'name': 'Hepatitis B', 'color': Colors.deepPurple, 'value': 29, 'icon': FontAwesomeIcons.lungsVirus, 'radius': MediaQuery.of(context).size.height * .2, 'is_touched': false},
      <String, dynamic>{'name': 'Hepatitis C', 'color': Colors.brown, 'value': 35, 'icon': FontAwesomeIcons.virus, 'radius': MediaQuery.of(context).size.height * .2, 'is_touched': false},
      <String, dynamic>{"name": "Others", "value": 11, "color": grey, 'icon': FontAwesomeIcons.disease, 'radius': MediaQuery.of(context).size.height * .2, 'is_touched': false},
    ];
    return data;
  }

  final GlobalKey _diseaseKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final data = _renderDate(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 32.0, top: 32.0, bottom: 16.0),
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: StatefulBuilder(
                    key: _diseaseKey,
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return PieChart(
                        PieChartData(
                          centerSpaceRadius: MediaQuery.of(context).size.height * .2,
                          pieTouchData: PieTouchData(
                            enabled: true,
                            touchCallback: (FlTouchEvent flTouchEvent, PieTouchResponse? pieTouchResponse) {
                              if (flTouchEvent.isInterestedForInteractions) {
                                final int index = pieTouchResponse!.touchedSection!.touchedSectionIndex;
                                if (index >= 0) {
                                  _diseaseKey.currentState!.setState(() {
                                    data[index]['is_touched'] = !data[index]['is_touched'];
                                  });
                                }
                              }
                            },
                          ),
                          sectionsSpace: 25,
                          sections: data
                              .map(
                                (Map<String, dynamic> data) => PieChartSectionData(
                                  color: data['color'],
                                  value: data['value'].toDouble(),
                                  borderSide: data['is_touched'] ? BorderSide(color: white.withOpacity(.6), width: 3) : null,
                                  title: "${data['value']} %",
                                  badgePositionPercentageOffset: 1,
                                  radius: data['is_touched'] ? data['radius'] + 20 : data['radius'],
                                  badgeWidget: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: data['color'],
                                    child: CircleAvatar(radius: 18, backgroundColor: darkBlue.withOpacity(.8), child: Icon(data['icon'], size: 15, color: white)),
                                  ),
                                  showTitle: true,
                                  titlePositionPercentageOffset: .5,
                                  titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: white),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int index = 0; index < data.length; index++)
                      Container(
                        margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            _diseaseKey.currentState!.setState(() {
                              data[index]['is_touched'] = !data[index]['is_touched'];
                            });
                          },
                          child: Row(
                            children: <Widget>[
                              Container(width: 30, height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: data[index]["color"])),
                              const SizedBox(width: 10),
                              CustomizedText(text: data[index]["name"], fontSize: 18, fontWeight: FontWeight.bold, color: white),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 60),
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
