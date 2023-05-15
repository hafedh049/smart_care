import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_care/stuff/functions.dart';

import '../../stuff/classes.dart';
import '../../stuff/globals.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  final _patientIdController = TextEditingController();
  final _labNameController = TextEditingController();
  final _uploadNameController = TextEditingController();
  final _dateController = TextEditingController();

  FilePickerResult? result;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
  }

  @override
  void dispose() {
    _patientIdController.dispose();
    _labNameController.dispose();
    _uploadNameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: darkBlue,
        extendBody: true,
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
                const SizedBox(height: 20),
                Center(child: LottieBuilder.asset("assets/lottie/lab.json", width: MediaQuery.of(context).size.width * .6, height: 200)),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(controller: _patientIdController, decoration: const InputDecoration(labelText: 'Patient UID'), validator: (String? value) => value!.isEmpty ? 'Please enter a patient ID' : null),
                      const SizedBox(height: 10),
                      TextFormField(controller: _labNameController, decoration: const InputDecoration(labelText: 'Laboratory Name'), validator: (String? value) => value!.isEmpty ? 'Please the laboratory name' : null),
                      const SizedBox(height: 10),
                      TextFormField(controller: _uploadNameController, decoration: const InputDecoration(labelText: 'Upload Name'), validator: (String? value) => value!.isEmpty ? 'Please enter an upload name' : null),
                      const SizedBox(height: 10),
                      TextFormField(controller: _dateController, readOnly: true, decoration: const InputDecoration(labelText: 'Date')),
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              result = await FilePicker.platform.pickFiles(allowCompression: true, allowedExtensions: <String>["pdf"], dialogTitle: 'selectBloodTest'.tr, lockParentWindow: true, onFileLoading: (FilePickerStatus filePickerStatus) => showToast(text: 'bilanIsLoading'.tr), type: FileType.custom);
                            }
                          },
                          child: Container(height: 40, width: 100, decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5)), child: const Center(child: CustomizedText(text: 'Submit', fontSize: 16))),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              if (result != null) {
                                final File pdf = File(result!.paths.first!);
                                showToast(text: 'bilanLoaded'.tr);
                                final DateTime now = DateTime.now();
                                String url = "";
                                FirebaseStorage.instance.ref().child("blood_tests/${FirebaseAuth.instance.currentUser!.uid}/$now").putFile(pdf).then((TaskSnapshot taskSnapshot) async {
                                  url = await taskSnapshot.ref.getDownloadURL();
                                  showToast(text: 'bilanUploaded'.tr);
                                  await FirebaseFirestore.instance.collection("blood_tests").add({
                                    "url": url,
                                    "timestamp": now,
                                    "lab_name": _labNameController.text,
                                    "uploader_name": _uploadNameController.text,
                                    "uid": me["uid"],
                                  }).then((void value) => showToast(text: 'bloodstestlinkstoredsuccessfully'.tr));
                                });
                              }
                            }
                          },
                          child: Container(height: 40, width: 100, decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5)), child: const Center(child: CustomizedText(text: 'Submit', fontSize: 16))),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
