// ignore_for_file: use_build_context_synchronously

//import 'dart:convert';
//import 'dart:io';

//import 'package:ansi_styles/extension.dart';
import 'dart:convert';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
//import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:sqflite/sqflite.dart';

void showToast({required String text, Color? color}) {
  Fluttertoast.showToast(
    msg: text.replaceAll(RegExp(r'\[.+\] '), ''),
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
    showToast(text: _.toString(), color: red);
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
    showToast(text: _.toString(), color: red);
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
       {
        playNote("error.wav");
      }
      showToast(text:"Location permissions are denied", color: red);
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
     {
      playNote("error.wav");
    }
    showToast(text:"Location permissions are denied", color: red);
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }
   {
    ;
  }
  showToast(text:"Permission granted");
  return await Geolocator.getCurrentPosition();
}*/

/*Future<void> userstoFirestore() async {
  final List<dynamic> userData = json.decode(await rootBundle.loadString("assets/users_file.json"));
  for (int index = 493; index < userData.length; index++) {
    try {
      if ((const <int>[520, 540, 560, 580]).contains(index)) {
        /*if (Platform.isWindows) {
        Process.runSync('cls', []);
      } else {
        Process.runSync('clear', []);
      }*/
        debugPrint("Paused");
        await Future.delayed(3.minutes);
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: userData[index]["email"], password: userData[index]["password"]).then(
          (UserCredential userCredential) async {
            userData[index].update("uid", (dynamic value) => userCredential.user!.uid.trim());
            userData[index].update(
              "date_of_birth",
              (dynamic value) {
                final List<dynamic> date = value.split("-").map((dynamic e) => int.parse(e)).toList();
                return DateTime(date[0], date[1], date[2]);
              },
            );
            debugPrint("Added");
            await FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid.trim()).set(userData[index]);
          },
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      debugPrint(index.toString());
      //break;
    }
  }
}

Future<void> articlesToFirestore() async {
  final List<dynamic> userData = json.decode(await rootBundle.loadString("assets/articles_file.json")); //.map((dynamic e) => ArticleModalClass.fromMap(e)).toList();
  for (int index = 0; index < userData.length; index++) {
    try {
      if ((const <int>[20, 40, 80, 120, 160]).contains(index)) {
        debugPrint("Paused");
        await Future.delayed(3.minutes);
      } else {
        userData[index].update("author", (dynamic value) => value ?? "Unknown");
        await FirebaseFirestore.instance.collection("articles").add(userData[index]);
        debugPrint("Added" /*.bold.cyan*/);
      }
    } catch (e) {
      debugPrint(e.toString());
      debugPrint(index.toString());
      break;
    }
  }
}*/

Future<void> getToken() async {
  await FirebaseMessaging.instance.getToken().then((String? value) async {
    userToken = value!;
    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, String>{'token': userToken});
  });
}

void sendPushNotificationFCM({required String token, required String username, required String message}) async {
  try {
    await post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAATAO2yPs:APA91bHBc_S-v6MHnfTRxz1PD60a_Lh0yY4cB-q4FJlFSKR4To97gAb8bGXECJTKVjWTHo_1fAzSer5ae8CcwL7zK24N45y0VuXWkFN1n0aHapTNCV2DyRYUvXbqG0nu4OsBMvnbXRTf',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': message,
            'title': username,
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': "done",
          },
          'to': token,
        },
      ),
    );
  } catch (e) {
    showToast(text: e.toString());
  }
}

Future<void> goTo(Widget place) async {
  await Get.to(place, transition: animatedTransitions[Random().nextInt(animatedTransitions.length)], duration: 300.ms);
}
