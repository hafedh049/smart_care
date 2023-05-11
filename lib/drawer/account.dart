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
import 'package:get/get.dart';
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
                  Flexible(child: Form(key: _formKey, child: CustomTextField(controller: _changerController, hint: hint, prefix: prefix, obscured: password, type: type, validator: validator, func: (String text) => setS(() => color = text.isNotEmpty ? blue : grey)))),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async => _formKey.currentState!.validate() ? await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, dynamic>{key: _changerController.text.trim()}).then((void value) => Navigator.pop(context)) : null,
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
          stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.x, size: 15, color: grey))),
                    const SizedBox(height: 10),
                    CustomizedText(text: 'account'.tr, fontSize: 40, fontWeight: FontWeight.bold, color: white),
                    const SizedBox(height: 60),
                    GestureDetector(
                      onTap: () {
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
                                      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, dynamic>{"image_url": noUser}).then((void value) => showToast(text: 'pictureUploaded'.tr));
                                      await FirebaseStorage.instance.ref("/profile_pictures/${FirebaseAuth.instance.currentUser!.uid}").delete().then((void value) => showToast(text: 'pictureRemoved'.tr));
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
                                        showToast(text: 'uploadingPicture'.tr);
                                        Navigator.pop(context);
                                        await FirebaseStorage.instance.ref("/profile_pictures/${FirebaseAuth.instance.currentUser!.uid}").putFile(File(path)).then((TaskSnapshot task) async {
                                          await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, dynamic>{"image_url": await task.ref.getDownloadURL()});
                                          showToast(text: 'pictureUploaded'.tr);
                                        });
                                      },
                                      icon: FontAwesomeIcons.camera,
                                    ),
                                    CustomIcon(
                                      size: 25,
                                      func: () async {
                                        final String path = await takesFromCameraOrGallery(false);
                                        showToast(text: 'uploadingPicture'.tr);
                                        Navigator.pop(context);
                                        await FirebaseStorage.instance.ref("/profile_pictures/${FirebaseAuth.instance.currentUser!.uid}").putFile(File(path)).then((TaskSnapshot task) async {
                                          await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, dynamic>{"image_url": await task.ref.getDownloadURL()});
                                          showToast(text: 'pictureUploaded'.tr);
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
                          CustomizedText(text: 'photo'.tr, fontSize: 14, color: grey),
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
                              CustomizedText(text: 'uploadPicture'.tr, fontSize: 14, color: blue),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        change('name'.tr, FontAwesomeIcons.userDoctor, false, TextInputType.text, fieldsValidator["username"], "name");
                      },
                      child: Row(
                        children: <Widget>[
                          CustomizedText(text: 'name'.tr, fontSize: 14, color: grey),
                          const SizedBox(width: 80),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CustomizedText(text: snapshot.data!.get("name"), fontSize: 16, color: white),
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
                        CustomizedText(text: 'gender'.tr, fontSize: 14, color: grey),
                        const SizedBox(width: 72),
                        GestureDetector(
                          onTap: () async => await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, dynamic>{"gender": "m"}),
                          child: CircleAvatar(radius: 25, backgroundColor: snapshot.data!.get("gender") == "m" ? blue : grey.withOpacity(.2), child: Icon(FontAwesomeIcons.mars, color: snapshot.data!.get("gender") == "m" ? white : grey, size: 20)),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async => await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, dynamic>{"gender": "f"}),
                          child: CircleAvatar(radius: 25, backgroundColor: snapshot.data!.get("gender") == "f" ? blue : grey.withOpacity(.2), child: Icon(FontAwesomeIcons.venus, color: snapshot.data!.get("gender") == "f" ? white : grey, size: 20)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () async {
                        await showDatePicker(context: context, initialDate: DateTime(1968), firstDate: DateTime(1968), lastDate: DateTime(1998), helpText: 'pickYourBirthday'.tr).then((DateTime? pickedDateOfBirth) async {
                          if (pickedDateOfBirth != null) {
                            await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, dynamic>{"date_of_birth": pickedDateOfBirth}).then((void value) => Navigator.pop(context));
                          }
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          CustomizedText(text: 'age'.tr, fontSize: 14, color: grey),
                          const SizedBox(width: 90),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[CustomizedText(text: "${DateTime.now().difference(snapshot.data!.get('date_of_birth').toDate()).inDays ~/ 365}", fontSize: 16, color: white), const SizedBox(height: 5), Container(height: .1, color: white)],
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
                          CustomizedText(text: 'email'.tr, fontSize: 14, color: grey),
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
                          CustomizedText(text: 'password'.tr, fontSize: 14, color: grey),
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
                          showToast(text: 'tapifyouwanttoselectotherwiseswipeinanydirection'.tr);
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
                                    for (Map<String, dynamic> speciality in specialityList)
                                      GestureDetector(
                                        onTap: () async {
                                          await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, dynamic>{"speciality": speciality["speciality"]}).then((void value) {
                                            showToast(text: speciality["speciality"]);
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
                            CustomizedText(text: 'speciality'.tr, fontSize: 14, color: grey),
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
                        onTap: () => change('yearsofExperience'.tr, FontAwesomeIcons.zero, false, TextInputType.number, fieldsValidator["age"], "years_of_experience"),
                        child: Row(
                          children: <Widget>[
                            CustomizedText(text: 'yearsofExperience'.tr, fontSize: 14, color: grey),
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
                          final List<String> time = <String>["--", "--"];
                          await showTimePicker(context: context, initialTime: TimeOfDay.now(), helpText: 'selectTime'.tr).then((TimeOfDay? start) async {
                            if (start != null) {
                              time[0] = start.format(context);
                            }
                            await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                              "available_time": time,
                            }).then((void value) async {
                              await showTimePicker(context: context, initialTime: TimeOfDay.now(), helpText: 'selectTime'.tr).then((TimeOfDay? finish) async {
                                if (finish != null) {
                                  time[1] = finish.format(context);
                                }
                                await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                                  "available_time": time,
                                });
                              });
                            });
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            CustomizedText(text: 'availableTime'.tr, fontSize: 14, color: grey),
                            const SizedBox(width: 55),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  if (snapshot.data!.get("available_time").isEmpty) CustomizedText(text: 'fullTime'.tr, fontSize: 16, color: white),
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
                      onTap: () => change('about'.tr, FontAwesomeIcons.stubber, false, TextInputType.text, fieldsValidator["about"], "about"),
                      child: Row(
                        children: <Widget>[
                          CustomizedText(text: 'about'.tr, fontSize: 14, color: grey),
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
                      onTap: () => change('location'.tr, FontAwesomeIcons.stubber, false, TextInputType.text, fieldsValidator["job location"], "location"),
                      child: Row(
                        children: <Widget>[
                          CustomizedText(text: 'location'.tr, fontSize: 14, color: grey),
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
                          CustomizedText(text: 'phone'.tr, fontSize: 14, color: grey),
                          const SizedBox(width: 55),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[CustomizedText(text: snapshot.data!.get("phone_number"), fontSize: 16, color: white), const SizedBox(height: 5), Container(height: .1, color: white)])),
                          const SizedBox(width: 25),
                          Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronRight, size: 15, color: grey)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: <Widget>[
                        CustomizedText(text: 'role'.tr, fontSize: 14, color: grey),
                        const SizedBox(width: 60),
                        CircleAvatar(radius: 25, backgroundColor: snapshot.data!.get("roles_list").contains("patient") ? blue : grey.withOpacity(.2), child: Icon(FontAwesomeIcons.hospitalUser, color: snapshot.data!.get("roles_list").contains("patient") ? white : grey, size: 20)),
                        const SizedBox(width: 10),
                        CircleAvatar(radius: 25, backgroundColor: snapshot.data!.get("roles_list").contains("doctor") ? blue : grey.withOpacity(.2), child: Icon(FontAwesomeIcons.userDoctor, color: snapshot.data!.get("roles_list").contains("doctor") ? white : grey, size: 20)),
                        const SizedBox(width: 10),
                        CircleAvatar(radius: 25, backgroundColor: snapshot.data!.get("roles_list").contains("admin") ? blue : grey.withOpacity(.2), child: Icon(FontAwesomeIcons.lock, color: snapshot.data!.get("roles_list").contains("admin") ? white : grey, size: 20)),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width, child: ListView.builder(padding: EdgeInsets.zero, itemCount: 3, itemBuilder: (BuildContext context, int index) => const ListTileShimmer()));
            } else {
              return ErrorRoom(error: snapshot.error.toString());
            }
          },
        ),
      ),
    );
  }
}
