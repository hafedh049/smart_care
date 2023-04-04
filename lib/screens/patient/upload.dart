// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'dart:io';

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
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
            Row(children: const <Widget>[Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), SizedBox(width: 50)]),
            Row(children: const <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
            const Spacer(),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          final String imagePath = await takesFromCameraOrGallery(true);
                          if (imagePath.isNotEmpty) {
                            showToast(text: AppLocalizations.of(context)!.bilanLoaded);
                            final String now = DateTime.now().toString();
                            String url = "";
                            FirebaseStorage.instance.ref().child("bilans/${FirebaseAuth.instance.currentUser!.uid}/$now").putFile(File(imagePath)).then((
                              TaskSnapshot taskSnapshot,
                            ) async {
                              url = await taskSnapshot.ref.getDownloadURL();
                              showToast(text: AppLocalizations.of(context)!.bilanUploaded);
                              await FirebaseFirestore.instance.collection("bilan").doc(FirebaseAuth.instance.currentUser!.uid).set(
                                {
                                  "bilan_list": FieldValue.arrayUnion(
                                    <Map<String, dynamic>>[
                                      {
                                        "bilan_url": url,
                                        "upload_date": now,
                                      },
                                    ],
                                  ),
                                },
                                SetOptions(merge: true),
                              ).then((void value) => showToast(text: AppLocalizations.of(context)!.bloodstestlinkstoredsuccessfully));
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromARGB(255, 255, 85, 0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Image.asset("assets/camera.png", width: 40, height: 40),
                              CustomizedText(text: AppLocalizations.of(context)!.camera, fontSize: 16, color: white, fontWeight: FontWeight.bold),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () async {
                          final String imagePath = await takesFromCameraOrGallery(false);
                          if (imagePath.isNotEmpty) {
                            showToast(text: AppLocalizations.of(context)!.bilanLoaded);
                            final String now = DateTime.now().toString();
                            String url = "";
                            FirebaseStorage.instance.ref().child("bilans/${FirebaseAuth.instance.currentUser!.uid}/$now").putFile(File(imagePath)).then((
                              TaskSnapshot taskSnapshot,
                            ) async {
                              url = await taskSnapshot.ref.getDownloadURL();
                              showToast(text: AppLocalizations.of(context)!.bilanUploaded);
                              await FirebaseFirestore.instance.collection("bilan").doc(FirebaseAuth.instance.currentUser!.uid).set(
                                {
                                  "bilan_list": FieldValue.arrayUnion(
                                    <Map<String, dynamic>>[
                                      {
                                        "bilan_url": url,
                                        "upload_date": now,
                                      },
                                    ],
                                  ),
                                },
                                SetOptions(merge: true),
                              ).then((void value) => showToast(text: AppLocalizations.of(context)!.bloodstestlinkstoredsuccessfully));
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: grey,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Image.asset("assets/gallery.png", width: 40, height: 40),
                              CustomizedText(text: AppLocalizations.of(context)!.gallery, fontSize: 16, color: white, fontWeight: FontWeight.bold),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                        final String now = DateTime.now().toString();
                        String url = "";
                        FirebaseStorage.instance.ref().child("bilans/${FirebaseAuth.instance.currentUser!.uid}/$now").putFile(pdf).then((
                          TaskSnapshot taskSnapshot,
                        ) async {
                          url = await taskSnapshot.ref.getDownloadURL();
                          showToast(text: AppLocalizations.of(context)!.bilanUploaded);
                          await FirebaseFirestore.instance.collection("bilan").doc(FirebaseAuth.instance.currentUser!.uid).set(
                            {
                              "bilan_list": FieldValue.arrayUnion(
                                <Map<String, dynamic>>[
                                  {
                                    "bilan_url": url,
                                    "upload_date": now,
                                  },
                                ],
                              ),
                            },
                            SetOptions(merge: true),
                          ).then((void value) => showToast(text: AppLocalizations.of(context)!.bloodstestlinkstoredsuccessfully));
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: blue,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset("assets/pdf.png", width: 30, height: 30),
                          CustomizedText(text: AppLocalizations.of(context)!.pDF, fontSize: 16, color: white, fontWeight: FontWeight.bold),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
