// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_care/authentification/sign_in.dart';
import 'package:smart_care/otp/otp_phase_1.dart';
import 'package:smart_care/screens/screens.dart';
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
  CustomTextField({super.key, this.readonly = false, this.func, this.type = TextInputType.text, required this.controller, this.validator, required this.hint, required this.prefix, this.obscured = false});
  final bool obscured;
  final TextEditingController controller;
  final String hint;
  bool obscure = false;
  final IconData prefix;
  final TextInputType type;
  final String? Function(String?)? validator;
  final bool readonly;
  final void Function(String)? func;

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
    return Center(
      child: GestureDetector(
        onTap: () async {
          try {
            await GoogleSignIn().signIn().then((GoogleSignInAccount? googleAccount) async {
              if (googleAccount != null) {
                List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(googleAccount.email);
                if (signInMethods.contains('google.com')) {
                  // Google provider is linked with email/password provider
                  await googleAccount.authentication.then((GoogleSignInAuthentication authentication) async {
                    AuthCredential credential = GoogleAuthProvider.credential(idToken: authentication.idToken, accessToken: authentication.accessToken);
                    await FirebaseAuth.instance.signInWithCredential(credential);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const Screens()), (Route route) => route.isFirst);
                  });
                } else {
                  // Google provider is not linked with email/password provider
                  showToast(AppLocalizations.of(context)!.no_user_linked, color: red);
                }
              }
            });
          } catch (_) {
            showToast(_.toString(), color: red);
          }
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
              Image.asset("assets/google.png"),
              CustomizedText(text: "CONTINUE WITH GOOGLE", fontSize: 16, fontWeight: FontWeight.bold, color: white),
            ],
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
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OTPView())),
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
              Image.asset("assets/phone.png"),
              CustomizedText(text: "CONTINUE WITH PHONE", color: white, fontSize: 16, fontWeight: FontWeight.bold),
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
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.roboto(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      softWrap: true,
      overflow: TextOverflow.fade,
    );
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
            Container(width: 275, height: 200, color: white),
            const Spacer(),
            Container(width: 267, height: 1, color: white),
            const SizedBox(height: 10),
            GestureDetector(
                onTap: () async {
                  showToast(AppLocalizations.of(context)!.signing_out);
                  await GoogleSignIn().signOut();
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const SignIn()), (Route route) => route.isFirst);
                },
                child: CustomizedText(text: AppLocalizations.of(context)!.sign_out, fontSize: 18, fontWeight: FontWeight.bold)),
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
              Icon(
                icon,
                size: size,
                color: clicked ? white : white.withOpacity(.5),
              ),
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
        CustomizedText(text: AppLocalizations.of(context)!.or, fontSize: 20, fontWeight: FontWeight.bold),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(height: .5, width: MediaQuery.of(context).size.width * .4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(25))),
        ),
      ],
    );
  }
}

class Role extends StatelessWidget {
  const Role({super.key, required this.role, required this.state});
  final String role;
  final bool state;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 120,
      height: 120,
      padding: const EdgeInsets.all(8.0),
      duration: 500.ms,
      decoration: BoxDecoration(
        border: state ? Border.all(color: blue) : null,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          LottieBuilder.asset("assets/$role.json", width: 60, height: 60),
          const SizedBox(height: 5),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CustomizedText(text: role[0].toUpperCase() + role.substring(1), fontSize: 18, fontWeight: FontWeight.bold, color: white),
              Visibility(visible: state, child: const SizedBox(width: 10)),
              Visibility(visible: state, child: Icon(FontAwesomeIcons.circleCheck, color: blue, size: 15)),
            ],
          ),
        ],
      ),
    );
  }
}

class SignUpIcon extends StatelessWidget {
  const SignUpIcon({super.key, required this.icon, required this.activeState});
  final IconData icon;
  final bool activeState;
  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 20, color: activeState ? blue : white)
        .animate(
          target: activeState ? 1 : 0,
        )
        .scale(duration: 500.ms, begin: const Offset(1, 1), end: const Offset(1.5, 1.5));
  }
}

class ListTileShimmer extends StatelessWidget {
  const ListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: grey,
      highlightColor: white,
      child: ListTile(
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
      ),
    );
  }
}
