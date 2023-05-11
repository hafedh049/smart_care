import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_care/screens/admin/add_user.dart';
import 'package:smart_care/screens/admin/create_article.dart';
import 'package:smart_care/screens/admin/delete_and_modify_article.dart';
import 'package:sqflite/sqflite.dart';

import '../screens/admin/charts/ages.dart';
import '../screens/admin/charts/blood_types_tracker.dart';
import '../screens/admin/charts/diseases.dart';
import '../screens/admin/charts/doctors_per_speciality.dart';
import '../screens/admin/doctors_list.dart';
import '../screens/admin/patients_list.dart';

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
int darkTheme = 1;
int? play;
String userToken = "";
const String appTitle = "Smart Care";
const String aboutUs = "Welcome to our telemedicine platform, built using the Flutter cross-platform framework, designed to provide primary prevention and prompt medical assistance in case of an AES (accident d'explosion du sang). Our platform is not only for patients, but it also caters to healthcare professionals who can monitor their patient's health status in real-time. Our platform's primary objective is to assist people in preventing AES by conducting daily and monthly checkups and sending SMS or notification reminders. In case of an AES event, our platform provides a workflow that patients can follow and get the final results from our laboratory experts. We understand the importance of medical assistance during an AES event; hence, we have provided a direct chat option with doctors. In addition, we have integrated a smart chatbot built on top of ChatGPT 3.5 for faster responses to queries when doctors are unavailable. Our telemedicine platform is fully customizable, with two themes - light and dark, and supports eight languages, making it user-friendly for people from diverse backgrounds. You can also enable gesture and message sounds to personalize your experience.Our platform offers a multitude of benefits for both patients and healthcare professionals. Patients can access medical assistance from the comfort of their homes, while healthcare professionals can monitor their patient's health status and offer timely intervention. We believe that our telemedicine platform can help reduce the incidence of AES and save lives.";

//API-Keys
const String apiKey = "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";
const String apiUrl = 'https://api.openai.com/v1/engines/text-davinci-003/completions'; //https://api.openai.com/v1/completions

//Audio Player
final AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();

//User Data
Map<String, dynamic> me = <String, dynamic>{};

//Database Reference
Database? db;

//Network Images
const String chatBot = "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/smart_bot.png?alt=media&token=99ba8285-3b29-489a-a473-a81cc228e3d3";
const String noUser = 'https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/doctor-icon.png?alt=media&token=69e755f5-e674-4064-a97e-708f2ec8c25c';
const String rodeOfAsclepius1 = "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/virus.jpg?alt=media&token=0bdcf248-dab6-4e77-a7f5-ce8a9667fc19";
const String doctorRod = "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/WallpaperDog-5497244-min.jpg?alt=media&token=d66c6ae6-8b28-4c58-8d1f-2d41106f44b3";
const String camera = "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/upload%2Fcamera.jpg?alt=media&token=e12d3d0e-d6df-4054-b930-2f0068d26248";
const String pdf = "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/upload%2Fpdf.jpg?alt=media&token=9ecf2100-e5a0-490a-89ff-b30c1b0a5863";
const String gallery = "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/upload%2Fgallery.jpg?alt=media&token=f3a6fa1d-1f66-493a-9feb-c6d9f0037cff";
const String appIcon = "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/health.png?alt=media&token=5b9a461b-bf46-4dfd-bc83-e8ec9a66f990";

//Data Structures
final List<Map<String, dynamic>> specialityList = <Map<String, dynamic>>[
  {
    'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F1-min.jpg?alt=media&token=e8e0e7eb-e787-4731-8adb-c6d3ae0e5b23",
    "speciality": "surgeonsAndSurgicalAssistants".tr,
    "description": "Surgeons and surgical assistants",
  },
  {
    "color": darkBlue,
    "description": "anesthesiologistsAndAnesthesiologyAssistantsDescription".tr,
    'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F2-min.jpg?alt=media&token=5f1050dd-6e82-48ad-b7dd-ad6f9430e967",
    "speciality": "surgeonsAndSurgicalAssistants".tr,
  },
  {
    "color": darkBlue,
    "description": "nursesAndNursePractitionersDescription".tr,
    'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F3-min.jpg?alt=media&token=c5d93efb-a3a0-4ef0-9648-669e31ddcde8",
    "speciality": "nursesAndNursePractitioners".tr,
  },
  {
    "color": darkBlue,
    "description": "phlebotomistsDescription".tr,
    'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F4-min.jpg?alt=media&token=77a970d6-85fb-4d88-b4a9-85fec5cbf0d4",
    "speciality": "phlebotomists".tr,
  },
  {
    "color": white,
    "description": "medicalLaboratoryTechniciansAndTechnologistsDescription".tr,
    'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F5-min.jpg?alt=media&token=92e3fb9b-7de3-4d64-a83c-0125ab2a0af1",
    "speciality": "medicalLaboratoryTechniciansAndTechnologists".tr,
  },
  {
    "color": white,
    "description": "eMTsAndParamedicsDescription".tr,
    'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F6-min.jpg?alt=media&token=b59680f2-d007-49a0-b1a9-1946f829ea86",
    "speciality": "eMTsAndParamedics".tr,
  },
  {
    "color": darkBlue,
    "description": "dentistsAndDentalHygienistsDescription".tr,
    'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F7-min.jpg?alt=media&token=6e1c68ee-42ae-427a-ae61-c011f4ef2342",
    "speciality": "dentistsAndDentalHygienists".tr,
  },
  {
    "color": darkBlue,
    "description": "ophthalmologistsAndOptometristsDescription".tr,
    'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F8-min.jpg?alt=media&token=3a8772cb-cbb5-4ad8-b7d7-7c07a0b05305",
    "speciality": "ophthalmologistsAndOptometrists".tr,
  },
  {
    "color": white,
    "description": "physicalTherapistsAndOccupationalTherapistsDescription".tr,
    "speciality": "physicalTherapistsAndOccupationalTherapists".tr,
    'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F9-min.jpg?alt=media&token=d038757d-dbc1-4e7d-b47e-6ba5f9b4d332",
  },
  {
    "color": white,
    "description": "chiropractorsAndMassageTherapistsDescription".tr,
    "speciality": "chiropractorsAndMassageTherapists".tr,
    'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F10-min.jpg?alt=media&token=7ff8d3e9-5ac1-4939-99ff-d01696e5303a",
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

final List<Map<String, dynamic>> adminCards = <Map<String, dynamic>>[
  <String, dynamic>{"name": "Create Article", "widget": const CreateArticle(), "color": const Color.fromARGB(255, 155, 194, 70), "icon": FontAwesomeIcons.artstation},
  <String, dynamic>{"name": "RUD Article", "widget": const DeleteAndModifyArticles(), "color": const Color.fromARGB(255, 245, 147, 177), "icon": FontAwesomeIcons.xmark},
  <String, dynamic>{"name": "Add User", "widget": const AddUser(), "color": const Color.fromARGB(255, 0, 255, 242), "icon": FontAwesomeIcons.plus},
  <String, dynamic>{"name": 'patientsList'.tr, "widget": const PatientsList(), "color": const Color.fromARGB(255, 246, 206, 206), "icon": FontAwesomeIcons.ellipsis},
  <String, dynamic>{"name": 'doctorsList'.tr, "widget": const DoctorsList(), "color": const Color.fromARGB(255, 195, 227, 255), "icon": FontAwesomeIcons.ellipsisVertical},
  <String, dynamic>{"name": 'ageTracker'.tr, "widget": const AgeTracker(), "color": const Color.fromARGB(255, 70, 130, 180), "icon": FontAwesomeIcons.chartBar},
  <String, dynamic>{"name": 'diseaseTracker'.tr, "widget": const DiseasesTracker(), "color": const Color.fromARGB(255, 10, 186, 181), "icon": FontAwesomeIcons.chartPie},
  <String, dynamic>{"name": 'bloodTypes'.tr, "widget": const BloodTypeTracker(), "color": green, "icon": FontAwesomeIcons.chartLine},
  <String, dynamic>{"name": 'specialities'.tr, "widget": const DoctorsPerSpeciality(), "color": const Color.fromARGB(255, 255, 204, 0), "icon": FontAwesomeIcons.chartColumn},
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
    } else if (!text.contains(RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$'))) {
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
    } else if (!text.contains(RegExp(r'^\#[a-z0-9]{4,14}$'))) {
      return 'wrongformatforIDItmuststartwithandcontainsalphanumericcaracters'.tr;
    }
    return null;
  },
  "age": (String? text) {
    if (text!.isEmpty) {
      return 'emptyAge'.tr;
    } else if (!text.contains(RegExp(r'^\d{1,2}$'))) {
      return 'ageContainsOnlyDigits'.tr;
    }
    return null;
  },
  "job location": (String? text) {
    if (text!.isEmpty) {
      return 'youmustprovideyourworklocationplease'.tr;
    }
    return null;
  },
  "speciality": (String? text) {
    if (text!.isEmpty) {
      return 'pleasechooseoneofthelistedspecialities'.tr;
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
  <String, dynamic>{
    'index': 5,
    "end": "Vous n'êtes pas affecté par un virus tant que vous etes immunisées",
  },
  <String, dynamic>{
    'index': 6,
    "title": "",
    "options": <Map<String, dynamic>>[
      <String, dynamic>{"content": "Patient source AgHBS +", "redirectTo": 7},
      <String, dynamic>{"content": "Patient source AgHBS -", "redirectTo": 8},
    ],
  },
  <String, dynamic>{
    'index': 7,
    "end": "vous devez prendre une injection d'immunoglobuline dans un délai de 72 heures",
  },
  <String, dynamic>{
    'index': 8,
    "end": "",
  },
  <String, dynamic>{
    'index': 9,
    "title": "VHC",
    "options": <Map<String, dynamic>>[
      <String, dynamic>{"content": "Patient Source positive (+) : Virus de l'Hépatite C (VHC) positif ou statut inconnu.", "redirectTo": 11},
      <String, dynamic>{"content": "Patient Source negative (-)", "redirectTo": 10},
    ],
  },
  <String, dynamic>{
    'index': 10,
    "end": "Pas De Profelaxie",
  },
  <String, dynamic>{
    'index': 11,
    "end": "Pas De Profelaxie",
  },
  <String, dynamic>{
    'index': 12,
    "title": "HIV",
    "options": <Map<String, dynamic>>[
      <String, dynamic>{"content": "Patient source positive : Virus de l'Immunodéficience Humaine (VIH) positif.", "redirectTo": 13},
      <String, dynamic>{"content": "Patient source positive : Virus de l'Immunodéficience Humaine (VIH) négatif.", "redirectTo": 14},
      <String, dynamic>{"content": "Patient source positive : Virus de l'Immunodéficience Humaine (VIH) inconnu.", "redirectTo": 15},
    ],
  },
  <String, dynamic>{
    'index': 13,
    "end": "",
  },
  <String, dynamic>{
    'index': 14,
    "end": "Pas De Profelaxie",
  },
  <String, dynamic>{
    'index': 15,
    "end": "",
  },
];
