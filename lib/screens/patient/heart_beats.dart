import 'package:flutter/material.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HeartBeats extends StatefulWidget {
  const HeartBeats({super.key});

  @override
  State<HeartBeats> createState() => _HeartBeatsState();
}

class _HeartBeatsState extends State<HeartBeats> {
  final List<SensorValue> _data = <SensorValue>[];
  final List<SensorValue> _bpmValues = <SensorValue>[];

  bool isBPMEnabled = false;

  @override
  void dispose() {
    _data.clear();
    _bpmValues.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.heartBeatsPerMinute),
      ),
      body: Column(
        children: <Widget>[
          isBPMEnabled
              ? HeartBPMDialog(
                  context: context,
                  onRawData: (SensorValue value) {
                    setState(() {
                      if (_data.length >= 100) _data.removeAt(0);
                      _data.add(value);
                    });
                  },
                  onBPM: (int value) => setState(() {
                    if (_bpmValues.length >= 100) {
                      _bpmValues.removeAt(0);
                    }
                    _bpmValues.add(SensorValue(value: value.toDouble(), time: DateTime.now()));
                  }),
                )
              : const SizedBox(),
          isBPMEnabled && _data.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(border: Border.all()),
                  height: 180,
                  child: BPMChart(_data),
                )
              : const SizedBox(),
          isBPMEnabled && _bpmValues.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(border: Border.all()),
                  constraints: const BoxConstraints.expand(height: 180),
                  child: BPMChart(_bpmValues),
                )
              : const SizedBox(),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.favorite_rounded),
              label: CustomizedText(text: isBPMEnabled ? AppLocalizations.of(context)!.stopMeasurement : AppLocalizations.of(context)!.measureBPM, fontSize: 18, color: const Color.fromARGB(255, 159, 121, 199), fontWeight: FontWeight.bold),
              onPressed: () => setState(
                () => isBPMEnabled = !isBPMEnabled,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
