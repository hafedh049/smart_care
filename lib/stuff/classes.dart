import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_care/otp/otp_phase_1.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:lottie/lottie.dart';
import 'package:translator/translator.dart';
import 'dart:math' as math;

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
  CustomTextField({super.key, this.readonly = false, this.type = TextInputType.text, required this.controller, this.validator, required this.hint, required this.prefix, this.obscured = false, this.to = "en"});
  final bool obscured;
  final TextEditingController controller;
  final String hint;
  bool obscure = false;
  final String to;
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
          child: FutureBuilder<Translation>(
            future: translateTo(hint, to: to),
            builder: (BuildContext context, AsyncSnapshot<Translation> snapshot) {
              return TextFormField(
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
                  labelText: snapshot.hasData ? snapshot.data!.text : hint,
                  labelStyle: GoogleFonts.abel(color: blue, fontSize: 16, fontWeight: FontWeight.bold),
                  prefix: Padding(padding: const EdgeInsets.only(right: 8.0), child: Icon(prefix, size: 15, color: blue)),
                  suffixIcon: obscured ? IconButton(splashColor: blue.withOpacity(.3), highlightColor: blue.withOpacity(.3), focusColor: blue.withOpacity(.3), onPressed: () => _(() => obscure = !obscure), icon: Icon(!obscure ? Icons.visibility_off : Icons.visibility, color: blue, size: 15)) : null,
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
                  disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
                  errorBorder: OutlineInputBorder(borderSide: BorderSide(color: red)),
                  errorStyle: GoogleFonts.abel(color: red, fontSize: 14),
                ),
              );
            },
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
        child: CircleAvatar(radius: 20, backgroundColor: Colors.red, child: GestureDetector(onTap: () {}, child: const Center(child: Icon(FontAwesomeIcons.google, size: 15)))),
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
  const Translate({super.key, required this.text, this.to = "en", this.color = Colors.white, this.fontSize = 35, this.fontWeight = FontWeight.normal});
  final String text;
  final String to;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Translation>(
      future: translateTo(text, to: to),
      builder: (BuildContext context, AsyncSnapshot<Translation> snapshot) {
        return Text(snapshot.hasData ? snapshot.data!.text : text, style: GoogleFonts.abel(color: color, fontSize: fontSize, fontWeight: fontWeight));
      },
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
            LottieBuilder.asset("assets/health.json", width: 250, height: 250),
            StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setS) {
                return Row(
                  children: <Widget>[
                    Translate(text: "Language", to: language, fontSize: 18, fontWeight: FontWeight.bold),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setS(() {
                        language = "en";
                        widget.func();
                        showToast("Language Changed Successfully");
                      }),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(border: Border.all(color: language == "en" ? blue : white, width: 2), color: transparent, borderRadius: BorderRadius.circular(5)),
                        child: Center(child: Text("EN", style: GoogleFonts.abel(color: language == "en" ? blue : white, fontSize: 18, fontWeight: language == "en" ? FontWeight.bold : FontWeight.normal))),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => setS(() {
                        language = "fr";
                        widget.func();
                        showToast("Langue modifiée avec succès");
                      }),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(border: Border.all(color: language == "fr" ? blue : white, width: 2), color: transparent, borderRadius: BorderRadius.circular(5)),
                        child: Center(child: Text("FR", style: GoogleFonts.abel(color: language == "fr" ? blue : white, fontSize: 18, fontWeight: language == "fr" ? FontWeight.bold : FontWeight.normal))),
                      ),
                    ),
                  ],
                );
              },
            ),
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
