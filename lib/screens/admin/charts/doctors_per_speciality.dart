// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';

class DoctorsPerSpeciality extends StatefulWidget {
  const DoctorsPerSpeciality({super.key});

  @override
  State<DoctorsPerSpeciality> createState() => _DoctorsPerSpecialityState();
}

class _DoctorsPerSpecialityState extends State<DoctorsPerSpeciality> {
  double _total = -1;

  final List<List<Color>> _colorSchemes = const <List<Color>>[
    [Color(0xFF6E0D6D), Color(0xFFC0389F)],
    [Color(0xFF0F52BA), Color(0xFF00BFFF)],
    [Color(0xFF4B0082), Color(0xFF8A2BE2)],
    [Color(0xFF0F9D58), Color(0xFF00BFA5)],
    [Color(0xFFFF6D00), Color(0xFFFF8F00)],
    [Color(0xFFFF4081), Color(0xFFFF5A5F)],
    [Color(0xFFEF6C00), Color(0xFFFFA726)],
    [Color(0xFF03A9F4), Color(0xFF00BCD4)],
    [Color(0xFF9C27B0), Color(0xFFE040FB)],
    [Color(0xFF8BC34A), Color(0xFFCDDC39)],
  ];

  //late final List<dynamic> _specs;

  Future<List<Map<String, dynamic>>> _load(BuildContext context) async {
    List<Map<String, dynamic>> specialities = <Map<String, dynamic>>[];
    int counter = 0;
    for (Map<String, dynamic> speciality in specialityList) {
      await FirebaseFirestore.instance.collection("users").where("speciality", isEqualTo: speciality["speciality"]).count().get().then((AggregateQuerySnapshot value) {
        specialities.add(<String, dynamic>{"speciality": speciality["speciality"], "count": value.count, "gradients": _colorSchemes[counter]});
        if (_total < value.count) {
          _total = (value.count.toDouble() / 10).ceil() * 10;
        }
      });
      counter += 1;
    }

    return specialities;
  }

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
      backgroundColor: darkBlue,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 36.0, bottom: 16.0),
        child: Center(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _load(context),
            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: _total,
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            show: true,
                            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (double value, TitleMeta meta) => CustomizedText(text: [for (String word in snapshot.data![value.floor().toInt()]["speciality"].trim().split(" ")) word[0]].join(), color: white, fontSize: 12))),
                          ),
                          gridData: FlGridData(
                            show: true,
                            checkToShowHorizontalLine: (double value) => value % 5 == 0,
                            getDrawingHorizontalLine: (double value) => FlLine(color: grey, strokeWidth: 1, dashArray: [5]),
                          ),
                          borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey, width: 1)),
                          barGroups: snapshot.data!
                              .map(
                                (Map<String, dynamic> value) => BarChartGroupData(
                                  x: snapshot.data!.indexOf(value),
                                  barRods: [BarChartRodData(toY: value["count"].toDouble(), gradient: LinearGradient(colors: value["gradients"]), borderRadius: BorderRadius.circular(1))],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            for (int index = 0; index < snapshot.data!.length; index++)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10.0, right: 10.0, left: 10.0),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(gradient: LinearGradient(colors: _colorSchemes[index]), borderRadius: BorderRadius.circular(5)),
                                  ),
                                  Expanded(child: SingleChildScrollView(child: Container(margin: const EdgeInsets.only(bottom: 10.0), child: CustomizedText(text: snapshot.data![index]["speciality"], fontSize: 14, fontWeight: FontWeight.bold, color: white)))),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: blue));
              } else {
                return ErrorRoom(error: snapshot.error.toString());
              }
            },
          ),
        ),
      ),
    );
  }
}
