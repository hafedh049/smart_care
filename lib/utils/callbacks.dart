import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_care/utils/globals.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void showToast({required String text, Color? color}) {
  Fluttertoast.showToast(msg: text.replaceAll(RegExp(r'\[.+\] '), ''), backgroundColor: color ?? blue.withOpacity(.3), fontSize: 14, gravity: ToastGravity.TOP, toastLength: Toast.LENGTH_LONG, textColor: white, timeInSecForIosWeb: 3);
}

Future<void> init() async {
  Hive.init((await getApplicationDocumentsDirectory()).path);
  userData = await Hive.openBox('userData');
  if (!userData!.containsKey("dark_theme")) {
    userData!.put("dark_theme", false);
  }
  if (!userData!.containsKey("first_time")) {
    userData!.put("first_time", true);
  }
}

Future<String> takesFromCameraOrGallery(bool camera) async {
  try {
    XFile? image = await ImagePicker().pickImage(source: camera ? ImageSource.camera : ImageSource.gallery, imageQuality: 100, preferredCameraDevice: CameraDevice.front);
    if (image != null) {
      return await cropImage(image.path);
    }
    return "";
  } catch (_) {
    showToast(text: _.toString());
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
    showToast(text: _.toString());
    return "";
  }
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
