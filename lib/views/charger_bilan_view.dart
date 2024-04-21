import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/viewmodels/charger_bilan._viewmodel.dart';

import '../../stuff/classes.dart';
import '../../stuff/globals.dart';

class BloodTestView extends StatefulWidget {
  const BloodTestView({super.key});

  @override
  State<BloodTestView> createState() => _BloodTestViewState();
}

class _BloodTestViewState extends State<BloodTestView> {
  final BloodTestViewModel _viewModel = Get.put(BloodTestViewModel());

  final _formKey = GlobalKey<FormState>();
  final _patientIdController = TextEditingController();
  final _labNameController = TextEditingController();
  final _uploadNameController = TextEditingController();
  final _dateController = TextEditingController();

  final GlobalKey _uploadTextKey = GlobalKey();

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
                Center(child: LottieBuilder.asset("assets/lottie/lab.json", width: MediaQuery.of(context).size.width * .6, height: 200)),
                StatefulBuilder(key: _uploadTextKey, builder: (BuildContext context, void Function(void Function()) _) => result == null ? const SizedBox() : Container(height: 40, width: 150, decoration: BoxDecoration(color: green.withOpacity(.4), borderRadius: BorderRadius.circular(5)), child: const Center(child: CustomizedText(text: 'Blood Test Uploaded', fontSize: 16)))),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: _patientIdController,
                        decoration: InputDecoration(
                          labelText: _viewModel.bloodTest!.patientId,
                          suffixIcon: IconButton(
                            onPressed: () async {
                              await Clipboard.getData(Clipboard.kTextPlain).then(
                                (ClipboardData? value) {
                                  if (value != null) {
                                    _patientIdController.text = value.text!;
                                    showToast(text: "ID pasted from clipboard");
                                  } else {
                                    showToast(text: "There is nothing to paste");
                                  }
                                },
                              );
                            },
                            icon: const Icon(FontAwesomeIcons.clipboard, size: 20, color: grey),
                          ),
                        ),
                        validator: (String? value) => value!.isEmpty ? 'Please enter a patient ID' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(controller: _labNameController, decoration: const InputDecoration(labelText: 'Laboratory Name'), validator: (String? value) => value!.isEmpty ? 'Please enter the laboratory name' : null),
                      const SizedBox(height: 10),
                      TextFormField(controller: _uploadNameController, decoration: const InputDecoration(labelText: 'Uploader Name'), validator: (String? value) => value!.isEmpty ? 'Please enter an upload name' : null),
                      const SizedBox(height: 10),
                      TextFormField(controller: _dateController, readOnly: true, decoration: const InputDecoration(labelText: 'Date')),
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            result = await FilePicker.platform.pickFiles(allowCompression: true, allowedExtensions: <String>["pdf"], dialogTitle: 'selectBloodTest'.tr, lockParentWindow: true, type: FileType.custom);
                            if (result != null) {
                              _uploadTextKey.currentState!.setState(() {});
                            }
                          },
                          child: Container(height: 40, width: 100, decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5)), child: const Center(child: CustomizedText(text: 'Upload', fontSize: 16))),
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
                                  }).then((void value) {
                                    showToast(text: 'bloodstestlinkstoredsuccessfully'.tr);
                                    _patientIdController.clear();
                                    _labNameController.clear();
                                    _uploadNameController.clear();
                                  });
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
