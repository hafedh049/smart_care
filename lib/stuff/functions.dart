// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      db.execute("CREATE TABLE SMART_CARE (ID INTEGER PRIMARY KEY , FIRST_TIME INTEGER);");
      db.insert("SMART_CARE", <String, dynamic>{"FIRST_TIME": 1, "ID": 1});
    },
  );
}

Future<String> takesFromCameraOrGallery(bool camera, BuildContext context) async {
  try {
    XFile? image = await ImagePicker().pickImage(source: camera ? ImageSource.camera : ImageSource.gallery, imageQuality: 100, preferredCameraDevice: CameraDevice.front);
    if (image != null) {
      return await cropImage(image.path, context);
    }
    return "";
  } catch (_) {
    showToast(_.toString(), color: red);
    return "";
  }
}

Future<String> cropImage(String imagePath, BuildContext context) async {
  try {
    CroppedFile? croppedImage = await ImageCropper().cropImage(sourcePath: imagePath);
    if (croppedImage != null) {
      Navigator.pop(context);
      return croppedImage.path;
    }
    Navigator.pop(context);
    return "";
  } catch (_) {
    Navigator.pop(context);
    showToast(_.toString(), color: red);
    return "";
  }
}
