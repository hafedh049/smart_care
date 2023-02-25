import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_care/stuff/classes.dart';
import 'package:health_care/stuff/globals.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool expanded = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _jobLocationController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String speciality = "";
  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _jobLocationController.dispose();
    _serviceController.dispose();
    _cinController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
              Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
              Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), const SizedBox(width: 30)]),
              const SizedBox(height: 60),
              Text("Sign Up", style: GoogleFonts.abel(color: blue, fontSize: 35, fontWeight: FontWeight.bold)).animate().fadeIn(duration: 2.seconds),
              Text("Form.", style: GoogleFonts.abel(fontSize: 35, fontWeight: FontWeight.bold)).animate().fadeIn(duration: 2.seconds),
              Text("To create and account you need to fill this form.", style: GoogleFonts.abel(fontSize: 16)).animate().fadeIn(duration: 2.seconds),
              const SizedBox(height: 30),
              CustomTextField(controller: _usernameController, hint: "Medical Professional"),
              const SizedBox(height: 10),
              CustomTextField(controller: _serviceController, hint: "Service"),
              const SizedBox(height: 10),
              CustomTextField(controller: _jobLocationController, hint: "Job Location"),
              const SizedBox(height: 10),
              CustomTextField(controller: _cinController, hint: "CIN"),
              const SizedBox(height: 10),
              CustomTextField(controller: _idController, hint: "Identifier"),
              const SizedBox(height: 10),
              CustomTextField(controller: _emailController, hint: "E-mail"),
              const SizedBox(height: 10),
              CustomTextField(controller: _passwordController, hint: "Password"),
              const SizedBox(height: 20),
              StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setS) {
                  return AnimatedContainer(
                    height: expanded ? 432 : 30,
                    duration: 600.ms,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => setS(() => expanded = !expanded),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text("Speciality", style: GoogleFonts.abel(color: blue, fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 10),
                                Text(speciality, style: GoogleFonts.abel(fontSize: 18, fontWeight: FontWeight.bold)),
                                const Spacer(),
                                Icon(expanded ? FontAwesomeIcons.chevronDown : FontAwesomeIcons.chevronLeft, size: 15, color: blue),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: expanded,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 10),
                                ...specialityList
                                    .map((String speciality_) => SizedBox(
                                        height: 40,
                                        child: GestureDetector(
                                            onTap: () => setS(() {
                                                  expanded = false;
                                                  speciality = "( $speciality_ )";
                                                }),
                                            child: Text(speciality_, style: GoogleFonts.abel(color: white, fontSize: 16, fontWeight: FontWeight.bold)))))
                                    .toList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * .6,
                    decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(25)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          const Spacer(),
                          Text("Sign-In", style: GoogleFonts.abel(fontSize: 20, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          CircleAvatar(radius: 17, backgroundColor: darkBlue, child: const Icon(FontAwesomeIcons.chevronRight, size: 15)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
