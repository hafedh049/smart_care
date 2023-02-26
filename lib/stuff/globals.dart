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
