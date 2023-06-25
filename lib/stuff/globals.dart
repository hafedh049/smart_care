import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../screens/admin/charts/grades.dart';
import '../screens/admin/charts/hospitals.dart';
import '../screens/admin/charts/services.dart';

//colors
const Color white = Colors.white;
const Color black = Colors.black;
const Color darkBlue = Color(0xff272336);
const Color transparent = Colors.transparent;
const Color blue = Color.fromARGB(255, 93, 172, 248);
const Color red = Color.fromARGB(255, 219, 15, 0);
const Color green = Colors.lightGreenAccent;
const Color grey = Colors.grey;

//global variables
int? firstTime;
int themeMode = 0;
String userToken = "";
const String appTitle = "Smart Care";
const String aboutUs = "Welcome to our telemedicine platform, built using the Flutter cross-platform framework, designed to provide primary prevention and prompt medical assistance in case of an AES (accident d'explosion du sang). Our platform is not only for patients, but it also caters to healthcare professionals who can monitor their patient's health status in real-time. Our platform's primary objective is to assist people in preventing AES by conducting daily and monthly checkups and sending SMS or notification reminders. In case of an AES event, our platform provides a workflow that patients can follow and get the final results from our laboratory experts. We understand the importance of medical assistance during an AES event; hence, we have provided a direct chat option with doctors. In addition, we have integrated a smart chatbot built on top of ChatGPT 3.5 for faster responses to queries when doctors are unavailable. Our telemedicine platform is fully customizable, with two themes - light and dark, and supports eight languages, making it user-friendly for people from diverse backgrounds. You can also enable gesture and message sounds to personalize your experience.Our platform offers a multitude of benefits for both patients and healthcare professionals. Patients can access medical assistance from the comfort of their homes, while healthcare professionals can monitor their patient's health status and offer timely intervention. We believe that our telemedicine platform can help reduce the incidence of AES and save lives.";

//API-Keys
const String gpt3ApiKey = "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";
const String gpt3ApiUrl = 'https://api.openai.com/v1/engines/davinci/completions'; //https://api.openai.com/v1/completions
const String newsApiKey = "4ab974b0133747658c75513590257f4e";

//User Data
Map<String, dynamic> me = <String, dynamic>{};

//Database Reference
Database? db;

//Network Images
const String chatBot = "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/smart_bot.png?alt=media&token=99ba8285-3b29-489a-a473-a81cc228e3d3";
const String noUser = 'https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/noUser.png?alt=media&token=476f6c72-ce24-497e-ad28-d4e3e0b3ee6b';
const String rodeOfAsclepius = "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/virus.jpg?alt=media&token=0bdcf248-dab6-4e77-a7f5-ce8a9667fc19";
const String doctorRod = "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/WallpaperDog-5497244-min.jpg?alt=media&token=d66c6ae6-8b28-4c58-8d1f-2d41106f44b3";
const String appIcon = "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/health.png?alt=media&token=5b9a461b-bf46-4dfd-bc83-e8ec9a66f990";
const String avuRL = "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/av.png?alt=media&token=f6f072a1-c011-4c35-aaa4-946f100ba206&_gl=1*y63jnt*_ga*MTE5NDk5NjQ4MS4xNjgyOTgwODQx*_ga_CW55HF8NVT*MTY4NTc1MTk2OC41Ny4xLjE2ODU3NTIwMDcuMC4wLjA.";

//Data Structures
final List<Map<String, dynamic>> gradesList = <Map<String, dynamic>>[
  {
    'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F1-min.jpg?alt=media&token=e8e0e7eb-e787-4731-8adb-c6d3ae0e5b23",
    "grade": "Expert métier".tr,
    "description": "Surgeons and surgicals",
  },
  {
    'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F1-min.jpg?alt=media&token=e8e0e7eb-e787-4731-8adb-c6d3ae0e5b23",
    "grade": "Expert métier".tr,
    "description": "Surgeons and surgicals",
  },
];

final Map<int, dynamic> months = <int, dynamic>{1: "January", 2: "February", 3: "March", 4: "April", 5: "May", 6: "June", 7: "July", 8: "August", 9: "September", 10: "October", 11: "November", 12: "December"};

final Map<int, String> weekDayPredictor = <int, String>{1: "Mon", 2: "Tue", 3: "Wed", 4: "Thu", 5: "Fri", 6: "Sat", 7: "Sun"};

final List<Map<String, dynamic>> healthcareFacilities = <Map<String, dynamic>>[
  <String, dynamic>{"name": "Centre Hospitalier Universitaire Fattouma Bourguiba de Monastir", "latitude": 35.7611469, "longitude": 10.8125058},
  <String, dynamic>{"name": "Clinique les Oliviers Monastir", "latitude": 35.7667159, "longitude": 10.8322074},
  <String, dynamic>{"name": "Clinique El Amen Monastir", "latitude": 35.7713949, "longitude": 10.8206096},
  <String, dynamic>{"name": "Polyclinique des Palmiers Monastir", "latitude": 35.7604815, "longitude": 10.827065},
  <String, dynamic>{"name": "Clinique Internationale Monastir", "latitude": 35.768876, "longitude": 10.8319216},
  <String, dynamic>{"name": "Clinique Al Hikma Monastir", "latitude": 35.7701055, "longitude": 10.8300627},
  <String, dynamic>{"name": "Clinique Monastir Médical", "latitude": 35.7720048, "longitude": 10.8286933},
  <String, dynamic>{"name": "Clinique Al Amana Monastir", "latitude": 35.7712026, "longitude": 10.8256544},
  <String, dynamic>{"name": "Polyclinique Al Azhar Monastir", "latitude": 35.7616056, "longitude": 10.8219744},
  <String, dynamic>{"name": "Clinique Taoufik Monastir", "latitude": 35.7640652, "longitude": 10.8251672},
  <String, dynamic>{"name": "Polyclinique de la Rose Monastir", "latitude": 35.7631194, "longitude": 10.8342604},
  <String, dynamic>{"name": "Polyclinique Essafaa Monastir", "latitude": 35.7627449, "longitude": 10.8324411},
  <String, dynamic>{"name": "Polyclinique Monastir El Wifak", "latitude": 35.7659385, "longitude": 10.8295595},
  <String, dynamic>{"name": "Hôpital de Moknine", "latitude": 35.6078568, "longitude": 10.995835},
  <String, dynamic>{"name": "Hôpital de Zéramdine", "latitude": 35.4122763, "longitude": 10.978685},
  <String, dynamic>{"name": "Hôpital de Jemmal", "latitude": 35.5655434, "longitude": 10.9052743},
  <String, dynamic>{"name": "Hôpital de Ksar Hellal", "latitude": 35.670407, "longitude": 10.877977},
  <String, dynamic>{"name": "Hôpital de Sahline", "latitude": 35.7840403, "longitude": 10.6963433},
  <String, dynamic>{"name": "Hôpital de Sayada", "latitude": 36.8730225, "longitude": 10.326227},
  <String, dynamic>{"name": "Faculté de Médecine de Monastir", "latitude": 35.7763282, "longitude": 10.8267896}
];

final List<Map<String, dynamic>> charts = <Map<String, dynamic>>[
  <String, dynamic>{"name": 'Hospitals Chart'.tr, "widget": const Hospitals(), "color": const Color.fromARGB(255, 70, 130, 180), "icon": FontAwesomeIcons.chartBar},
  <String, dynamic>{"name": 'Grades Chart'.tr, "widget": const Grades(), "color": green, "icon": FontAwesomeIcons.chartLine},
  <String, dynamic>{"name": 'Services Chart'.tr, "widget": const Services(), "color": const Color.fromARGB(255, 255, 204, 0), "icon": FontAwesomeIcons.chartColumn},
];

const List<Transition> animatedTransitions = Transition.values;

final Map<String, String? Function(String?)?> fieldsValidator = <String, String? Function(String?)?>{
  "about": (String? text) {
    return null;
  },
  "email": (String? text) {
    if (text!.isEmpty) {
      return 'emailismandatory'.tr;
    } else if (!text.contains(RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$'))) {
      return 'pleaseverifyyourEmail'.tr;
    }
    return null;
  },
  "password": (String? text) {
    if (text!.isEmpty) {
      return 'passwordshouldnotbeempty'.tr;
    } else if (!text.contains(RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z0-9]{6,}$'))) {
      return 'passwordexpressionshouldbeatleastcharactersmustcontainatleastuppercaseletterlowercaseletterandnumberandcancontainspecialcharacters'.tr;
    }
    return null;
  },
  "username": (String? text) {
    if (text!.isEmpty) {
      return 'namefieldisempty'.tr;
    } else if (!text.contains(RegExp(r'^[a-zA-Z][\w ]+$'))) {
      return 'thisfieldmuststartwithanalphabeticcharacter'.tr;
    }
    return null;
  },
  "id": (String? text) {
    if (text!.isEmpty) {
      return 'iDmustnotbeempty'.tr;
    } else if (!text.contains(RegExp(r'^\d{8}$'))) {
      return 'wrongformatforIDItmuststartwithandcontainsalphanumericcaracters'.tr;
    }
    return null;
  },
};

final List<Map<String, dynamic>> workflow = <Map<String, dynamic>>[
  <String, dynamic>{
    'index': 0,
    "title": "Description De La Lésion",
    "options": <Map<String, dynamic>>[
      <String, dynamic>{"content": "Superficielle", "redirectTo": 1},
      <String, dynamic>{"content": "Profond", "redirectTo": 1},
    ],
  },
  <String, dynamic>{
    'index': 1,
    "title": "Mécanisme",
    "options": <Map<String, dynamic>>[
      <String, dynamic>{"content": "Piqûre par une aiguille pleine", "redirectTo": 2},
      <String, dynamic>{"content": "Piqûre par une aiguille creuse", "redirectTo": 2},
      <String, dynamic>{"content": "Piqûre Non précisée", "redirectTo": 2},
      <String, dynamic>{"content": "Coupure", "redirectTo": 2},
      <String, dynamic>{"content": "Projection de sang", "redirectTo": 2},
      <String, dynamic>{"content": "Projection du liquide biologique", "redirectTo": 2},
    ],
  },
  <String, dynamic>{
    'index': 2,
    "title": "Le Malade-Source",
    "options": <Map<String, dynamic>>[
      <String, dynamic>{"content": "Inconnu", "redirectTo": 3},
      <String, dynamic>{"content": "Externe", "redirectTo": 3},
      <String, dynamic>{"content": "Hospitalisé", "redirectTo": 3},
    ],
  },
  <String, dynamic>{
    'index': 3,
    "title": "Quel est le virus avec lequel le patient source est infecté ?",
    "options": <Map<String, dynamic>>[
      <String, dynamic>{"content": "VHB", "redirectTo": 4},
      <String, dynamic>{"content": "VHC", "redirectTo": 9},
      <String, dynamic>{"content": "HIV", "redirectTo": 12},
    ],
  },
  <String, dynamic>{
    'index': 4,
    "title": "VHB",
    "options": <Map<String, dynamic>>[
      <String, dynamic>{"content": "Vaccinée immunisée, anticorps anti-hépatite B surface (AntiHBS) positif", "redirectTo": 5},
      <String, dynamic>{"content": "AC anti HBS > 10 (UI/L)", "redirectTo": 6},
    ],
  },
  <String, dynamic>{'index': 5, "end": "Vous n'êtes pas affecté par un virus tant que vous etes immunisées"},
  <String, dynamic>{
    'index': 6,
    "title": "",
    "options": <Map<String, dynamic>>[
      <String, dynamic>{"content": "Patient source AgHBS +", "redirectTo": 7},
      <String, dynamic>{"content": "Patient source AgHBS -", "redirectTo": 8},
    ],
  },
  <String, dynamic>{'index': 7, "end": "vous devez prendre une injection d'immunoglobuline dans un délai de 72 heures"},
  <String, dynamic>{'index': 8, "end": ""},
  <String, dynamic>{
    'index': 9,
    "title": "VHC",
    "options": <Map<String, dynamic>>[
      <String, dynamic>{"content": "Patient Source positive (+) : Virus de l'Hépatite C (VHC) positif ou statut inconnu.", "redirectTo": 11},
      <String, dynamic>{"content": "Patient Source negative (-)", "redirectTo": 10},
    ],
  },
  <String, dynamic>{'index': 10, "end": "Pas De Profelaxie"},
  <String, dynamic>{'index': 11, "end": "Pas De Profelaxie"},
  <String, dynamic>{
    'index': 12,
    "title": "HIV",
    "options": <Map<String, dynamic>>[
      <String, dynamic>{"content": "Patient source positive : Virus de l'Immunodéficience Humaine (VIH) positif.", "redirectTo": 13},
      <String, dynamic>{"content": "Patient source positive : Virus de l'Immunodéficience Humaine (VIH) négatif.", "redirectTo": 14},
      <String, dynamic>{"content": "Patient source positive : Virus de l'Immunodéficience Humaine (VIH) inconnu.", "redirectTo": 15},
    ],
  },
  <String, dynamic>{'index': 13, "end": ""},
  <String, dynamic>{'index': 14, "end": "Pas De Profelaxie"},
  <String, dynamic>{'index': 15, "end": ""},
];
