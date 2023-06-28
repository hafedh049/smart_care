import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void showToast({required String text, Color? color}) {
  Fluttertoast.showToast(msg: text.replaceAll(RegExp(r'\[.+\] '), ''), backgroundColor: color ?? blue.withOpacity(.3), fontSize: 14, gravity: ToastGravity.TOP, toastLength: Toast.LENGTH_LONG, textColor: white, timeInSecForIosWeb: 3);
}

Future<void> openDB() async {
  db = await openDatabase(
    "database.db",
    version: 1,
    onCreate: (Database db, int version) {
      db.execute("CREATE TABLE SMART_CARE (ID INTEGER PRIMARY KEY , FIRST_TIME INTEGER, THEME_MODE INTEGER);");
      db.insert("SMART_CARE", <String, dynamic>{"FIRST_TIME": 1, "ID": 1, "THEME_MODE": 0});
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

bool isImageUrl(String url) {
  final List<String> imageExtensions = <String>['jpg', 'jpeg', 'png', 'gif', 'bmp'];
  final RegExp imageRegex = RegExp('.*(${imageExtensions.join('|')})', caseSensitive: false);

  if (!Uri.parse(url).isAbsolute) {
    return false;
  }

  return imageRegex.hasMatch(url);
}

String formatDateTime(DateTime dateTime, TimeOfDay timeOfDay) {
  final String day = dateTime.day.toString();
  final String month = dateTime.month.toString();
  final String year = dateTime.year.toString();
  final String hours = timeOfDay.hour.toString().padLeft(2, '0');
  final String minutes = timeOfDay.minute.toString().padLeft(2, '0');
  final String amPm = timeOfDay.hour < 12 ? 'AM' : 'PM';

  const List<String> monthNames = <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  final String monthName = monthNames[int.parse(month)];

  return '$day $monthName, $year $hours:$minutes $amPm';
}

String getTimeFromDate(DateTime date) {
  final String minutes = date.minute.toString().padLeft(2, '0');
  final String meridian = date.hour < 12 ? 'AM' : 'PM';
  final String hours = (date.hour % 12).toString().padLeft(2, '0');
  return '$hours:$minutes $meridian';
}

String getDateRepresentation(DateTime date) {
  return "${showWeekDay(date.weekday)}, ${months[date.month]} ${date.day}";
}

String showWeekDay(int day) {
  return weekDayPredictor[DateTime(DateTime.now().year, DateTime.now().month, day).weekday]!;
}

Future<void> getToken() async {
  if (userToken.isEmpty) {
    await FirebaseMessaging.instance.getToken().then((String? value) async {
      userToken = value!;
      final DocumentSnapshot<Map<String, dynamic>> reference = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
      if (reference.exists) {
        await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, String>{'token': userToken});
      }
    });
  }
}

void sendPushNotificationFCM({required String token, required String username, required String message}) async {
  try {
    await post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: const <String, String>{'Content-Type': 'application/json', 'Authorization': 'key=AAAATAO2yPs:APA91bHBc_S-v6MHnfTRxz1PD60a_Lh0yY4cB-q4FJlFSKR4To97gAb8bGXECJTKVjWTHo_1fAzSer5ae8CcwL7zK24N45y0VuXWkFN1n0aHapTNCV2DyRYUvXbqG0nu4OsBMvnbXRTf'},
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': message, 'title': username},
          'priority': 'high',
          'data': const <String, dynamic>{'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'id': '1', 'status': "done"},
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

Future<String> getChatResponse(String input) async {
  final Map<String, String> headers = <String, String>{'Content-Type': 'application/json', 'Authorization': 'Bearer $gpt3ApiKey'};
  final Map<String, dynamic> body = <String, dynamic>{'prompt': input, 'temperature': .5, 'max_tokens': 128};
  final response = await post(Uri.parse(gpt3ApiUrl), headers: headers, body: json.encode(body));
  final data = json.decode(response.body);
  final String chatResponse = data['choices'][0]['text'];
  return chatResponse;
}

String getChatId(List<String> ids) {
  ids.sort();
  return '${ids[0]}_${ids[1]}';
}

Future<List<Appointment>> generateAppointments() async {
  final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("appointments").where(me["role"] == "doctor" ? "doctorID" : "patientID", isEqualTo: me["uid"]).get();

  return snapshot.docs
      .map(
        (QueryDocumentSnapshot<Map<String, dynamic>> item) => Appointment(
          startTime: item.get("appointmentDate").toDate(),
          endTime: item.get("appointmentDate").toDate().add(const Duration(minutes: 60 /*int.parse(item.get("duration").split(" ")[0])*/)),
          color: blue,
          subject: "Appointment",
          notes: me["role"] == "doctor" ? item["patientName"] : item["doctorName"],
        ),
      )
      .toList();
}
