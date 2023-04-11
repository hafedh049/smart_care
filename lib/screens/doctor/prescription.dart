// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/stuff/functions.dart';
import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:smart_care/screens/doctor/generate_prescription_template.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../stuff/classes.dart';
import '../../stuff/globals.dart';

class Prescription extends StatefulWidget {
  const Prescription({super.key, required this.patientID});
  final String patientID;
  @override
  State<Prescription> createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _timesController = TextEditingController();
  final TextEditingController _takesController = TextEditingController();
  final GlobalKey _nextKey = GlobalKey();
  final PageController _pageController = PageController();
  final FocusNode _diagnosisNode = FocusNode();
  final Map<String, bool> _listOfDays = <String, bool>{"Mon": false, "Tue": false, "Wed": false, "Thu": false, "Fri": false, "Sat": false, "Sun": false};
  final Map<String, bool> _frequecies = <String, bool>{"Morning": false, "Noon": false, "Night": false};
  bool _perDay = true;
  bool _perWeek = false;
  late final String _serialNumber;
  Map<String, dynamic> _patientData = <String, dynamic>{};
  double _page = 0;
  @override
  void dispose() {
    _pageController.dispose();
    _diagnosisController.dispose();
    _takesController.dispose();
    _timesController.dispose();
    _diagnosisNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _serialNumber = List.generate(8, (_) => Random().nextInt(36).toRadixString(36)).join().toUpperCase();
    _diagnosisNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: darkBlue,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
            Row(children: <Widget>[IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesomeIcons.chevronLeft, size: 15, color: white)), const Spacer(), const CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
            Row(children: const <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int pageIndex) => _nextKey.currentState!.setState(() {
                    _page = _pageController.page!;
                  }),
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(child: CustomizedText(text: AppLocalizations.of(context)!.describethemedicaldiagnosis, color: blue, fontSize: 18)),
                        Expanded(
                          child: TextField(
                            focusNode: _diagnosisNode,
                            controller: _diagnosisController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.diagnosis,
                              contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                              border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(16.0)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(16.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(child: CustomizedText(text: AppLocalizations.of(context)!.whatshouldthepatienttakesasmedicaments, color: blue, fontSize: 18)),
                        TextField(
                          controller: _takesController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.take,
                            contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(16.0)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(16.0)),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CustomizedText(text: AppLocalizations.of(context)!.howmanytimes, color: blue, fontSize: 18),
                        TextField(
                          controller: _timesController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.times,
                            contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(16.0)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(16.0)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomizedText(text: AppLocalizations.of(context)!.per, color: blue, fontSize: 18),
                        const SizedBox(height: 20),
                        StatefulBuilder(builder: (BuildContext context, void Function(void Function()) _) {
                          return Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => _(() {
                                  _perDay = true;
                                  _perWeek = false;
                                }),
                                child: AnimatedContainer(
                                  duration: 500.ms,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(color: _perDay ? blue : grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                                  child: Center(child: CustomizedText(text: AppLocalizations.of(context)!.dAY, color: _perDay ? white : grey, fontSize: 16)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => _(() {
                                  _perDay = false;
                                  _perWeek = true;
                                }),
                                child: AnimatedContainer(
                                  duration: 500.ms,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(color: _perWeek ? blue : grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                                  child: Center(child: CustomizedText(text: AppLocalizations.of(context)!.wEEK, color: _perWeek ? white : grey, fontSize: 16)),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CustomizedText(text: AppLocalizations.of(context)!.daysoftheweek, color: blue, fontSize: 18),
                        const SizedBox(height: 20),
                        StatefulBuilder(
                          builder: (BuildContext context, void Function(void Function()) _) {
                            return Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              children: <Widget>[
                                for (final String day in const <String>["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"])
                                  GestureDetector(
                                    onTap: () => _(() => _listOfDays[day] = !_listOfDays[day]!),
                                    child: AnimatedContainer(
                                      width: 60,
                                      duration: 500.ms,
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(color: _listOfDays[day]! ? blue : grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                                      child: Center(child: CustomizedText(text: day, color: _listOfDays[day]! ? white : grey, fontSize: 16)),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CustomizedText(text: AppLocalizations.of(context)!.frequencyofthecure, color: blue, fontSize: 18),
                        const SizedBox(height: 20),
                        StatefulBuilder(
                          builder: (BuildContext context, void Function(void Function()) _) {
                            return Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              children: <Widget>[
                                for (final String frequency in const <String>["Morning", "Noon", "Night"])
                                  GestureDetector(
                                    onTap: () => _(() => _frequecies[frequency] = !_frequecies[frequency]!),
                                    child: AnimatedContainer(
                                      width: 100,
                                      duration: 500.ms,
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(color: _frequecies[frequency]! ? blue : grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                                      child: Center(child: CustomizedText(text: frequency, color: _frequecies[frequency]! ? white : grey, fontSize: 16)),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection("users").doc(widget.patientID).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    _patientData = snapshot.data!.data()!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CustomizedText(text: AppLocalizations.of(context)!.doctorName, color: grey, fontSize: 16),
                            Container(padding: const EdgeInsets.all(8.0), decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: CustomizedText(text: me["name"], color: grey, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CustomizedText(text: AppLocalizations.of(context)!.speciality, color: grey, fontSize: 16),
                            Container(padding: const EdgeInsets.all(8.0), decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: CustomizedText(text: me["speciality"], color: grey, fontSize: 16))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CustomizedText(text: AppLocalizations.of(context)!.iD, color: grey, fontSize: 16),
                            Container(padding: const EdgeInsets.all(8.0), decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: CustomizedText(text: me["id"], color: grey, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CustomizedText(text: AppLocalizations.of(context)!.sNo, color: grey, fontSize: 16),
                                Container(padding: const EdgeInsets.all(8.0), decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: CustomizedText(text: _serialNumber, color: grey, fontSize: 16)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CustomizedText(text: AppLocalizations.of(context)!.prescriptionDate, color: grey, fontSize: 16),
                                Container(padding: const EdgeInsets.all(8.0), decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: CustomizedText(text: "${DateTime.now().year} - ${DateTime.now().month} - ${DateTime.now().day}", color: grey, fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CustomizedText(text: AppLocalizations.of(context)!.patientName, color: grey, fontSize: 16),
                            Container(padding: const EdgeInsets.all(8.0), decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: CustomizedText(text: snapshot.data!.get("name"), color: grey, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CustomizedText(text: AppLocalizations.of(context)!.dOB, color: grey, fontSize: 16),
                                Container(padding: const EdgeInsets.all(8.0), decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: CustomizedText(text: "${snapshot.data!.get("date_of_birth").toDate().year} - ${snapshot.data!.get("date_of_birth").toDate().month} - ${snapshot.data!.get("date_of_birth").toDate().day}", color: grey, fontSize: 16)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CustomizedText(text: AppLocalizations.of(context)!.age, color: grey, fontSize: 16),
                                Container(padding: const EdgeInsets.all(8.0), decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: CustomizedText(text: (DateTime.now().difference(snapshot.data!.get("date_of_birth").toDate()).inDays ~/ 365).toString(), color: grey, fontSize: 16)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CustomizedText(text: AppLocalizations.of(context)!.gender, color: grey, fontSize: 16),
                                Container(padding: const EdgeInsets.all(8.0), decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: CustomizedText(text: snapshot.data!.get("gender") == "m" ? AppLocalizations.of(context)!.male : AppLocalizations.of(context)!.female, color: grey, fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: blue));
                  } else {
                    return ErrorRoom(error: snapshot.error.toString());
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: StatefulBuilder(
                key: _nextKey,
                builder: (BuildContext context, void Function(void Function()) _) {
                  return AnimatedContainer(
                    duration: 700.ms,
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom > 0 ? 40.0 : 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            await _pageController.previousPage(duration: 300.ms, curve: Curves.bounceIn);
                          },
                          child: AnimatedContainer(
                            duration: 700.ms,
                            height: 40,
                            width: 100,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(color: _page.round() != 0 ? blue : grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                            child: Center(child: CustomizedText(text: AppLocalizations.of(context)!.pREV, color: white, fontSize: 16)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_pageController.page!.toInt() == 0) {
                              if (_diagnosisController.text.trim().isEmpty) {
                                showToast(text: AppLocalizations.of(context)!.diagnosisFieldCantBeEmpty);
                              } else {
                                await _pageController.nextPage(duration: 300.ms, curve: Curves.bounceIn);
                              }
                            } else if (_pageController.page!.toInt() == 1) {
                              if (_takesController.text.trim().isEmpty) {
                                showToast(text: AppLocalizations.of(context)!.youshouldspecifythetreatment);
                              } else {
                                await _pageController.nextPage(duration: 300.ms, curve: Curves.bounceIn);
                              }
                            } else if (_pageController.page!.toInt() == 2) {
                              if (_timesController.text.trim().isEmpty || <bool>[_perDay, _perWeek].every((element) => element == false)) {
                                showToast(text: AppLocalizations.of(context)!.howmanytimesthepatientshouldtakesthemedecinandperweekorday);
                              } else {
                                await _pageController.nextPage(duration: 300.ms, curve: Curves.bounceIn);
                              }
                            } else if (_pageController.page!.toInt() == 3) {
                              if (_listOfDays.values.every((bool element) => element == false)) {
                                showToast(text: AppLocalizations.of(context)!.pickupatleastoneday);
                              } else {
                                await _pageController.nextPage(duration: 300.ms, curve: Curves.bounceIn);
                              }
                            } else if (_pageController.page!.toInt() == 4) {
                              if (_frequecies.values.every((bool element) => element == false)) {
                                showToast(text: AppLocalizations.of(context)!.atanyperiodthepatientshouldtakemedecine);
                              } else {
                                try {
                                  showToast(text: AppLocalizations.of(context)!.printing);
                                  pw.Document pdfDoc = pw.Document();
                                  pdfDoc.addPage(pw.Page(
                                      build: (pw.Context context) => PrescriptionTemplate(patientData: <String, dynamic>{
                                            "title": _serialNumber,
                                            "diagnosis": _diagnosisController.text.trim(),
                                            "doctorID": me["id"],
                                            "doctorName": me["name"],
                                            "patientName": _patientData["name"],
                                            "dob": _patientData["date_of_birth"],
                                            "gender": _patientData["gender"],
                                            "doctorSpeciality": me["speciality"],
                                            "listOfDays": _listOfDays,
                                            "frequencies": _frequecies,
                                            "perDay": _perDay ? "Day" : "Week",
                                            "takes": _takesController.text.trim(),
                                            "times": _timesController.text.trim(),
                                          }),
                                      pageFormat: PdfPageFormat.legal,
                                      margin: pw.EdgeInsets.zero));
                                  final output = await getExternalStorageDirectory();
                                  final file = File("${output!.path}/$_serialNumber.pdf");
                                  await file.writeAsBytes(await pdfDoc.save());

                                  await FirebaseStorage.instance.ref().child("prescriptions/${_patientData['uid']}/${DateTime.now()}").putFile(file).then((TaskSnapshot taskSnapshot) async {
                                    showToast(text: AppLocalizations.of(context)!.prescriptionUploaded);
                                    await FirebaseFirestore.instance.collection("prescriptions").add({
                                      "doctorID": me["uid"],
                                      "doctorName": me["name"],
                                      "patientID": widget.patientID,
                                      "patientName": _patientData["name"],
                                      "title": _serialNumber,
                                      "prescriptionUrl": await taskSnapshot.ref.getDownloadURL(),
                                      "timestamp": DateTime.now(),
                                    }).then((void value) async => await OpenFilex.open(file.path));
                                  });
                                  showToast(text: AppLocalizations.of(context)!.printing);
                                } catch (_) {
                                  showToast(text: _.toString(), color: red);
                                }
                              }
                            }
                          },
                          child: AnimatedContainer(
                            duration: 700.ms,
                            height: 40,
                            width: 100,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(color: _page.round() < 4 ? blue : green.withOpacity(.7), borderRadius: BorderRadius.circular(5)),
                            child: Center(child: CustomizedText(text: _page.round() < 4 ? AppLocalizations.of(context)!.next : AppLocalizations.of(context)!.print, color: white, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
