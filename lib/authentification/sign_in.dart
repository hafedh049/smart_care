import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_care/authentification/recovery.dart';
import 'package:health_care/authentification/sign_up.dart';
import 'package:health_care/stuff/classes.dart';
import 'package:health_care/stuff/globals.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
              Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue.withOpacity(.5)), const SizedBox(width: 30)]),
              const SizedBox(height: 60),
              Text("Hello", style: GoogleFonts.abel(color: blue, fontSize: 35, fontWeight: FontWeight.bold)).animate().fadeIn(duration: 2.seconds),
              Text("Sign-In now.", style: GoogleFonts.abel(fontSize: 35, fontWeight: FontWeight.bold)).animate().fadeIn(duration: 2.seconds),
              Text("Welcome, back please fill the form\nto sign in and continue.", style: GoogleFonts.abel(fontSize: 16)).animate().fadeIn(duration: 2.seconds),
              const SizedBox(height: 30),
              Row(
                children: <Widget>[
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const SignUp())),
                    child: Container(
                      height: 35,
                      width: 70,
                      decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text("Sign-Up", style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 10),
              CustomTextField(controller: _emailController, hint: "E-mail"),
              const SizedBox(height: 10),
              CustomTextField(controller: _passwordController, hint: "Password", obscured: true),
              const SizedBox(height: 60),
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
              const SizedBox(height: 30),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Recovery())),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: "Don't have an account? ", style: GoogleFonts.abel(fontSize: 16)),
                        TextSpan(text: "Register now", style: GoogleFonts.abel(color: blue, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(height: .5, width: MediaQuery.of(context).size.width * .4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(25))),
                  const SizedBox(width: 10),
                  Text("OR", style: GoogleFonts.abel(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Container(height: .5, width: MediaQuery.of(context).size.width * .38, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(25))),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[PhoneAuth(), GoogleAuth(), OTPAuth()],
              )
            ],
          ),
        ),
      ),
    );
  }
}
