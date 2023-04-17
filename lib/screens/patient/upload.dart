// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
            Row(children: const <Widget>[Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), SizedBox(width: 50)]),
            Row(children: const <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                showToast(text: AppLocalizations.of(context)!.bilanIsLoading);
                final String imagePath = await takesFromCameraOrGallery(true);
                if (imagePath.isNotEmpty) {
                  final DateTime now = DateTime.now();
                  String url = "";
                  FirebaseStorage.instance.ref().child("blood_tests/${FirebaseAuth.instance.currentUser!.uid}/$now").putFile(File(imagePath)).then((TaskSnapshot taskSnapshot) async {
                    url = await taskSnapshot.ref.getDownloadURL();
                    showToast(text: AppLocalizations.of(context)!.bilanUploaded);
                    await FirebaseFirestore.instance.collection("blood_tests").add(
                      {
                        "url": url,
                        "timestamp": now,
                        "uid": me["uid"],
                      },
                    ).then((void value) => showToast(text: AppLocalizations.of(context)!.bloodstestlinkstoredsuccessfully));
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(16.0),
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(255, 255, 235, 235),
                  image: const DecorationImage(image: CachedNetworkImageProvider(camera), fit: BoxFit.cover),
                ),
                child: Center(child: CustomizedText(text: AppLocalizations.of(context)!.camera, fontSize: 25, color: darkBlue, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final String imagePath = await takesFromCameraOrGallery(false);
                if (imagePath.isNotEmpty) {
                  showToast(text: AppLocalizations.of(context)!.bilanLoaded);
                  final DateTime now = DateTime.now();
                  String url = "";
                  FirebaseStorage.instance.ref().child("blood_tests/${FirebaseAuth.instance.currentUser!.uid}/$now").putFile(File(imagePath)).then((TaskSnapshot taskSnapshot) async {
                    url = await taskSnapshot.ref.getDownloadURL();
                    showToast(text: AppLocalizations.of(context)!.bilanUploaded);
                    await FirebaseFirestore.instance.collection("blood_tests").add(
                      {
                        "url": url,
                        "timestamp": now,
                        "uid": me["uid"],
                      },
                    ).then((void value) => showToast(text: AppLocalizations.of(context)!.bloodstestlinkstoredsuccessfully));
                  });
                }
              },
              child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(8.0),
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(255, 173, 228, 219),
                  image: const DecorationImage(image: CachedNetworkImageProvider(gallery), fit: BoxFit.cover),
                ),
                child: Center(child: CustomizedText(text: AppLocalizations.of(context)!.gallery, fontSize: 25, color: darkBlue, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowCompression: true,
                  allowedExtensions: <String>["pdf"],
                  dialogTitle: AppLocalizations.of(context)!.selectBloodTest,
                  lockParentWindow: true,
                  onFileLoading: (FilePickerStatus filePickerStatus) => showToast(text: AppLocalizations.of(context)!.bilanIsLoading),
                  type: FileType.custom,
                );
                if (result != null) {
                  File pdf = File(result.paths.first!);
                  showToast(text: AppLocalizations.of(context)!.bilanLoaded);
                  final DateTime now = DateTime.now();
                  String url = "";
                  FirebaseStorage.instance.ref().child("blood_tests/${FirebaseAuth.instance.currentUser!.uid}/$now").putFile(pdf).then((TaskSnapshot taskSnapshot) async {
                    url = await taskSnapshot.ref.getDownloadURL();
                    showToast(text: AppLocalizations.of(context)!.bilanUploaded);
                    await FirebaseFirestore.instance.collection("blood_tests").add(
                      {
                        "url": url,
                        "timestamp": now,
                        "uid": me["uid"],
                      },
                    ).then((void value) => showToast(text: AppLocalizations.of(context)!.bloodstestlinkstoredsuccessfully));
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(16.0),
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(255, 246, 186, 111),
                  image: const DecorationImage(image: CachedNetworkImageProvider(pdf), fit: BoxFit.cover),
                ),
                child: Center(child: CustomizedText(text: AppLocalizations.of(context)!.pDF, fontSize: 25, color: white, fontWeight: FontWeight.bold)),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
