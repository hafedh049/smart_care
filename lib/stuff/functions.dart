import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_care/stuff/globals.dart';
import 'package:translator/translator.dart';

Future<Translation> translateTo(String text, {to = 'en'}) async {
  return await translator.translate(text, to: to);
}

TextSpan customTextSpan() {
  return TextSpan(
    text: "Don't have an account? ",
    style: GoogleFonts.abel(fontSize: 16),
  );
}

void showToast(String content) {
  Fluttertoast.showToast(
    msg: content,
    backgroundColor: blue.withOpacity(.3),
    fontSize: 14,
    gravity: ToastGravity.TOP,
    toastLength: Toast.LENGTH_LONG,
    textColor: white,
    timeInSecForIosWeb: 3,
  ).then((value) => playNote("task"));
}

void playNote(String note) {
  player.open(Audio("assets/$note.mp3"));
}

Future<void> sendSms(String toNumber, String messageBody) async {
  await twilio.sendSMS(
    toNumber: toNumber,
    messageBody: messageBody,
  );
}
