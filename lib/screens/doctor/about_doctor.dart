import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/functions.dart';

import '../../stuff/globals.dart';

class AboutDoctor extends StatelessWidget {
  const AboutDoctor({super.key, required this.uid});
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blue,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Column(
            children: <Widget>[
              const SizedBox(height: 150),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: darkBlue, borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35))),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomIcon(func: () => Navigator.pop(context), icon: FontAwesomeIcons.chevronLeft, size: 20),
                    CustomizedText(text: "Doctor Details", fontSize: 18, color: white, fontWeight: FontWeight.bold),
                    CustomIcon(func: () {}, icon: FontAwesomeIcons.ellipsisVertical, size: 20),
                  ],
                ),
                const SizedBox(height: 5),
                CircleAvatar(radius: 43, backgroundColor: darkBlue, child: CircleAvatar(radius: 40, backgroundImage: CachedNetworkImageProvider(noUser), backgroundColor: blue)),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomizedText(text: "Dr. ${'Hafedh Gunichi'}", fontSize: 18, color: white, fontWeight: FontWeight.bold),
                    const SizedBox(width: 10),
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.certificate, color: blue, size: 18),
                        Icon(FontAwesomeIcons.check, color: darkBlue, size: 10),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CustomizedText(text: "Dental Specialist", fontSize: 14, color: white),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue.withOpacity(.3)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(FontAwesomeIcons.phoneVolume, color: blue, size: 15),
                            const SizedBox(width: 5),
                            CustomizedText(text: "Audio", fontSize: 16, color: blue, fontWeight: FontWeight.bold),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.amber.withOpacity(.3)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            Icon(FontAwesomeIcons.video, color: Colors.amber, size: 15),
                            SizedBox(width: 5),
                            CustomizedText(text: "Video", fontSize: 16, color: Colors.amber, fontWeight: FontWeight.bold),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.purple.shade900.withOpacity(.3)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            Icon(FontAwesomeIcons.message, color: Color.fromARGB(255, 217, 0, 255), size: 15),
                            SizedBox(width: 5),
                            CustomizedText(text: "Chat", fontSize: 16, color: Color.fromARGB(255, 217, 0, 255), fontWeight: FontWeight.bold),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.heartPulse, color: red, size: 15),
                    const SizedBox(width: 5),
                    CustomizedText(text: "${'5.00'} Positive Ratings", fontSize: 14, color: white),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                        colors: <Color>[blue.withOpacity(.2), white.withOpacity(.1)],
                        stops: const <double>[.5, .7],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        CustomizedText(text: "Information", color: white, fontSize: 20, fontWeight: FontWeight.bold),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            CustomizedText(text: "Years of experience", color: white, fontSize: 18),
                            const Spacer(),
                            CustomizedText(text: "${24} Years", color: white, fontSize: 18, fontWeight: FontWeight.bold),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: <Widget>[
                            CustomizedText(text: "Patients checked", color: white, fontSize: 18),
                            const Spacer(),
                            CustomizedText(text: "${'34,567'}+", color: white, fontSize: 18, fontWeight: FontWeight.bold),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomizedText(text: "Schedules", color: white, fontSize: 20, fontWeight: FontWeight.bold),
                        const SizedBox(height: 20),
                        SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              for (int index = 0; index < DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day; index++)
                                Container(
                                  width: 60,
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  margin: index == 0 || index == DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day - 1 ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: index.isOdd ? white : blue,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      CustomizedText(text: showWeekDay(index), color: darkBlue, fontSize: 18),
                                      const SizedBox(height: 2),
                                      CustomizedText(text: '${index + 1 < 10 ? "0" : ""}${index + 1}', color: darkBlue, fontSize: 20, fontWeight: FontWeight.bold),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomizedText(text: "Available Time", color: white, fontSize: 20, fontWeight: FontWeight.bold),
                        const SizedBox(height: 20),
                        SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              for (int index = 10; index <= 18; index += 2)
                                Container(
                                  width: 60,
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  margin: index == 10 || index == 18 ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: index == 12 ? blue : white,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      CustomizedText(text: "${index > 12 ? '0${index - 12}' : index}", color: darkBlue, fontSize: 16),
                                      const SizedBox(width: 2),
                                      CustomizedText(text: index < 12 ? "AM" : "PM", color: darkBlue, fontSize: 17, fontWeight: FontWeight.bold),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CustomizedText(text: "Book an Appointment", color: darkBlue, fontSize: 17, fontWeight: FontWeight.bold),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
