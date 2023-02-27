import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:twilio_flutter/twilio_flutter.dart' show TwilioFlutter;
import 'package:translator/translator.dart';

Color white = Colors.white;
Color darkBlue = const Color.fromARGB(30, 7, 32, 60);
Color transparent = Colors.transparent;
Color blue = const Color.fromARGB(255, 0, 80, 146);

bool firstTime = true;

final List<String> specialityList = <String>[
  "Physician",
  "Nurse",
  "Dentist",
  "Pharmacist",
  "Physical Therapist",
  "Occupational Therapist",
  "Optometrist",
  "Social worker",
];

final GoogleTranslator translator = GoogleTranslator();

String language = "en";

final GlobalKey<ScaffoldState> getStartedScaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldState> signInScaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldState> signUpScaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldState> recoveryScaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldState> otp1ScaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldState> otp2ScaffoldKey = GlobalKey<ScaffoldState>();

final AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();

final twilio = TwilioFlutter(
  accountSid: 'AC6558f5e09f679ad1bb3b4c378e9ac957',
  authToken: '43affd5a6a62193cdcdcb4f0b963b29a',
  twilioNumber: '23566502',
);

SmsReceiver receiver = SmsReceiver();

Map<String, String? Function(String?)?> fieldsValidators = <String, String? Function(String?)?>{
  "email": (String? text) {
    if (text!.isEmpty) {
      return language == "en" ? "E-mail is mandatory" : "E-mail est obligatoire";
    } else if (!text.toLowerCase().contains(RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$'))) {
      return language == "en" ? "Please verify your e-mail" : "Veuillez vérifier votre e-mail";
    }
    return null;
  },
  "password": (String? text) {
    if (text!.isEmpty) {
      return language == "en" ? "Password should not be empty" : "Le mot de passe ne doit pas être vide";
    } else if (!text.toLowerCase().contains(RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$'))) {
      return language == "en" ? "Password expression should be at least 8 characters, must contain at least 1 uppercase letter, 1 lowercase letter, and 1 number and can contain special characters" : "L'expression du mot de passe doit comporter au moins 8 caractères, doit contenir au moins 1 lettre majuscule, 1 lettre minuscule et 1 chiffre et peut contenir des caractères spéciaux";
    }
    return null;
  },
  "username": (String? text) {
    if (text!.isEmpty) {
      return language == "en" ? "Name field is empty." : "Le champ nom est vide.";
    } else if (!text.toLowerCase().contains(RegExp(r'^[a-zA-Z][a-zA-Z0-9-_]{3,32}$'))) {
      return language == "en" ? "This field must start with an alphabetic character. Can contain the following characters: a-z A-Z 0-9 - and _" : "Ce champ doit commencer par un caractère alphabétique. Peut contenir les caractères suivants : a-z A-Z 0-9 - et _";
    }
    return null;
  },
  "cin": (String? text) {
    if (text!.isEmpty) {
      return language == "en" ? "CIN field is mandatory." : "Le champ CIN est obligatoire.";
    } else if (!text.toLowerCase().contains(RegExp(r'^[0-9]{8}$'))) {
      return language == "en" ? "CIN field should contains 8 digits." : "Le champ CIN doit contenir 8 chiffres.";
    }
    return null;
  },
  "service": (String? text) {
    if (text!.isEmpty) {
      return language == "en" ? "Service field must not be empty." : "Le champ service ne doit pas être vide.";
    } else if (!text.toLowerCase().contains(RegExp(r'^[ \w]{3,}$'))) {
      return language == "en" ? "Incorrect or unknown service." : "Incorrect or unknown service.";
    }
    return null;
  },
  "id": (String? text) {
    if (text!.isEmpty) {
      return language == "en" ? "ID must not be empty." : "Le champ du ID ne doit pas être vide.";
    } else if (!text.toLowerCase().contains(RegExp(r'^[\#a-z0-9]{8,14}$'))) {
      return language == "en" ? "Wrong format for ID. It must start with # and contains alphanumeric caracters." : "Mauvais format pour l'ID. Il doit commencer par # et contenir des caractères alphanumériques.";
    }
    return null;
  },
  "job location": (String? text) {
    if (text!.isEmpty) {
      return language == "en" ? "You must provide your work location please." : "Vous devez fournir votre lieu de travail s'il vous plaît.";
    } else if (!text.toLowerCase().contains(RegExp(r'^.{4,35}$'))) {
      return language == "en" ? "Please write a clear and existing work location." : "Veuillez écrire un lieu de travail clair et existant.";
    }
    return null;
  },
};
