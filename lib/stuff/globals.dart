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
const String template =
    '''
<svg xmlns="http://www.w3.org/2000/svg" width="1080" height="1080" viewBox="0 0 1080 1080" version="1.1"><path d="M 0 28.844 L 0 57.687 7.750 64.222 C 42.468 93.496, 64.898 103.053, 99 103.101 C 119.147 103.129, 135.537 99.263, 154.500 90.010 C 179.547 77.788, 204.843 55.747, 236.001 19 C 242.762 11.025, 249.207 3.488, 250.322 2.250 L 252.349 0 126.174 0 L 0 0 0 28.844 M 962.324 114.380 C 953.275 117.339, 946.590 123.390, 942.378 132.435 C 940.516 136.434, 940.017 139.202, 940.010 145.590 C 940.001 152.611, 940.401 154.484, 943.036 159.757 C 946.499 166.687, 952.162 172.262, 958.878 175.353 C 965.405 178.357, 978.595 178.357, 985.122 175.353 C 991.838 172.262, 997.501 166.687, 1000.964 159.757 C 1003.603 154.475, 1004 152.610, 1004 145.500 C 1004 138.390, 1003.603 136.525, 1000.964 131.243 C 997.475 124.261, 991.769 118.672, 985.122 115.725 C 979.338 113.161, 968.083 112.496, 962.324 114.380 M 848.239 504.335 C 842.996 506.236, 838.418 510.520, 835.613 516.149 C 832.421 522.555, 832.247 528.742, 835.084 535 C 837.622 540.598, 840.360 543.581, 845.500 546.347 C 849.489 548.494, 849.726 548.501, 932 548.791 C 991.518 549, 1015.654 548.763, 1018.644 547.940 C 1023.914 546.489, 1029.500 541.900, 1032.029 536.943 C 1034.560 531.981, 1034.744 520.370, 1032.370 515.368 C 1030.248 510.895, 1024.026 505.624, 1019.142 504.161 C 1013.577 502.493, 852.864 502.657, 848.239 504.335 M 845 733.666 C 816.101 736.523, 782.500 747.194, 752 763.202 C 719.752 780.128, 697.844 795.227, 650 833.499 C 616.455 860.334, 604.937 868.994, 587.500 880.492 C 554.472 902.270, 527.550 914.237, 497.379 920.555 C 478.699 924.466, 448.976 925.127, 427.500 922.108 C 403.920 918.793, 384.928 912.970, 364.765 902.872 C 343.379 892.162, 329.076 881.739, 308.154 861.617 C 277.107 831.757, 260.896 818.186, 239 803.725 C 223.563 793.530, 202.302 782.800, 187 777.482 C 173.686 772.855, 152.404 768.417, 136.246 766.898 C 94.029 762.929, 43.534 773.557, 7 794.103 L 0.500 797.758 0.247 938.880 L -0.007 1080.002 540.247 1079.751 L 1080.500 1079.500 1080.518 938 C 1080.528 860.175, 1080.303 815.384, 1080.018 838.464 L 1079.500 880.428 1064.577 860.464 C 1033.554 818.960, 1012.944 795.319, 994 779.509 C 964.269 754.697, 925.508 738.264, 886.789 734.055 C 877.834 733.082, 853.227 732.853, 845 733.666 M 0.486 939 C 0.486 1016.825, 0.605 1048.662, 0.750 1009.750 C 0.895 970.837, 0.895 907.162, 0.750 868.250 C 0.605 829.337, 0.486 861.175, 0.486 939" stroke="none" fill="#fbfbfb" fill-rule="evenodd"/><path d="M 238.414 16.250 C 213.675 45.383, 190.764 67.507, 172.967 79.449 C 163.260 85.962, 147.484 93.900, 138 97.044 C 114.085 104.970, 84.142 105.132, 61.282 97.459 C 43.406 91.458, 30.791 83.433, 3.421 60.653 L -0 57.806 0 427.985 L 0 798.163 3.250 796.164 C 7.945 793.276, 21.900 786.409, 28.141 783.916 C 73.383 765.844, 117.588 761.593, 162.737 770.974 C 203.180 779.377, 242.483 801.340, 283.471 838.443 C 288.974 843.424, 300.081 853.853, 308.154 861.617 C 329.076 881.739, 343.379 892.162, 364.765 902.872 C 384.928 912.970, 403.920 918.793, 427.500 922.108 C 448.976 925.127, 478.699 924.466, 497.379 920.555 C 527.550 914.237, 554.472 902.270, 587.500 880.492 C 604.937 868.994, 616.455 860.334, 650 833.499 C 697.871 795.205, 719.825 780.077, 752 763.212 C 788.532 744.063, 822.214 734.467, 857.056 733.282 C 891.911 732.097, 922.369 738.454, 953.500 753.411 C 990.855 771.359, 1016.326 795.907, 1064.577 860.466 L 1079.500 880.432 1080.108 833.466 C 1080.952 768.204, 1081.146 95.123, 1080.336 42.750 L 1079.674 0 665.943 0 L 252.213 0 238.414 16.250 M 0.495 428 C 0.495 631.775, 0.610 715.138, 0.750 613.250 C 0.890 511.363, 0.890 344.638, 0.750 242.750 C 0.610 140.863, 0.495 224.225, 0.495 428 M 962.324 114.380 C 953.275 117.339, 946.590 123.390, 942.378 132.435 C 940.516 136.434, 940.017 139.202, 940.010 145.590 C 940.001 152.611, 940.401 154.484, 943.036 159.757 C 946.499 166.687, 952.162 172.262, 958.878 175.353 C 965.405 178.357, 978.595 178.357, 985.122 175.353 C 991.838 172.262, 997.501 166.687, 1000.964 159.757 C 1003.603 154.475, 1004 152.610, 1004 145.500 C 1004 138.390, 1003.603 136.525, 1000.964 131.243 C 997.475 124.261, 991.769 118.672, 985.122 115.725 C 979.338 113.161, 968.083 112.496, 962.324 114.380 M 848.239 504.335 C 842.996 506.236, 838.418 510.520, 835.613 516.149 C 832.421 522.555, 832.247 528.742, 835.084 535 C 837.622 540.598, 840.360 543.581, 845.500 546.347 C 849.489 548.494, 849.726 548.501, 932 548.791 C 991.518 549, 1015.654 548.763, 1018.644 547.940 C 1023.914 546.489, 1029.500 541.900, 1032.029 536.943 C 1034.560 531.981, 1034.744 520.370, 1032.370 515.368 C 1030.248 510.895, 1024.026 505.624, 1019.142 504.161 C 1013.577 502.493, 852.864 502.657, 848.239 504.335" stroke="none" fill="#0a4177" fill-rule="evenodd"/></svg>''';

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
