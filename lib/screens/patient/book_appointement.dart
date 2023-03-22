import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../stuff/classes.dart';
import '../../stuff/functions.dart';
import '../../stuff/globals.dart';

class BookAppointment extends StatefulWidget {
  const BookAppointment({super.key, required this.id, required this.doctorImageUrl, required this.doctorName, required this.speciality});
  final String id;
  final String doctorName;
  final String doctorImageUrl;
  final String speciality;

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  final PageController _pageController = PageController();
  final GlobalKey _stepKey = GlobalKey();
  final GlobalKey _navigationKey = GlobalKey();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _step = 1;
  int _duration = 2;
  int _appointmentType = 2;
  DateTime _date = DateTime.now();
  Time _time = Time(hour: DateTime.now().hour, minute: DateTime.now().minute);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: darkBlue,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                if (play == 1) {
                  playNote("tap.wav");
                }
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                child: Icon(FontAwesomeIcons.chevronLeft, size: 15, color: grey),
              ),
            ),
            const SizedBox(height: 10),
            CustomizedText(text: "Add Schedule", fontSize: 30, fontWeight: FontWeight.bold, color: white),
            const SizedBox(height: 30),
            StatefulBuilder(
              key: _stepKey,
              builder: (BuildContext context, void Function(void Function()) _) {
                return CustomizedText(text: "Step $_step : 2", fontSize: 18, color: blue, fontWeight: FontWeight.bold);
              },
            ),
            const SizedBox(height: 40),
            Expanded(
              child: PageView(
                onPageChanged: (int value) {
                  _stepKey.currentState!.setState(() {
                    _navigationKey.currentState!.setState(() {
                      _step = value + 1;
                    });
                  });
                },
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomizedText(text: "Select Time", fontSize: 18, color: white, fontWeight: FontWeight.bold),
                      const SizedBox(height: 40),
                      CustomizedText(text: "Start", fontSize: 16, color: white, fontWeight: FontWeight.bold),
                      const SizedBox(height: 20),
                      StatefulBuilder(
                        builder: (context, void Function(void Function()) _) {
                          return GestureDetector(
                            onTap: () {
                              if (play == 1) {
                                playNote("tap.wav");
                              }
                              Navigator.push(
                                context,
                                showPicker(
                                  value: Time(hour: 0, minute: 0),
                                  onChange: (Time time) {
                                    _(() {
                                      _time = time;
                                    });
                                  },
                                  blurredBackground: true,
                                  elevation: 0,
                                  iosStylePicker: true,
                                  hourLabel: "Hour",
                                  minuteLabel: "Minute",
                                  okText: "OK",
                                ),
                              );
                            },
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 120,
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    color: transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: blue),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      CustomizedText(text: _time.hour.toString().length == 1 ? "0${_time.hour.toString()}" : _time.hour.toString(), fontWeight: FontWeight.bold, fontSize: 16, color: blue),
                                      CustomizedText(text: ":", fontWeight: FontWeight.bold, fontSize: 16, color: blue),
                                      CustomizedText(text: _time.minute.toString().length == 1 ? "0${_time.minute.toString()}" : _time.minute.toString(), fontWeight: FontWeight.bold, fontSize: 16, color: blue),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                AnimatedContainer(
                                  duration: 700.ms,
                                  width: 50,
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    color: _time.period.name.toLowerCase() == "am" ? blue : grey.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(child: CustomizedText(text: "AM", fontWeight: FontWeight.bold, fontSize: 16, color: white)),
                                ),
                                const SizedBox(width: 20),
                                AnimatedContainer(
                                  duration: 700.ms,
                                  width: 50,
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    color: _time.period.name.toLowerCase() == "pm" ? blue : grey.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(child: CustomizedText(text: "PM", fontWeight: FontWeight.bold, fontSize: 16, color: white)),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  height: 40,
                                  width: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    color: transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: blue),
                                  ),
                                  child: Center(child: Icon(FontAwesomeIcons.pen, size: 15, color: white)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomizedText(text: "Duration", fontSize: 16, color: white, fontWeight: FontWeight.bold),
                      const SizedBox(height: 20),
                      StatefulBuilder(
                        builder: (context, void Function(void Function()) _) {
                          return Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  if (play == 1) {
                                    playNote("tap.wav");
                                  }
                                  _(() => _duration = 1);
                                },
                                child: AnimatedContainer(
                                  duration: 700.ms,
                                  width: 80,
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    color: _duration == 1 ? blue : grey.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(child: CustomizedText(text: "5 min", fontWeight: FontWeight.bold, fontSize: 16, color: white)),
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  if (play == 1) {
                                    playNote("tap.wav");
                                  }
                                  _(() => _duration = 2);
                                },
                                child: AnimatedContainer(
                                  duration: 700.ms,
                                  width: 80,
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    color: _duration == 2 ? blue : grey.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(child: CustomizedText(text: "15 min", fontWeight: FontWeight.bold, fontSize: 16, color: white)),
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  if (play == 1) {
                                    playNote("tap.wav");
                                  }
                                  _(() => _duration = 3);
                                },
                                child: AnimatedContainer(
                                  duration: 700.ms,
                                  width: 80,
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    color: _duration == 3 ? blue : grey.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(child: CustomizedText(text: "30 min", fontWeight: FontWeight.bold, fontSize: 16, color: white)),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomizedText(text: "Select Date", fontSize: 18, color: white, fontWeight: FontWeight.bold),
                      const SizedBox(height: 40),
                      StatefulBuilder(
                        builder: (context, void Function(void Function()) _) {
                          return GestureDetector(
                            onTap: () {
                              if (play == 1) {
                                playNote("tap.wav");
                              }
                              showDatePicker(
                                context: context,
                                initialDate: _date,
                                firstDate: _date,
                                lastDate: DateTime(_date.year, _date.month + 7),
                              ).then((DateTime? value) {
                                _(() => _date = value!);
                              });
                            },
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  width: 80,
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    color: transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: blue),
                                  ),
                                  child: Center(child: CustomizedText(text: _date.year.toString(), fontWeight: FontWeight.bold, fontSize: 16, color: blue)),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  height: 40,
                                  width: 80,
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    color: transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: blue),
                                  ),
                                  child: Center(child: CustomizedText(text: _date.month.toString().length == 1 ? "0${_date.month.toString()}" : _date.month.toString(), fontWeight: FontWeight.bold, fontSize: 16, color: blue)),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  height: 40,
                                  width: 80,
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    color: transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: blue),
                                  ),
                                  child: Center(child: CustomizedText(text: _date.day.toString().length == 1 ? "0${_date.day.toString()}" : _date.day.toString(), fontWeight: FontWeight.bold, fontSize: 16, color: blue)),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  height: 40,
                                  width: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    color: transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: blue),
                                  ),
                                  child: Center(child: Icon(FontAwesomeIcons.pen, size: 15, color: white)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 60),
                      CustomizedText(text: "Appointment Type", fontSize: 16, color: white, fontWeight: FontWeight.bold),
                      const SizedBox(height: 40),
                      StatefulBuilder(
                        builder: (context, void Function(void Function()) _) {
                          return Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  if (play == 1) {
                                    playNote("tap.wav");
                                  }
                                  _(() => _appointmentType = 1);
                                },
                                child: AnimatedContainer(
                                  duration: 700.ms,
                                  height: 40,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: _appointmentType == 1 ? blue : grey.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(child: CustomizedText(text: "Online", fontWeight: FontWeight.bold, fontSize: 16, color: white)),
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  if (play == 1) {
                                    playNote("tap.wav");
                                  }
                                  _(() => _appointmentType = 2);
                                },
                                child: AnimatedContainer(
                                  duration: 700.ms,
                                  height: 40,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: _appointmentType == 2 ? blue : grey.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(child: CustomizedText(text: "In Person", fontWeight: FontWeight.bold, fontSize: 16, color: white)),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if (play == 1) {
                        playNote("tap.wav");
                      }
                      if (_step == 1) {
                        _pageController.animateToPage(1, duration: 400.ms, curve: Curves.linear);
                      } else {
                        await FirebaseFirestore.instance.collection("appointments").add(
                          <String, dynamic>{
                            'patientName': me["medical_professional_name"],
                            'doctorName': widget.doctorName,
                            'patientID': me["uid"],
                            'doctorID': widget.id,
                            'doctorImageUrl': widget.doctorImageUrl,
                            'doctorSpeciality': widget.speciality,
                            'appointmentDate': _date,
                            'appointmentTime': _time.format(context),
                            'status': 'pending',
                            'duration': const <String>["5 min", "15 min", "30 min"][_duration - 1],
                            'type': const <String>["Online", "In Person"][_appointmentType - 1],
                            'createdAt': Timestamp.now(),
                          },
                        ).then((value) async {
                          showToast("Appointment Booked");
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          StatefulBuilder(
                            key: _navigationKey,
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return CustomizedText(text: _step == 1 ? "Next" : "Book Appointement", color: darkBlue, fontSize: 17, fontWeight: FontWeight.bold);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints boxConstraints) => MediaQuery.of(context).padding.bottom > 0 ? const SizedBox(height: 40) : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
