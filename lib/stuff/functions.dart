import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:sqflite/sqflite.dart';

void showToast(String content, {Color? color}) {
  Fluttertoast.showToast(
    msg: content.replaceAll(RegExp(r'\[.+\] '), ''),
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
