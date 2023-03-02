// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_care/home/home.dart';
import 'package:smart_care/otp/otp_phase_1.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';
import 'dart:math' as math;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HalfCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = white.withOpacity(.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    const Offset center = Offset(50, 0);
    const double radius = 30;
    const double startAngle = -math.pi;
    const double sweepAngle = 2 * math.pi;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(HalfCirclePainter oldDelegate) => false;
}

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  CustomTextField({super.key, this.readonly = false, this.type = TextInputType.text, required this.controller, this.validator, required this.hint, required this.prefix, this.obscured = false});
  final bool obscured;
  final TextEditingController controller;
  final String hint;
  bool obscure = false;
  final IconData prefix;
  final TextInputType type;
  final String? Function(String?)? validator;
  final bool readonly;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) _) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TextFormField(
            validator: validator,
            style: GoogleFonts.abel(fontSize: 16),
            controller: controller,
            cursorColor: blue,
            autocorrect: false,
            readOnly: readonly,
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
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
              disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
              errorBorder: OutlineInputBorder(borderSide: BorderSide(color: red)),
              errorStyle: GoogleFonts.abel(color: red, fontSize: 14),
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
    return Container(
      height: 60,
      width: 60,
      color: darkBlue,
      child: Center(
        child: CircleAvatar(
          radius: 20,
          backgroundColor: red,
          child: GestureDetector(
            onTap: () async {
              try {
                await GoogleSignIn().signIn().then((GoogleSignInAccount? googleAccount) async {
                  await googleAccount!.authentication.then((GoogleSignInAuthentication authentication) async {
                    AuthCredential credential = GoogleAuthProvider.credential(idToken: authentication.idToken, accessToken: authentication.accessToken);
                    await FirebaseAuth.instance.signInWithCredential(credential).then((UserCredential value) async {
                      List<String> providers = await FirebaseAuth.instance.fetchSignInMethodsForEmail(value.user!.email!);
                      if (providers.isNotEmpty) {
                        await FirebaseAuth.instance.currentUser!.unlink(providers.first).then((User value) async {
                          await value.linkWithCredential(credential).then((value) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Home()));
                          });
                        });
                      } else {
                        showToast(AppLocalizations.of(context)!.no_user_linked, color: red);
                      }
                    });
                  });
                });
              } catch (_) {
                showToast(_.toString(), color: red);
              }
            },
            child: const Center(child: Icon(FontAwesomeIcons.google, size: 15)),
          ),
        ),
      ),
    );
  }
}

class OTPAuth extends StatelessWidget {
  const OTPAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      color: darkBlue,
      child: Center(
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.green,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const OTPView()));
            },
            child: const Center(child: Icon(FontAwesomeIcons.phone, size: 15)),
          ),
        ),
      ),
    );
  }
}

class Translate extends StatelessWidget {
  const Translate({super.key, required this.text, this.color = Colors.white, this.fontSize = 35, this.fontWeight = FontWeight.normal});
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.abel(color: color, fontSize: fontSize, fontWeight: fontWeight));
  }
}

class HealthDrawer extends StatefulWidget {
  const HealthDrawer({super.key, required this.func});
  final void Function() func;

  @override
  State<HealthDrawer> createState() => _HealthDrawerState();
}

class _HealthDrawerState extends State<HealthDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 275,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(25), topRight: Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Spacer(),
            Row(children: <Widget>[Expanded(child: Container(height: 1, color: white))]),
            const SizedBox(height: 10),
            GestureDetector(
                onTap: () async {
                  showToast(AppLocalizations.of(context)!.signing_out);
                  await GoogleSignIn().signOut().then((GoogleSignInAccount? value) async {
                    await FirebaseAuth.instance.signOut();
                  });
                },
                child: Translate(text: AppLocalizations.of(context)!.sign_out, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  const CustomIcon({super.key, required this.func, required this.icon});
  final void Function() func;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Container(width: 40, height: 40, color: darkBlue, child: Center(child: Icon(icon, size: 15))),
    );
  }
}
