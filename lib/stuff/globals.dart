import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_care/screens/admin/heart_beats.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/admin/charts/ages.dart';
import '../screens/admin/charts/blood_types_tracker.dart';
import '../screens/admin/charts/diseases.dart';
import '../screens/admin/charts/doctors_per_speciality.dart';
import '../screens/admin/doctors_list.dart';
import '../screens/admin/patients_list.dart';

const Color white = Colors.white;
const Color black = Colors.black;
const Color darkBlue = Color(0xff272336);
const Color transparent = Colors.transparent;
const Color blue = Color.fromARGB(255, 93, 172, 248);
const Color red = Color.fromARGB(255, 219, 15, 0);
const Color green = Colors.lightGreenAccent;
const Color grey = Colors.grey;

int? firstTime;
int darkTheme = 1;
int? play;

const String apiKey = "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";

final AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();

Map<String, dynamic> me = <String, dynamic>{};

Database? db;

const String chatBot = "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/smart_bot.png?alt=media&token=99ba8285-3b29-489a-a473-a81cc228e3d3";

List<Map<String, dynamic>> specialityListFunction(BuildContext context) {
  return <Map<String, dynamic>>[
    {
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F1-min.jpg?alt=media&token=e8e0e7eb-e787-4731-8adb-c6d3ae0e5b23",
      "speciality": AppLocalizations.of(context)!.surgeonsAndSurgicalAssistants,
      "description": "Surgeons and surgical assistants",
    },
    {
      "color": darkBlue,
      "description": AppLocalizations.of(context)!.anesthesiologistsAndAnesthesiologyAssistantsDescription,
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F2-min.jpg?alt=media&token=5f1050dd-6e82-48ad-b7dd-ad6f9430e967",
      "speciality": AppLocalizations.of(context)!.anesthesiologistsAndAnesthesiologyAssistants,
    },
    {
      "color": darkBlue,
      "description": AppLocalizations.of(context)!.nursesAndNursePractitionersDescription,
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F3-min.jpg?alt=media&token=c5d93efb-a3a0-4ef0-9648-669e31ddcde8",
      "speciality": AppLocalizations.of(context)!.nursesAndNursePractitioners,
    },
    {
      "color": darkBlue,
      "description": AppLocalizations.of(context)!.phlebotomistsDescription,
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F4-min.jpg?alt=media&token=77a970d6-85fb-4d88-b4a9-85fec5cbf0d4",
      "speciality": AppLocalizations.of(context)!.phlebotomists,
    },
    {
      "color": white,
      "description": AppLocalizations.of(context)!.medicalLaboratoryTechniciansAndTechnologistsDescription,
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F5-min.jpg?alt=media&token=92e3fb9b-7de3-4d64-a83c-0125ab2a0af1",
      "speciality": AppLocalizations.of(context)!.medicalLaboratoryTechniciansAndTechnologists,
    },
    {
      "color": white,
      "description": AppLocalizations.of(context)!.eMTsAndParamedicsDescription,
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F6-min.jpg?alt=media&token=b59680f2-d007-49a0-b1a9-1946f829ea86",
      "speciality": AppLocalizations.of(context)!.eMTsAndParamedics,
    },
    {
      "color": darkBlue,
      "description": AppLocalizations.of(context)!.dentistsAndDentalHygienistsDescription,
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F7-min.jpg?alt=media&token=6e1c68ee-42ae-427a-ae61-c011f4ef2342",
      "speciality": AppLocalizations.of(context)!.dentistsAndDentalHygienists,
    },
    {
      "color": darkBlue,
      "description": AppLocalizations.of(context)!.ophthalmologistsAndOptometristsDescription,
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F8-min.jpg?alt=media&token=3a8772cb-cbb5-4ad8-b7d7-7c07a0b05305",
      "speciality": AppLocalizations.of(context)!.ophthalmologistsAndOptometrists,
    },
    {
      "color": white,
      "description": AppLocalizations.of(context)!.physicalTherapistsAndOccupationalTherapistsDescription,
      "speciality": AppLocalizations.of(context)!.physicalTherapistsAndOccupationalTherapists,
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F9-min.jpg?alt=media&token=d038757d-dbc1-4e7d-b47e-6ba5f9b4d332",
    },
    {
      "color": white,
      "description": AppLocalizations.of(context)!.chiropractorsAndMassageTherapistsDescription,
      "speciality": AppLocalizations.of(context)!.chiropractorsAndMassageTherapists,
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F10-min.jpg?alt=media&token=7ff8d3e9-5ac1-4939-99ff-d01696e5303a",
    },
  ];
}

const String noUser = 'https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/doctor-icon.png?alt=media&token=69e755f5-e674-4064-a97e-708f2ec8c25c';

String? Function(String?)? fieldsValidatorsFunction(String text, BuildContext context) {
  Map<String, String? Function(String?)?> fieldsValidators = <String, String? Function(String?)?>{
    "about": (String? text) {
      return null;
    },
    "email": (String? text) {
      if (text!.isEmpty) {
        return AppLocalizations.of(context)!.emailismandatory;
      } else if (!text.contains(RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$'))) {
        return AppLocalizations.of(context)!.pleaseverifyyourEmail;
      }
      return null;
    },
    "password": (String? text) {
      if (text!.isEmpty) {
        return AppLocalizations.of(context)!.passwordshouldnotbeempty;
      } else if (!text.contains(RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$'))) {
        return AppLocalizations.of(context)!.passwordexpressionshouldbeatleastcharactersmustcontainatleastuppercaseletterlowercaseletterandnumberandcancontainspecialcharacters;
      }
      return null;
    },
    "username": (String? text) {
      if (text!.isEmpty) {
        return AppLocalizations.of(context)!.namefieldisempty;
      } else if (!text.contains(RegExp(r'^[a-zA-Z][\w ]+$'))) {
        return AppLocalizations.of(context)!.thisfieldmuststartwithanalphabeticcharacter;
      }
      return null;
    },
    "id": (String? text) {
      if (text!.isEmpty) {
        return AppLocalizations.of(context)!.iDmustnotbeempty;
      } else if (!text.contains(RegExp(r'^\#[a-z0-9]{4,14}$'))) {
        return AppLocalizations.of(context)!.wrongformatforIDItmuststartwithandcontainsalphanumericcaracters;
      }
      return null;
    },
    "age": (String? text) {
      if (text!.isEmpty) {
        return AppLocalizations.of(context)!.emptyAge;
      } else if (!text.contains(RegExp(r'^\#[a-z0-9]{4,14}$'))) {
        return AppLocalizations.of(context)!.ageContainsOnlyDigits;
      }
      return null;
    },
    "job location": (String? text) {
      if (text!.isEmpty) {
        return AppLocalizations.of(context)!.youmustprovideyourworklocationplease;
      }
      return null;
    },
    "speciality": (String? text) {
      if (text!.isEmpty) {
        return AppLocalizations.of(context)!.pleasechooseoneofthelistedspecialities;
      }
      return null;
    },
  };

  return fieldsValidators[text];
}

final Map<int, String> weekDayPredictor = <int, String>{1: "Mon", 2: "Tue", 3: "Wed", 4: "Thu", 5: "Fri", 6: "Sat", 7: "Sun"};

const String appTitle = "Smart Care";
const String appIcon = "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/health.png?alt=media&token=5b9a461b-bf46-4dfd-bc83-e8ec9a66f990";

const String aboutUs = "Welcome to our telemedicine platform, built using the Flutter cross-platform framework, designed to provide primary prevention and prompt medical assistance in case of an AES (accident d'explosion du sang). Our platform is not only for patients, but it also caters to healthcare professionals who can monitor their patient's health status in real-time. Our platform's primary objective is to assist people in preventing AES by conducting daily and monthly checkups and sending SMS or notification reminders. In case of an AES event, our platform provides a workflow that patients can follow and get the final results from our laboratory experts. We understand the importance of medical assistance during an AES event; hence, we have provided a direct chat option with doctors. In addition, we have integrated a smart chatbot built on top of ChatGPT 3.5 for faster responses to queries when doctors are unavailable. Our telemedicine platform is fully customizable, with two themes - light and dark, and supports eight languages, making it user-friendly for people from diverse backgrounds. You can also enable gesture and message sounds to personalize your experience.Our platform offers a multitude of benefits for both patients and healthcare professionals. Patients can access medical assistance from the comfort of their homes, while healthcare professionals can monitor their patient's health status and offer timely intervention. We believe that our telemedicine platform can help reduce the incidence of AES and save lives.";

final List<Map<String, dynamic>> healthcareFacilities = <Map<String, dynamic>>[
  {"name": "Centre Hospitalier Universitaire Fattouma Bourguiba de Monastir", "latitude": 35.7611469, "longitude": 10.8125058},
  {"name": "Clinique les Oliviers Monastir", "latitude": 35.7667159, "longitude": 10.8322074},
  {"name": "Clinique El Amen Monastir", "latitude": 35.7713949, "longitude": 10.8206096},
  {"name": "Polyclinique des Palmiers Monastir", "latitude": 35.7604815, "longitude": 10.827065},
  {"name": "Clinique Internationale Monastir", "latitude": 35.768876, "longitude": 10.8319216},
  {"name": "Clinique Al Hikma Monastir", "latitude": 35.7701055, "longitude": 10.8300627},
  {"name": "Clinique Monastir Médical", "latitude": 35.7720048, "longitude": 10.8286933},
  {"name": "Clinique Al Amana Monastir", "latitude": 35.7712026, "longitude": 10.8256544},
  {"name": "Polyclinique Al Azhar Monastir", "latitude": 35.7616056, "longitude": 10.8219744},
  {"name": "Clinique Taoufik Monastir", "latitude": 35.7640652, "longitude": 10.8251672},
  {"name": "Polyclinique de la Rose Monastir", "latitude": 35.7631194, "longitude": 10.8342604},
  {"name": "Polyclinique Essafaa Monastir", "latitude": 35.7627449, "longitude": 10.8324411},
  {"name": "Polyclinique Monastir El Wifak", "latitude": 35.7659385, "longitude": 10.8295595},
  {"name": "Hôpital de Moknine", "latitude": 35.6078568, "longitude": 10.995835},
  {"name": "Hôpital de Zéramdine", "latitude": 35.4122763, "longitude": 10.978685},
  {"name": "Hôpital de Jemmal", "latitude": 35.5655434, "longitude": 10.9052743},
  {"name": "Hôpital de Ksar Hellal", "latitude": 35.670407, "longitude": 10.877977},
  {"name": "Hôpital de Sahline", "latitude": 35.7840403, "longitude": 10.6963433},
  {"name": "Hôpital de Sayada", "latitude": 36.8730225, "longitude": 10.326227},
  {"name": "Faculté de Médecine de Monastir", "latitude": 35.7763282, "longitude": 10.8267896}
];

List<Map<String, dynamic>> adminCards(BuildContext context) {
  final List<Map<String, dynamic>> adminCardsList = <Map<String, dynamic>>[
    <String, dynamic>{"name": AppLocalizations.of(context)!.patientsList, "widget": const PatientsList(), "color": const Color.fromARGB(255, 246, 206, 206), "icon": FontAwesomeIcons.ellipsis},
    <String, dynamic>{"name": AppLocalizations.of(context)!.doctorsList, "widget": const DoctorsList(), "color": const Color.fromARGB(255, 195, 227, 255), "icon": FontAwesomeIcons.ellipsisVertical},
    <String, dynamic>{"name": AppLocalizations.of(context)!.ageTracker, "widget": const AgeTracker(), "color": const Color.fromARGB(255, 70, 130, 180), "icon": FontAwesomeIcons.chartBar},
    <String, dynamic>{"name": AppLocalizations.of(context)!.diseaseTracker, "widget": const DiseasesTracker(), "color": const Color.fromARGB(255, 10, 186, 181), "icon": FontAwesomeIcons.chartPie},
    <String, dynamic>{"name": AppLocalizations.of(context)!.bloodTypes, "widget": const BloodTypeTracker(), "color": green, "icon": FontAwesomeIcons.chartLine},
    <String, dynamic>{"name": AppLocalizations.of(context)!.specialities, "widget": const DoctorsPerSpeciality(), "color": const Color.fromARGB(255, 255, 204, 0), "icon": FontAwesomeIcons.chartColumn},
    <String, dynamic>{"name": "Heart Beats", "widget": const HeartBeats(), "color": const Color.fromARGB(255, 0, 255, 187), "icon": FontAwesomeIcons.heartPulse},
  ];
  return adminCardsList;
}

const List<Transition> animatedTransitions = Transition.values;

Future<void> goTo(Widget place) async {
  await Get.to(place, transition: animatedTransitions[Random().nextInt(animatedTransitions.length)], duration: 300.ms);
}
