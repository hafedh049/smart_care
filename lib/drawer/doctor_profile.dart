import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';

class DoctorProfile extends StatelessWidget {
  const DoctorProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              const SizedBox(height: 250),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
                    color: blue,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              const SizedBox(height: 550),
              Expanded(child: Container(decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)), color: darkBlue))),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(5)),
                        child: Icon(FontAwesomeIcons.chevronLeft, size: 15, color: darkBlue),
                      ),
                    ),
                    CustomizedText(text: "Doctor Profile", fontSize: 18, fontWeight: FontWeight.bold, color: white),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(5)),
                        child: Icon(FontAwesomeIcons.ellipsisVertical, size: 15, color: darkBlue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), image: DecorationImage(image: CachedNetworkImageProvider(noUser))),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CustomizedText(text: "Dr. ${'Hafedh Gunichi'}", fontSize: 18, fontWeight: FontWeight.bold, color: white),
                        const SizedBox(height: 5),
                        CustomizedText(text: 'Doctor', fontSize: 14, color: white.withOpacity(.8)),
                        const SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            RatingBarIndicator(
                              itemBuilder: (BuildContext context, int index) => Icon(FontAwesomeIcons.star, color: blue),
                              itemSize: 10,
                              itemPadding: const EdgeInsets.only(right: 4.0),
                              rating: 4.9,
                            ),
                            const SizedBox(width: 5),
                            CustomizedText(text: '( ${4.9.toStringAsFixed(1)} )', fontSize: 14, color: white.withOpacity(.8)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(child: Container(width: 30, height: 3, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: white))),
                const SizedBox(height: 30),
                CustomizedText(text: "Calendar", fontSize: 20, fontWeight: FontWeight.bold, color: white),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    for (int day in <int>[DateTime.now().subtract(2.days).day, DateTime.now().subtract(1.days).day, DateTime.now().day, DateTime.now().add(1.days).day, DateTime.now().add(2.days).day])
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: day == DateTime.now().day ? white : transparent),
                        child: day == DateTime.now().day
                            ? Column(
                                children: <Widget>[
                                  CustomizedText(text: showWeekDay(day), fontSize: 16, color: darkBlue),
                                  const SizedBox(height: 5),
                                  CustomizedText(text: "${day < 10 ? '0' : ''}$day", fontSize: 20, fontWeight: FontWeight.bold, color: darkBlue),
                                  const SizedBox(height: 5),
                                  CircleAvatar(radius: 4, backgroundColor: blue),
                                ],
                              )
                            : Column(
                                children: <Widget>[
                                  CustomizedText(text: "${day < 10 ? '0' : ''}$day", fontSize: 20, fontWeight: FontWeight.bold, color: white),
                                  const SizedBox(height: 10),
                                  CustomizedText(text: showWeekDay(day), fontSize: 16, color: white),
                                ],
                              ),
                      ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: 150,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: white.withOpacity(.8)),
                      child: Column(
                        children: <Widget>[
                          const Icon(Icons.sick, size: 25, color: Colors.green),
                          const SizedBox(height: 5),
                          CustomizedText(text: "500+", fontSize: 20, fontWeight: FontWeight.bold, color: darkBlue),
                          const SizedBox(height: 5),
                          CustomizedText(text: "Successful Patients", fontSize: 16, color: darkBlue),
                        ],
                      ),
                    ),
                    Container(
                      width: 150,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: white.withOpacity(.8)),
                      child: Column(
                        children: <Widget>[
                          const Icon(FontAwesomeIcons.yammer, size: 25, color: Colors.brown),
                          const SizedBox(height: 5),
                          CustomizedText(text: "${10} Years", fontSize: 20, fontWeight: FontWeight.bold, color: darkBlue),
                          const SizedBox(height: 5),
                          CustomizedText(text: "Experience", fontSize: 16, color: darkBlue),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(child: Container(width: 30, height: 3, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: white))),
                const SizedBox(height: 30),
                CustomizedText(text: "About", fontSize: 20, fontWeight: FontWeight.bold, color: white),
                const SizedBox(height: 20),
                Expanded(
                  child: SizedBox(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [CustomizedText(text: "A doctor is a medical professional who is trained to diagnose, treat and prevent illnesses and injuries. They use their knowledge and expertise to help patients maintain good health and wellbeing. Doctors work in a variety of settings, including hospitals, clinics, and private practices.", fontSize: 14, color: white)],
                      ),
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
