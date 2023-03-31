import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const Color white = Colors.white;
const Color black = Colors.black;
const Color darkBlue = Color(0xff272336); //const Color.fromARGB(255, 24, 25, 26);
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
    /*AppLocalizations.of(context)!.social_worker,*/
    {
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F1-min.jpg?alt=media&token=e8e0e7eb-e787-4731-8adb-c6d3ae0e5b23",
      "speciality": "Surgeons and surgical assistants",
      "description": 'Surgeons are specialized medical doctors who perform invasive procedures to treat injuries and diseases. Surgical assistants work under the surgeon\'s direction to support various aspects of the surgical procedure. Their tasks include preparing the operating room, positioning the patient, handing surgical instruments to the surgeon, and providing other support services.',
      "color": white,
    },
    {
      "color": darkBlue,
      "description": 'Anesthesiologists are medical doctors who specialize in administering anesthesia to patients during surgical or medical procedures. They are responsible for monitoring the patient\'s vital signs and adjusting the anesthesia as needed during the procedure. Anesthesiology assistants are healthcare professionals who work under the supervision of anesthesiologists to assist in administering anesthesia and monitoring patients.',
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F2-min.jpg?alt=media&token=5f1050dd-6e82-48ad-b7dd-ad6f9430e967",
      "speciality": "Anesthesiologists and anesthesiology assistants",
    },
    {
      "color": darkBlue,
      "description": 'Anesthesiologists are medical doctors who specialize in administering anesthesia and managing pain during medical procedures. Anesthesiology assistants are healthcare professionals who work under the supervision of anesthesiologists to provide support services during anesthesia administration.',
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F3-min.jpg?alt=media&token=c5d93efb-a3a0-4ef0-9648-669e31ddcde8",
      "speciality": "Nurses and nurse practitioners",
    },
    {
      "color": darkBlue,
      "description": 'Phlebotomists are healthcare professionals who specialize in drawing blood from patients for medical testing and donation. They are responsible for properly identifying patients, selecting appropriate venipuncture sites, collecting blood specimens, labeling samples, and transporting them to the laboratory for analysis. Phlebotomists may work in hospitals, clinics, blood banks, or other healthcare settings.',
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F4-min.jpg?alt=media&token=77a970d6-85fb-4d88-b4a9-85fec5cbf0d4",
      "speciality": "Phlebotomists",
    },
    {
      "color": white,
      "description": 'Medical laboratory technicians and technologists are healthcare professionals who perform laboratory tests and analyze results to diagnose and treat diseases. They are responsible for preparing and analyzing specimens such as blood, urine, tissue, and other bodily fluids, and for operating and maintaining laboratory equipment. Medical laboratory technicians typically have a two-year associate degree, while medical laboratory technologists usually have a four-year bachelor\'s degree in medical technology or a related field.',
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F5-min.jpg?alt=media&token=92e3fb9b-7de3-4d64-a83c-0125ab2a0af1",
      "speciality": "Medical laboratory technicians and technologists",
    },
    {
      "color": white,
      "description": 'EMTs (Emergency Medical Technicians) and paramedics are healthcare professionals who respond to emergency situations and provide medical care and transportation to patients in need. EMTs and paramedics are trained to provide basic life support (BLS) and advanced life support (ALS) interventions such as administering medications, performing CPR, and using defibrillators. They may work for ambulance services, fire departments, or hospitals.',
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F6-min.jpg?alt=media&token=b59680f2-d007-49a0-b1a9-1946f829ea86",
      "speciality": "EMTs and paramedics",
    },
    {
      "color": darkBlue,
      "description": 'Dentists are healthcare professionals who diagnose, treat, and prevent oral diseases and conditions, as well as maintain the overall health of their patients\' teeth and gums. Dental hygienists are licensed oral health professionals who work alongside dentists to provide preventive care, such as cleaning teeth, taking x-rays, and educating patients on proper oral hygiene practices. They may work in private dental offices, clinics, or other healthcare settings.',
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F7-min.jpg?alt=media&token=6e1c68ee-42ae-427a-ae61-c011f4ef2342",
      "speciality": "Dentists and dental hygienists",
    },
    {
      "color": darkBlue,
      "description": 'Ophthalmologists are medical doctors who specialize in diagnosing and treating eye conditions, such as glaucoma, cataracts, and macular degeneration. Optometrists are healthcare professionals who specialize in providing vision care, such as prescribing glasses and contact lenses.',
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F8-min.jpg?alt=media&token=3a8772cb-cbb5-4ad8-b7d7-7c07a0b05305",
      "speciality": "Ophthalmologists and optometrists",
    },
    {
      "color": white,
      "description": 'Physical therapists are healthcare professionals who help patients recover from injuries or illnesses by providing exercises and other therapies to improve mobility and strength. Occupational therapists are healthcare professionals who help patients recover from injuries or illnesses by providing exercises and other therapies to improve their ability to perform daily tasks.',
      "speciality": "Physical therapists and occupational therapists",
      'url': "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/specialities%2F9-min.jpg?alt=media&token=d038757d-dbc1-4e7d-b47e-6ba5f9b4d332",
    },
    {
      "color": white,
      "description": 'Chiropractors are healthcare professionals who specialize in diagnosing and treating musculoskeletal conditions, such as back pain and neck pain, using spinal manipulation and other techniques. Massage therapists use manual manipulation of muscles and soft tissues to promote relaxation, relieve pain, and improve circulation.',
      "speciality": "Chiropractors and massage therapists",
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
        return AppLocalizations.of(context)!.email_regex1;
      } else if (!text.contains(RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$'))) {
        return AppLocalizations.of(context)!.email_regex2;
      }
      return null;
    },
    "password": (String? text) {
      if (text!.isEmpty) {
        return AppLocalizations.of(context)!.password_regex1;
      } else if (!text.contains(RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$'))) {
        return AppLocalizations.of(context)!.password_regex2;
      }
      return null;
    },
    "username": (String? text) {
      if (text!.isEmpty) {
        return AppLocalizations.of(context)!.username_regex1;
      } else if (!text.contains(RegExp(r'^[a-zA-Z][\w ]+$'))) {
        return AppLocalizations.of(context)!.username_regex2;
      }
      return null;
    },
    "id": (String? text) {
      if (text!.isEmpty) {
        return AppLocalizations.of(context)!.id_regex1;
      } else if (!text.contains(RegExp(r'^\#[a-z0-9]{4,14}$'))) {
        return AppLocalizations.of(context)!.id_regex2;
      }
      return null;
    },
    "age": (String? text) {
      if (text!.isEmpty) {
        return "Empty Age";
      } else if (!text.contains(RegExp(r'^\#[a-z0-9]{4,14}$'))) {
        return "Age Contains Only Digits.";
      }
      return null;
    },
    "job location": (String? text) {
      if (text!.isEmpty) {
        return AppLocalizations.of(context)!.job_location_regex1;
      } else if (!text.contains(RegExp(r'^.{4,35}$'))) {
        return AppLocalizations.of(context)!.cin_regex2;
      }
      return null;
    },
    "speciality": (String? text) {
      if (text!.isEmpty) {
        return AppLocalizations.of(context)!.speciality_regex1;
      }
      return null;
    },
  };

  return fieldsValidators[text];
}

Map<int, String> weekDayPredictor = <int, String>{1: "Mon", 2: "Tue", 3: "Wed", 4: "Thu", 5: "Fri", 6: "Sat", 7: "Sun"};

String appTitle = "Smart Care";
String appIcon = "https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/health.png?alt=media&token=5b9a461b-bf46-4dfd-bc83-e8ec9a66f990";

String aboutUs = "Welcome to our telemedicine platform, built using the Flutter cross-platform framework, designed to provide primary prevention and prompt medical assistance in case of an AES (accident d'explosion du sang). Our platform is not only for patients, but it also caters to healthcare professionals who can monitor their patient's health status in real-time. Our platform's primary objective is to assist people in preventing AES by conducting daily and monthly checkups and sending SMS or notification reminders. In case of an AES event, our platform provides a workflow that patients can follow and get the final results from our laboratory experts. We understand the importance of medical assistance during an AES event; hence, we have provided a direct chat option with doctors. In addition, we have integrated a smart chatbot built on top of ChatGPT 3.5 for faster responses to queries when doctors are unavailable. Our telemedicine platform is fully customizable, with two themes - light and dark, and supports eight languages, making it user-friendly for people from diverse backgrounds. You can also enable gesture and message sounds to personalize your experience.Our platform offers a multitude of benefits for both patients and healthcare professionals. Patients can access medical assistance from the comfort of their homes, while healthcare professionals can monitor their patient's health status and offer timely intervention. We believe that our telemedicine platform can help reduce the incidence of AES and save lives.";

List<Map<String, dynamic>> healthcareFacilities = [
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
