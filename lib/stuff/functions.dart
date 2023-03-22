// ignore_for_file: use_build_context_synchronously

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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
  );
}

Future<void> openDB() async {
  db = await openDatabase(
    "database.db",
    version: 1,
    onCreate: (Database db, int version) {
      db.execute("CREATE TABLE SMART_CARE (ID INTEGER PRIMARY KEY , FIRST_TIME INTEGER, AUDIO INTEGER);");
      db.insert("SMART_CARE", <String, dynamic>{"FIRST_TIME": 1, "ID": 1, "AUDIO": 1});
    },
  );
}

Future<String> takesFromCameraOrGallery(bool camera) async {
  try {
    XFile? image = await ImagePicker().pickImage(source: camera ? ImageSource.camera : ImageSource.gallery, imageQuality: 100, preferredCameraDevice: CameraDevice.front);
    if (image != null) {
      return await cropImage(image.path);
    }
    return "";
  } catch (_) {
    showToast(_.toString(), color: red);
    return "";
  }
}

Future<String> cropImage(String imagePath) async {
  try {
    CroppedFile? croppedImage = await ImageCropper().cropImage(sourcePath: imagePath);
    if (croppedImage != null) {
      return croppedImage.path;
    }
    return "";
  } catch (_) {
    showToast(_.toString(), color: red);
    return "";
  }
}

String getTimeFromDate(DateTime date) {
  String hours = date.hour.toString().padLeft(2, '0');
  String minutes = date.minute.toString().padLeft(2, '0');
  String meridian = date.hour < 12 ? 'AM' : 'PM';
  hours = (date.hour % 12).toString().padLeft(2, '0');
  return '$hours:$minutes $meridian';
}

final Map<int, dynamic> months = <int, dynamic>{
  1: "January",
  2: "February",
  3: "March",
  4: "April",
  5: "May",
  6: "June",
  7: "July",
  8: "August",
  9: "September",
  10: "October",
  11: "November",
  12: "December",
};

String getDateRepresentation(DateTime date) {
  return "${showWeekDay(date.weekday)}, ${months[date.month]} ${date.day}";
}

String showWeekDay(int day) {
  return weekDayPredictor[DateTime(DateTime.now().year, DateTime.now().month, day).weekday]!;
}

void playNote(String note) {
  player.open(Audio("assets/$note"));
}

/*Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      if (play == 1) {
        playNote("error.wav");
      }
      showToast("Location permissions are denied", color: red);
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    if (play == 1) {
      playNote("error.wav");
    }
    showToast("Location permissions are denied", color: red);
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }
  if (play == 1) {
    playNote("tap.wav");
  }
  showToast("Permission granted");
  return await Geolocator.getCurrentPosition();
}*/