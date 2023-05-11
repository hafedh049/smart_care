// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_care/authentification/choices_box.dart';
import 'package:smart_care/authentification/sign_in.dart';
import 'package:smart_care/drawer/about_us.dart';
import 'package:smart_care/drawer/settings.dart';
import 'package:smart_care/otp/otp_phase_1.dart';
import 'package:smart_care/screens/smart_chat_bot.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';
import 'dart:math' show pi;
import 'package:url_launcher/url_launcher_string.dart';

import '../drawer/profile.dart';

class HalfCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = white.withOpacity(.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    const Offset center = Offset(50, 0);
    const double radius = 30;
    const double startAngle = -pi;
    const double sweepAngle = 2 * pi;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(HalfCirclePainter oldDelegate) => false;
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, this.readonly = false, this.func, this.type = TextInputType.text, required this.controller, this.validator, required this.hint, required this.prefix, this.obscured = false});
  final bool obscured;
  final TextEditingController controller;
  final String hint;
  final IconData prefix;
  final TextInputType type;
  final String? Function(String?)? validator;
  final bool readonly;
  final void Function(String)? func;

  @override
  Widget build(BuildContext context) {
    bool obscure = false;
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) _) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TextFormField(
            validator: validator,
            style: GoogleFonts.abel(fontSize: 16),
            controller: controller,
            cursorColor: blue,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            autocorrect: false,
            readOnly: readonly,
            onChanged: func,
            enabled: !readonly,
            cursorRadius: const Radius.circular(15),
            cursorWidth: 1,
            obscureText: obscured ? !obscure : false,
            keyboardType: type,
            decoration: InputDecoration(
              labelText: hint,
              labelStyle: GoogleFonts.abel(color: blue, fontSize: 16, fontWeight: FontWeight.bold),
              prefix: Padding(padding: const EdgeInsets.only(right: 8.0), child: Icon(prefix, size: 15, color: blue)),
              suffixIcon: obscured ? IconButton(splashColor: blue.withOpacity(.3), highlightColor: blue.withOpacity(.3), focusColor: blue.withOpacity(.3), onPressed: () => _(() => obscure = !obscure), icon: Icon(!obscure ? Icons.visibility_off : Icons.visibility, color: blue, size: 15)) : null,
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: blue)),
              disabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: blue)),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: blue)),
              errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 255, 70, 70))),
              errorStyle: GoogleFonts.abel(color: const Color.fromARGB(255, 255, 70, 70), fontSize: 14),
            ),
          ),
        );
      },
    );
  }
}

class GoogleAuth extends StatelessWidget {
  const GoogleAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          try {
            await GoogleSignIn().signIn().then((GoogleSignInAccount? googleAccount) async {
              if (googleAccount != null) {
                List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(googleAccount.email);
                if (signInMethods.isEmpty) {
                  showToast(text: 'nouserlinkedtothisaccountpleasecreateone'.tr);
                } else if (signInMethods.contains('google.com')) {
                  await googleAccount.authentication.then((GoogleSignInAuthentication authentication) async {
                    AuthCredential credential = GoogleAuthProvider.credential(idToken: authentication.idToken, accessToken: authentication.accessToken);
                    await FirebaseAuth.instance.signInWithCredential(credential);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const ChoicesBox()), (Route route) => false);
                  });
                } else {
                  final GoogleSignInAuthentication googleAuth = await googleAccount.authentication;
                  final OAuthCredential googleCredential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
                  showToast(text: 'signedWithGoogle'.tr);
                  await FirebaseAuth.instance.currentUser!.linkWithCredential(googleCredential);
                  await FirebaseAuth.instance.signInWithCredential(googleCredential);
                  showToast(text: 'accountLinkedWithGoogle'.tr);
                  await getToken();
                  await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({"token": userToken}).then((void value) async {
                    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const ChoicesBox()), (Route route) => false);
                  });
                }
              }
            });
          } catch (_) {
            showToast(text: _.toString(), color: red);
          }
        },
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width * .6,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(boxShadow: [BoxShadow(blurStyle: BlurStyle.outer, color: white.withOpacity(0.5), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 2))], color: transparent, borderRadius: BorderRadius.circular(5), border: Border.all(color: white.withOpacity(.5))),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[Image.asset("assets/icon/google.png"), CustomizedText(text: 'cONTINUEWITHGOOGLE'.tr, fontSize: 16, fontWeight: FontWeight.bold, color: white)]),
        ),
      ),
    );
  }
}

class OTPAuth extends StatelessWidget {
  const OTPAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          goTo(const OTPView());
        },
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width * .6,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(blurStyle: BlurStyle.outer, color: white.withOpacity(0.5), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 2))],
            color: transparent,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: white.withOpacity(.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset("assets/icon/phone.png"),
              CustomizedText(text: 'cONTINUEWITHPHONE'.tr, color: white, fontSize: 16, fontWeight: FontWeight.bold),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomizedText extends StatelessWidget {
  const CustomizedText({super.key, required this.text, this.color = Colors.white, this.fontSize = 35, this.fontWeight = FontWeight.normal});
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) => Text(text, style: GoogleFonts.roboto(color: color, fontSize: fontSize, fontWeight: fontWeight), softWrap: true, overflow: TextOverflow.fade);
}

class HealthDrawer extends StatelessWidget {
  const HealthDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 275,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(25), topRight: Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 40),
                Row(
                  children: <Widget>[
                    const CircleAvatar(
                      backgroundColor: blue,
                      radius: 35,
                      backgroundImage: CachedNetworkImageProvider(appIcon),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const CustomizedText(text: appTitle, color: white, fontSize: 20, fontWeight: FontWeight.bold),
                        const SizedBox(width: 10),
                        CustomizedText(text: 'youmakeworldbetter'.tr, color: white.withOpacity(.7), fontSize: 16),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(width: 267, height: .1, color: white),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const Profile()));
              },
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(width: 2, height: 20, decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5))),
                  const SizedBox(width: 5),
                  const Icon(FontAwesomeIcons.idCard, color: white, size: 20),
                ],
              ),
              title: CustomizedText(text: 'profile'.tr, color: white.withOpacity(.7), fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const SmartSettings()));
              },
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(width: 2, height: 20, decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5))),
                  const SizedBox(width: 5),
                  const Icon(FontAwesomeIcons.gear, color: white, size: 20),
                ],
              ),
              title: CustomizedText(text: 'settings'.tr, color: white.withOpacity(.7), fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const AboutUs()));
              },
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(width: 2, height: 20, decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5))),
                  const SizedBox(width: 5),
                  const Icon(FontAwesomeIcons.heartPulse, color: white, size: 20),
                ],
              ),
              title: CustomizedText(text: 'aboutUs'.tr, color: white.withOpacity(.7), fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (me["role"] == "patient") Container(width: 267, height: .1, color: white),
            if (me["role"] == "patient")
              ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const SmartChatBot())),
                leading: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[Container(width: 2, height: 20, decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5))), const SizedBox(width: 5), const Icon(FontAwesomeIcons.bots, color: white, size: 20)]),
                title: CustomizedText(text: "Quark", color: white.withOpacity(.7), fontSize: 18, fontWeight: FontWeight.bold),
              ),
            Container(width: 267, height: .1, color: white),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const SignIn()), (Route route) => false);
                await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({"status": false, "token": ""}).then((void value) async {
                  await FirebaseMessaging.instance.deleteToken();
                  await FirebaseAuth.instance.signOut();
                });
              },
              horizontalTitleGap: 0,
              leading: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[Container(width: 2, height: 20, decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5))), const SizedBox(width: 5), const Icon(FontAwesomeIcons.chevronLeft, color: white, size: 20)]),
              title: CustomizedText(text: 'signOut'.tr, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(width: 267, height: .1, color: white),
            const SizedBox(height: 10),
            CustomizedText(text: "'Smart Care' ${'isYourAssistant'.tr}", fontSize: 14, color: white.withOpacity(.7)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    launchUrlString("https://www.instagram.com/explore/tags/telemedecine/");
                  },
                  child: const CircleAvatar(
                    radius: 22,
                    backgroundColor: white,
                    child: CircleAvatar(radius: 20, backgroundColor: Color.fromARGB(255, 36, 35, 42), child: Icon(FontAwesomeIcons.instagram, color: white, size: 25)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launchUrlString("https://www.facebook.com/groups/telemedecinec");
                  },
                  child: const CircleAvatar(
                    radius: 22,
                    backgroundColor: white,
                    child: CircleAvatar(radius: 20, backgroundColor: Color.fromARGB(255, 36, 35, 42), child: Icon(FontAwesomeIcons.facebook, color: white, size: 25)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launchUrlString("https://twitter.com/tlm360?lang=ar");
                  },
                  child: const CircleAvatar(
                    radius: 22,
                    backgroundColor: white,
                    child: CircleAvatar(radius: 20, backgroundColor: Color.fromARGB(255, 36, 35, 42), child: Icon(FontAwesomeIcons.twitter, color: white, size: 25)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  const CustomIcon({super.key, required this.func, required this.icon, this.clicked = false, this.size = 15});
  final void Function() func;
  final IconData icon;
  final bool clicked;
  final double size;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: clicked ? blue.withOpacity(.4) : transparent,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: size, color: clicked ? white : white.withOpacity(.5)),
              Visibility(visible: clicked, child: const SizedBox(height: 5)),
              AnimatedContainer(
                duration: 500.ms,
                width: clicked ? 30 : 0,
                height: clicked ? 1 : 0,
                decoration: BoxDecoration(
                  color: blue,
                  borderRadius: BorderRadius.circular(5),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Or extends StatelessWidget {
  const Or({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(height: .5, width: MediaQuery.of(context).size.width * .4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(25))),
        const SizedBox(width: 10),
        CustomizedText(text: 'oR'.tr, fontSize: 20, fontWeight: FontWeight.bold),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(height: .5, width: MediaQuery.of(context).size.width * .4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(25))),
        ),
      ],
    );
  }
}

class ListTileShimmer extends StatelessWidget {
  const ListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 48.0,
        height: 48.0,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 8.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
          ),
          const SizedBox(height: 10),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 8.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
          ),
          const SizedBox(height: 10),
          Container(
            width: 40.0,
            height: 8.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
          ),
        ],
      ),
      horizontalTitleGap: 8.0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
    ).animate(onComplete: (AnimationController controller) => controller.repeat(period: const Duration(seconds: 2))).shimmer(color: grey, colors: <Color>[white, grey]);
  }
}

class CircleShimmer extends StatelessWidget {
  const CircleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(radius: 15).animate(onComplete: (AnimationController controller) => controller.repeat(period: const Duration(seconds: 2))).shimmer(color: grey, colors: <Color>[white, grey]);
  }
}

class AvatarUsernameLocationShimmer extends StatelessWidget {
  const AvatarUsernameLocationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const CircleAvatar(radius: 25),
        const SizedBox(height: 15),
        Container(width: 120, height: 9, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white)),
        const SizedBox(height: 10),
        Container(width: 170, height: 7, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white)),
      ],
    ).animate(onComplete: (AnimationController controller) => controller.repeat(period: const Duration(seconds: 2))).shimmer(color: grey, colors: <Color>[white, grey]);
  }
}

class Tree {
  String? text;
  IconData? icon;
  Tree({required this.text, required this.icon});
}
