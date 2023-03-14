import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Color white = Colors.white;
Color black = Colors.black;
Color darkBlue = const Color(0xff272336); //const Color.fromARGB(255, 24, 25, 26);
Color transparent = Colors.transparent;
Color blue = const Color.fromARGB(255, 93, 172, 248);
Color red = const Color.fromARGB(255, 219, 15, 0);
Color green = Colors.lightGreenAccent;
Color grey = Colors.grey;

int? firstTime;

Map<String, dynamic> me = <String, dynamic>{};

Database? db;

List<String> specialityListFunction(BuildContext context) {
  final List<String> specialityList = <String>[
    AppLocalizations.of(context)!.physician,
    AppLocalizations.of(context)!.nurse,
    AppLocalizations.of(context)!.dentist,
    AppLocalizations.of(context)!.pharmacist,
    AppLocalizations.of(context)!.physical_therapist,
    AppLocalizations.of(context)!.occupational_therapist,
    AppLocalizations.of(context)!.optometrist,
    AppLocalizations.of(context)!.social_worker,
  ];
  return specialityList;
}

String noUser = 'https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/doctor-icon.png?alt=media&token=69e755f5-e674-4064-a97e-708f2ec8c25c';

final GlobalKey<ScaffoldState> screensScaffoldKey = GlobalKey<ScaffoldState>();

String? Function(String?)? fieldsValidatorsFunction(String text, BuildContext context) {
  Map<String, String? Function(String?)?> fieldsValidators = <String, String? Function(String?)?>{
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
    "cin": (String? text) {
      if (text!.isEmpty) {
        return AppLocalizations.of(context)!.cin_regex1;
      } else if (!text.contains(RegExp(r'^[0-9]{8}$'))) {
        return AppLocalizations.of(context)!.cin_regex2;
      }
      return null;
    },
    "service": (String? text) {
      if (text!.isEmpty) {
        return AppLocalizations.of(context)!.service_regex1;
      } else if (!text.contains(RegExp(r'^[ \wéçèà]{3,}$'))) {
        return AppLocalizations.of(context)!.service_regex2;
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
