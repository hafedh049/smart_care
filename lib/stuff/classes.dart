import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import 'package:health_care/stuff/globals.dart';

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

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final TextEditingController _phoneController = TextEditingController();
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: blue.withOpacity(.3),
      highlightColor: blue.withOpacity(.3),
      focusColor: blue.withOpacity(.3),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Phone Authentification",
                    style: GoogleFonts.abel(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            style: GoogleFonts.abel(fontSize: 16),
                            controller: _phoneController,
                            cursorColor: blue,
                            autocorrect: false,
                            cursorRadius: const Radius.circular(15),
                            cursorWidth: 1,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: "Phone Number",
                              labelStyle: GoogleFonts.abel(
                                color: blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: blue),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: blue),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: blue.withOpacity(.2),
                          ),
                          child: const Center(
                            child: Icon(
                              FontAwesomeIcons.chevronRight,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      icon: Icon(
        FontAwesomeIcons.phone,
        color: blue,
        size: 20,
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  CustomTextField({super.key, required this.controller, required this.hint, this.obscured = false});
  final bool obscured;
  final TextEditingController controller;
  final String hint;
  bool obscure = false;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) _) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TextField(
            style: GoogleFonts.abel(fontSize: 16),
            controller: controller,
            cursorColor: blue,
            autocorrect: false,
            cursorRadius: const Radius.circular(15),
            cursorWidth: 1,
            obscureText: obscured ? !obscure : false,
            decoration: InputDecoration(
              labelText: hint,
              labelStyle: GoogleFonts.abel(
                color: blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              suffixIcon: obscured ? IconButton(splashColor: blue.withOpacity(.3), highlightColor: blue.withOpacity(.3), focusColor: blue.withOpacity(.3), onPressed: () => _(() => obscure = !obscure), icon: Icon(!obscure ? Icons.visibility_off : Icons.visibility, size: 15)) : null,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: blue),
              ),
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
    return IconButton(
      splashColor: blue.withOpacity(.3),
      highlightColor: blue.withOpacity(.3),
      focusColor: blue.withOpacity(.3),
      onPressed: () {},
      icon: Icon(
        FontAwesomeIcons.google,
        color: Colors.red.shade900,
        size: 20,
      ),
    );
  }
}

class OTPAuth extends StatelessWidget {
  const OTPAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: blue.withOpacity(.3),
      highlightColor: blue.withOpacity(.3),
      focusColor: blue.withOpacity(.3),
      onPressed: () {},
      icon: const Icon(
        FontAwesomeIcons.digitalOcean,
        size: 20,
      ),
    );
  }
}
