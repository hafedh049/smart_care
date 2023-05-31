import 'package:camera/camera.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_care/screens/patient/heart_rate/sensor_value.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';

import '../../../stuff/functions.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});
  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final List<SensorValue> _data = <SensorValue>[];
  final GlobalKey _lineChartKey = GlobalKey();
  final GlobalKey _minKey = GlobalKey();
  final GlobalKey _maxKey = GlobalKey();
  final GlobalKey _averageKey = GlobalKey();
  CameraController? _cameraController;
  bool _toggled = false;
  bool _processing = false;

  void _toggle() {
    _initController().then(
      (void onValue) => _averageKey.currentState!.setState(
        () => _maxKey.currentState!.setState(
          () => _minKey.currentState!.setState(
            () => _lineChartKey.currentState!.setState(
              () {
                _toggled = true;
                _processing = false;
              },
            ),
          ),
        ),
      ),
    );
  }

  void _untoggle() {
    _cameraController!.dispose();
    _averageKey.currentState!.setState(
      () => _maxKey.currentState!.setState(
        () => _minKey.currentState!.setState(
          () => _lineChartKey.currentState!.setState(
            () {
              _toggled = false;
              _processing = false;
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  Future<void> _initController() async {
    try {
      List cameras = await availableCameras();
      _cameraController = CameraController(cameras.first, ResolutionPreset.low);
      await _cameraController!.initialize();
      Future.delayed(500.ms).then((dynamic onValue) => _cameraController!.setFlashMode(FlashMode.torch));
      _cameraController!.startImageStream((CameraImage image) {
        if (!_processing) {
          _averageKey.currentState!.setState(() => _maxKey.currentState!.setState(() => _minKey.currentState!.setState(() => _lineChartKey.currentState!.setState(() => _processing = true))));
          _scanImage(image);
        }
      });
    } catch (exception) {
      showToast(text: exception.toString());
    }
  }

  void _scanImage(CameraImage image) {
    double avg = image.planes.first.bytes.reduce((int value, int element) => value + element) / image.planes.first.bytes.length;
    if (_data.length >= 50) {
      _data.removeAt(0);
    }
    _averageKey.currentState!.setState(() => _maxKey.currentState!.setState(() => _minKey.currentState!.setState(() => _lineChartKey.currentState!.setState(() => _data.add(SensorValue(DateTime.now(), avg))))));
    Future.delayed((1000 ~/ 30).ms).then((void onValue) => _averageKey.currentState!.setState(() => _maxKey.currentState!.setState(() => _minKey.currentState!.setState(() => _lineChartKey.currentState!.setState(() => _processing = false)))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            Align(alignment: AlignmentDirectional.centerStart, child: GestureDetector(onTap: () => Navigator.pop(context), child: Container(height: 40, width: 40, padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: black.withOpacity(.3), borderRadius: BorderRadius.circular(5)), child: const Center(child: Icon(FontAwesomeIcons.chevronLeft, size: 20))))),
            const SizedBox(height: 10),
            StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) _) => GestureDetector(
                    onTap: () {
                      _toggled ? _untoggle() : _toggle();
                      Future.delayed(200.ms, () => _(() {}));
                    },
                    child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: black.withOpacity(.3)), padding: const EdgeInsets.all(8), child: Center(child: CustomizedText(text: _toggled ? "Stop" : "Start", fontSize: 16, color: blue))))),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: black.withOpacity(.3)),
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[
                    const RotatedBox(quarterTurns: -1, child: CustomizedText(text: "BPM", color: blue, fontSize: 16)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: StatefulBuilder(
                              key: _lineChartKey,
                              builder: (BuildContext context, void Function(void Function()) _) {
                                return LineChart(
                                  LineChartData(
                                    lineTouchData: LineTouchData(enabled: true),
                                    lineBarsData: <LineChartBarData>[LineChartBarData(spots: _data.map((SensorValue timeserie) => FlSpot(timeserie.timestamp.millisecondsSinceEpoch.toDouble(), timeserie.value)).toList(), isCurved: false, barWidth: 3, color: blue, dotData: FlDotData(show: false))],
                                    gridData: FlGridData(show: true),
                                    borderData: FlBorderData(show: false),
                                    titlesData: FlTitlesData(
                                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (double value, TitleMeta meta) => CustomizedText(text: value.toInt().toString(), color: white, fontSize: 12))),
                                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (double value, TitleMeta meta) => CustomizedText(text: (value.toInt() % 60).toString(), color: white, fontSize: 12))),
                                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      show: true,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          const CustomizedText(text: "TIME", color: blue, fontSize: 16)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: black.withOpacity(.3)),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          StatefulBuilder(key: _averageKey, builder: (BuildContext context, void Function(void Function()) _) => CustomizedText(text: _data.length <= 2 ? "0" : ((_data.reduce((SensorValue value, SensorValue element) => value.value > element.value ? value : element).value + _data.reduce((SensorValue value, SensorValue element) => value.value < element.value ? value : element).value) ~/ 2).toString())),
                          const CustomizedText(text: "Bpm", fontSize: 16, color: blue, fontWeight: FontWeight.bold),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const CustomizedText(text: "AVERAGE", fontSize: 16, color: blue, fontWeight: FontWeight.bold)
                    ],
                  ),
                  const Spacer(),
                  LottieBuilder.asset("assets/lottie/stat_rate.json", height: 100, fit: BoxFit.cover),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: black.withOpacity(.3)),
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          StatefulBuilder(key: _minKey, builder: (BuildContext context, void Function(void Function()) _) => CustomizedText(text: _data.length <= 2 ? "0" : _data.reduce((SensorValue value, SensorValue element) => value.value < element.value ? value : element).value.toInt().toString())),
                          const CustomizedText(text: "Bpm", fontSize: 16, color: blue, fontWeight: FontWeight.bold),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const CustomizedText(text: "MIN", fontSize: 16, color: blue, fontWeight: FontWeight.bold)
                    ],
                  ),
                  const Spacer(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          StatefulBuilder(key: _maxKey, builder: (BuildContext context, void Function(void Function()) _) => CustomizedText(text: _data.length <= 2 ? "0" : _data.reduce((SensorValue value, SensorValue element) => value.value > element.value ? value : element).value.toInt().toString())),
                          const CustomizedText(text: "Bpm", fontSize: 16, color: blue, fontWeight: FontWeight.bold),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const CustomizedText(text: "MAX", fontSize: 16, color: blue, fontWeight: FontWeight.bold)
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 45),
          ],
        ),
      ),
    );
  }
}
