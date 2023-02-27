import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_care/stuff/globals.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sqflite/sqflite.dart';
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

void showToast(String content, {Color? color}) {
  Fluttertoast.showToast(
    msg: content,
    backgroundColor: color ?? blue.withOpacity(.3),
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

Future<String> countryCodeDetector(String number) async {
  PhoneNumber phone = await PhoneNumber.getRegionInfoFromPhoneNumber(number);
  return phone.dialCode ?? "";
}

Future<void> openDB() async {
  db = await openDatabase(
    "database.db",
    version: 1,
    onCreate: (Database db, int version) {
      db.execute("CREATE TABLE SMART_CARE (ID INTEGER PRIMARY KEY , FIRST_TIME INTEGER , IS_ACTIVE INTEGER);");
      db.insert("SMART_CARE", <String, dynamic>{"FIRST_TIME": 1, "ID": 1, "IS_ACTIVE": 1});
    },
  );
}
