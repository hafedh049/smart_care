import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            const CustomizedText(text: "Dashboard", fontSize: 24, fontWeight: FontWeight.bold),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: grey.withOpacity(.1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.users, size: 15, color: white)),
                  const CustomizedText(text: "Total Users", fontSize: 14),
                  const CustomizedText(text: "1", fontSize: 14, fontWeight: FontWeight.bold),
                  const CustomizedText(text: "Paid Users :", fontSize: 14),
                  const CustomizedText(text: "0", fontSize: 14),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: grey.withOpacity(.1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.cartShopping, size: 15, color: white)),
                  const CustomizedText(text: "Total Orders", fontSize: 14),
                  const CustomizedText(text: "0", fontSize: 14, fontWeight: FontWeight.bold),
                  const CustomizedText(text: "Total Order Amount :", fontSize: 14),
                  const CustomizedText(text: "0", fontSize: 14),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: grey.withOpacity(.1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.lightBlueAccent, borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.trophy, size: 15, color: white)),
                  const CustomizedText(text: "Total Plans", fontSize: 14),
                  const CustomizedText(text: "1", fontSize: 14, fontWeight: FontWeight.bold),
                  const CustomizedText(text: "Most Purchase Plan :", fontSize: 14),
                  const CustomizedText(text: "0", fontSize: 14),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const CustomizedText(text: "Recent Order", fontSize: 24, fontWeight: FontWeight.bold),
            const SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(drawVerticalLine: false, show: true, checkToShowHorizontalLine: (double value) => int.parse(value.toString().split(".")[1]) == 0 ? true : false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (double value, TitleMeta meta) => CustomizedText(text: int.parse(value.toString().split(".")[1]) == 0 ? value.toInt().toString() : "", fontSize: 14))),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: <LineChartBarData>[
                    LineChartBarData(
                      isCurved: true,
                      spots: <FlSpot>[for (int i = 0; i <= 7; i++) FlSpot(i.toDouble(), Random().nextDouble() * 7)],
                    ),
                  ],
                  maxX: 7,
                  maxY: 7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
