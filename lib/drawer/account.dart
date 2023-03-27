// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/stuff/functions.dart';

import '../stuff/classes.dart';
import '../stuff/globals.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final TextEditingController _changerController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _profilePictureKey = GlobalKey();

  @override
  void dispose() {
    _changerController.dispose();
    super.dispose();
  }

  void change(String hint, IconData prefix, bool password, TextInputType type, String? Function(String?)? validator, String key) {
    Color color = grey;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setS) {
              return Row(
                children: <Widget>[
                  Flexible(
                    child: Form(
                      key: _formKey,
                      child: CustomTextField(
                        controller: _changerController,
                        hint: hint,
                        prefix: prefix,
                        obscured: password,
                        type: type,
                        validator: validator,
                        func: (String text) => setS(() => color = text.isNotEmpty ? blue : grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      if (play == 1) {
                        playNote("tap.wav");
                      }
                      if (_formKey.currentState!.validate()) {
                        await FirebaseFirestore.instance.collection("health_care_professionals").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, dynamic>{key: _changerController.text.trim()}).then((void value) => Navigator.pop(context));
                      }
                    },
                    child: Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: Icon(FontAwesomeIcons.check, size: 15, color: color)),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: darkBlue,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection("health_care_professionals").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        if (play == 1) {
                          playNote("tap.wav");
                        }
                        Navigator.pop(context);
                      },
                      child: Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.x, size: 15, color: grey)),
                    ),
                    const SizedBox(height: 10),
                    const CustomizedText(text: "Account", fontSize: 40, fontWeight: FontWeight.bold, color: white),
                    const SizedBox(height: 60),
                    GestureDetector(
                      onTap: () {
                        if (play == 1) {
                          playNote("tap.wav");
                        }
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) => SizedBox(
                            height: 160,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomIcon(
                                  size: 25,
                                  func: () async {
                                    Navigator.pop(context);
                                    if (snapshot.data!.get("image_url") != noUser) {
                                      await FirebaseFirestore.instance.collection("health_care_professionals").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, dynamic>{"image_url": noUser}).then((void value) => showToast("Picture Uploaded"));
                                      await FirebaseStorage.instance.ref("/profile_pictures/${FirebaseAuth.instance.currentUser!.uid}").delete().then((void value) => showToast("Picture Removed"));
                                    }
                                  },
                                  icon: FontAwesomeIcons.x,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CustomIcon(
                                      size: 25,
                                      func: () async {
                                        final String path = await takesFromCameraOrGallery(true);
                                        showToast("Uploading Picture");
                                        Navigator.pop(context);
                                        await FirebaseStorage.instance.ref("/profile_pictures/${FirebaseAuth.instance.currentUser!.uid}").putFile(File(path)).then((TaskSnapshot task) async {
                                          await FirebaseFirestore.instance.collection("health_care_professionals").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, dynamic>{"image_url": await task.ref.getDownloadURL()});
                                          showToast("Picture Uploaded");
                                        });
                                      },
                                      icon: FontAwesomeIcons.camera,
                                    ),
                                    CustomIcon(
                                      size: 25,
                                      func: () async {
                                        final String path = await takesFromCameraOrGallery(false);
                                        showToast("Uploading Picture");
                                        Navigator.pop(context);
                                        await FirebaseStorage.instance.ref("/profile_pictures/${FirebaseAuth.instance.currentUser!.uid}").putFile(File(path)).then((TaskSnapshot task) async {
                                          await FirebaseFirestore.instance.collection("health_care_professionals").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, dynamic>{"image_url": await task.ref.getDownloadURL()});
                                          showToast("Picture Uploaded");
                                        });
                                      },
                                      icon: Icons.image,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const CustomizedText(text: "Photo", fontSize: 14, color: grey),
                          const SizedBox(width: 80),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              StatefulBuilder(
                                key: _profilePictureKey,
                                builder: (BuildContext context, void Function(void Function()) _) {
                                  return CircleAvatar(
                                    radius: 50,
                                    backgroundImage: snapshot.data!.get("image_url") == noUser ? null : CachedNetworkImageProvider(snapshot.data!.get("image_url")),
                                    backgroundColor: grey.withOpacity(.2),
                                    child: snapshot.data!.get("image_url") != noUser ? null : const Icon(FontAwesomeIcons.user, color: grey, size: 35),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              const CustomizedText(text: "Upload Picture", fontSize: 14, color: blue),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        if (play == 1) {
                          playNote("tap.wav");
                        }
                        change("Name", FontAwesomeIcons.userDoctor, false, TextInputType.text, fieldsValidatorsFunction("username", context), "medical_professional_name");
                      },
                      child: Row(
                        children: <Widget>[
                          const CustomizedText(text: "Name", fontSize: 14, color: grey),
                          const SizedBox(width: 80),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CustomizedText(text: snapshot.data!.get("medical_professional_name"), fontSize: 16, color: white),
                                const SizedBox(height: 5),
                                Container(height: .1, color: white),
                              ],
                            ),
                          ),
                          const SizedBox(width: 25),
                          Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: grey)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: <Widget>[
                        const CustomizedText(text: "Gender", fontSize: 14, color: grey),
                        const SizedBox(width: 72),
                        GestureDetector(
                          onTap: () async {
                            if (play == 1) {
                              playNote("tap.wav");
                            }
                            await FirebaseFirestore.instance.collection("health_care_professionals").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, dynamic>{"gender": "m"});
                          },
                          child: CircleAvatar(radius: 25, backgroundColor: snapshot.data!.get("gender") == "m" ? blue : grey.withOpacity(.2), child: Icon(FontAwesomeIcons.mars, color: snapshot.data!.get("gender") == "m" ? white : grey, size: 20)),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            if (play == 1) {
                              playNote("tap.wav");
                            }
                            await FirebaseFirestore.instance.collection("health_care_professionals").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, dynamic>{"gender": "f"});
                          },
                          child: CircleAvatar(radius: 25, backgroundColor: snapshot.data!.get("gender") == "f" ? blue : grey.withOpacity(.2), child: Icon(FontAwesomeIcons.venus, color: snapshot.data!.get("gender") == "f" ? white : grey, size: 20)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        if (play == 1) {
                          playNote("tap.wav");
                        }
                        change("Age", FontAwesomeIcons.zero, false, TextInputType.number, fieldsValidatorsFunction("age", context), "age");
                      },
                      child: Row(
                        children: <Widget>[
                          const CustomizedText(text: "Age", fontSize: 14, color: grey),
                          const SizedBox(width: 90),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CustomizedText(text: snapshot.data!.get("age"), fontSize: 16, color: white),
                                const SizedBox(height: 5),
                                Container(height: .1, color: white),
                              ],
                            ),
                          ),
                          const SizedBox(width: 25),
                          Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: grey)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: null,
                      child: Row(
                        children: <Widget>[
                          const CustomizedText(text: "E-mail", fontSize: 14, color: grey),
                          const SizedBox(width: 75),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SingleChildScrollView(scrollDirection: Axis.horizontal, child: CustomizedText(text: snapshot.data!.get("email"), fontSize: 16, color: white)),
                                const SizedBox(height: 5),
                                Container(height: .1, color: white),
                              ],
                            ),
                          ),
                          const SizedBox(width: 25),
                          Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: grey)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: null,
                      child: Row(
                        children: <Widget>[
                          const CustomizedText(text: "Password", fontSize: 14, color: grey),
                          const SizedBox(width: 55),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SingleChildScrollView(scrollDirection: Axis.horizontal, child: CustomizedText(text: snapshot.data!.get("password").split("").map((String char) => "* ").toList().join(""), fontSize: 16, color: white)),
                                const SizedBox(height: 5),
                                Container(height: .1, color: white),
                              ],
                            ),
                          ),
                          const SizedBox(width: 25),
                          Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: grey)),
                        ],
                      ),
                    ),
                    if (snapshot.data!.get("role") != "patient" && snapshot.data!.get("role") != "admin") const SizedBox(height: 40),
                    if (snapshot.data!.get("role") != "patient" && snapshot.data!.get("role") != "admin")
                      GestureDetector(
                        onTap: () {
                          if (play == 1) {
                            playNote("tap.wav");
                          }
                          showToast("Tap if you want to select otherwise swipe in any direction.");
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width * .9,
                                height: MediaQuery.of(context).size.height * .6,
                                child: CardSwiper(
                                  isLoop: true,
                                  duration: 100.ms,
                                  padding: EdgeInsets.zero,
                                  cards: <Widget>[
                                    for (Map<String, dynamic> speciality in specialityListFunction(context))
                                      GestureDetector(
                                        onTap: () async {
                                          if (play == 1) {
                                            playNote("tap.wav");
                                          }
                                          await FirebaseFirestore.instance.collection("health_care_professionals").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, dynamic>{"speciality": speciality["speciality"]}).then((void value) {
                                            showToast(speciality["speciality"]);
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: darkBlue,
                                            borderRadius: BorderRadius.circular(15),
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(speciality["url"]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              CustomizedText(text: speciality["speciality"], fontSize: 25, color: blue, fontWeight: FontWeight.bold),
                                              const SizedBox(height: 30),
                                              Expanded(
                                                child: SizedBox(
                                                  child: AnimatedTextKit(
                                                    animatedTexts: <AnimatedText>[
                                                      TypewriterAnimatedText(
                                                        speciality["description"],
                                                        textStyle: GoogleFonts.roboto(
                                                          fontSize: 14,
                                                          color: speciality["color"],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            const CustomizedText(text: "Speciality", fontSize: 14, color: grey),
                            const SizedBox(width: 55),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SingleChildScrollView(scrollDirection: Axis.horizontal, child: CustomizedText(text: snapshot.data!.get("speciality"), fontSize: 16, color: white)),
                                  const SizedBox(height: 5),
                                  Container(height: .1, color: white),
                                ],
                              ),
                            ),
                            const SizedBox(width: 25),
                            Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: grey)),
                          ],
                        ),
                      ),
                    if (snapshot.data!.get("role") != "patient" && snapshot.data!.get("role") != "admin") const SizedBox(height: 40),
                    if (snapshot.data!.get("role") != "patient" && snapshot.data!.get("role") != "admin")
                      GestureDetector(
                        onTap: () {
                          if (play == 1) {
                            playNote("tap.wav");
                          }
                          change("Years of Experience", FontAwesomeIcons.zero, false, TextInputType.number, fieldsValidatorsFunction("age", context), "years_of_experience");
                        },
                        child: Row(
                          children: <Widget>[
                            const CustomizedText(text: "Years of Experience", fontSize: 14, color: grey),
                            const SizedBox(width: 55),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  CustomizedText(text: snapshot.data!.get("years_of_experience"), fontSize: 16, color: white),
                                  const SizedBox(height: 5),
                                  Container(height: .1, color: white),
                                ],
                              ),
                            ),
                            const SizedBox(width: 25),
                            Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: grey)),
                          ],
                        ),
                      ),
                    if (snapshot.data!.get("role") != "patient" && snapshot.data!.get("role") != "admin") const SizedBox(height: 40),
                    if (snapshot.data!.get("role") != "patient" && snapshot.data!.get("role") != "admin")
                      GestureDetector(
                        onTap: () async {
                          if (play == 1) {
                            playNote("tap.wav");
                          }
                          final List<String> time = <String>["--", "--"];
                          await showTimePicker(context: context, initialTime: TimeOfDay.now(), helpText: "Select Start Time").then((TimeOfDay? start) async {
                            if (start != null) {
                              time[0] = start.format(context);
                            }
                            await FirebaseFirestore.instance.collection("health_care_professionals").doc(FirebaseAuth.instance.currentUser!.uid).update({
                              "available_time": time,
                            }).then((void value) async {
                              await showTimePicker(context: context, initialTime: TimeOfDay.now(), helpText: "Select Finish Time").then((TimeOfDay? finish) async {
                                if (finish != null) {
                                  time[1] = finish.format(context);
                                }
                                await FirebaseFirestore.instance.collection("health_care_professionals").doc(FirebaseAuth.instance.currentUser!.uid).update({
                                  "available_time": time,
                                });
                              });
                            });
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            const CustomizedText(text: "Available Time", fontSize: 14, color: grey),
                            const SizedBox(width: 55),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  if (snapshot.data!.get("available_time").isEmpty) const CustomizedText(text: "Full Time.", fontSize: 16, color: white),
                                  if (snapshot.data!.get("available_time").isNotEmpty)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Icon(FontAwesomeIcons.clockRotateLeft, color: blue, size: 10),
                                        const SizedBox(width: 5),
                                        CustomizedText(text: snapshot.data!.get("available_time")[0], fontSize: 14, color: white),
                                      ],
                                    ),
                                  if (snapshot.data!.get("available_time").isNotEmpty) const SizedBox(height: 5),
                                  if (snapshot.data!.get("available_time").isNotEmpty)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Icon(FontAwesomeIcons.clockRotateLeft, color: blue, size: 10),
                                        const SizedBox(width: 5),
                                        CustomizedText(text: snapshot.data!.get("available_time")[1], fontSize: 14, color: white),
                                      ],
                                    ),
                                  const SizedBox(height: 5),
                                  Container(height: .1, color: white),
                                ],
                              ),
                            ),
                            const SizedBox(width: 25),
                            Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: grey)),
                          ],
                        ),
                      ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        if (play == 1) {
                          playNote("tap.wav");
                        }
                        change("About", FontAwesomeIcons.stubber, false, TextInputType.text, fieldsValidatorsFunction("about", context), "about");
                      },
                      child: Row(
                        children: <Widget>[
                          const CustomizedText(text: "About", fontSize: 14, color: grey),
                          const SizedBox(width: 55),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SingleChildScrollView(scrollDirection: Axis.horizontal, child: CustomizedText(text: snapshot.data!.get("about").isEmpty ? "--" : snapshot.data!.get("about"), fontSize: 16, color: white)),
                                const SizedBox(height: 5),
                                Container(height: .1, color: white),
                              ],
                            ),
                          ),
                          const SizedBox(width: 25),
                          Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: grey)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        if (play == 1) {
                          playNote("tap.wav");
                        }
                        change("Location", FontAwesomeIcons.stubber, false, TextInputType.text, fieldsValidatorsFunction("job location", context), "location");
                      },
                      child: Row(
                        children: <Widget>[
                          const CustomizedText(text: "Location", fontSize: 14, color: grey),
                          const SizedBox(width: 55),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CustomizedText(text: snapshot.data!.get("location").isEmpty ? "--" : snapshot.data!.get("location"), fontSize: 16, color: white),
                                const SizedBox(height: 5),
                                Container(height: .1, color: white),
                              ],
                            ),
                          ),
                          const SizedBox(width: 25),
                          Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: grey)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: null,
                      child: Row(
                        children: <Widget>[
                          const CustomizedText(text: "Phone", fontSize: 14, color: grey),
                          const SizedBox(width: 55),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CustomizedText(text: snapshot.data!.get("phone_number"), fontSize: 16, color: white),
                                const SizedBox(height: 5),
                                Container(height: .1, color: white),
                              ],
                            ),
                          ),
                          const SizedBox(width: 25),
                          Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: grey)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: <Widget>[
                        const CustomizedText(text: "Role", fontSize: 14, color: grey),
                        const SizedBox(width: 60),
                        CircleAvatar(radius: 25, backgroundColor: snapshot.data!.get("roles_list").contains("patient") ? blue : grey.withOpacity(.2), child: Icon(FontAwesomeIcons.hospitalUser, color: snapshot.data!.get("roles_list").contains("patient") ? white : grey, size: 20)),
                        const SizedBox(width: 10),
                        CircleAvatar(radius: 25, backgroundColor: snapshot.data!.get("roles_list").contains("doctor") ? blue : grey.withOpacity(.2), child: Icon(FontAwesomeIcons.userDoctor, color: snapshot.data!.get("roles_list").contains("doctor") ? white : grey, size: 20)),
                        const SizedBox(width: 10),
                        CircleAvatar(radius: 25, backgroundColor: snapshot.data!.get("roles_list").contains("admin") ? blue : grey.withOpacity(.2), child: Icon(FontAwesomeIcons.lock, color: snapshot.data!.get("roles_list").contains("admin") ? white : grey, size: 20)),
                        const SizedBox(width: 10),
                        CircleAvatar(radius: 25, backgroundColor: snapshot.data!.get("roles_list").contains("laboratory") ? blue : grey.withOpacity(.2), child: Icon(FontAwesomeIcons.solidHospital, color: snapshot.data!.get("roles_list").contains("laboratory") ? white : grey, size: 20)),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Expanded(child: ListView.builder(padding: EdgeInsets.zero, itemCount: 10, itemBuilder: (BuildContext context, int index) => const ListTileShimmer()));
            } else {
              return ErrorRoom(error: snapshot.error.toString());
            }
          },
        ),
      ),
    );
  }
}
