import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
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

final AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();
