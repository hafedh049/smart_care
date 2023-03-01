import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/authentification/recovery.dart';
import 'package:smart_care/authentification/sign_up.dart';
import 'package:smart_care/home/home.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';

import '../stuff/functions.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool wait = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setS) {
        return Scaffold(
          key: signInScaffoldKey,
          drawer: HealthDrawer(
            func: () {
              signInScaffoldKey.currentState!.closeDrawer();
              setS(() {});
            },
          ),
          backgroundColor: darkBlue,
          body: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
                    Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
                    Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue.withOpacity(.5)), const SizedBox(width: 30)]),
                    const SizedBox(height: 60),
                    Translate(text: "Welcome", fontWeight: FontWeight.bold, to: language, color: blue).animate().fadeIn(duration: 500.ms),
                    Translate(text: "Sign-In now", fontWeight: FontWeight.bold, to: language, fontSize: 35).animate().fadeIn(duration: 500.ms),
                    Translate(text: "Welcome back, please fill the form to sign in and continue.", to: language, fontSize: 16).animate().fadeIn(duration: 500.ms),
                    const SizedBox(height: 30),
                    Row(
                      children: <Widget>[
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Recovery())),
                          child: Container(
                            height: 35,
                            width: 150,
                            decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(25)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Translate(text: "Recover Account", to: language, fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(validator: fieldsValidators["email"], controller: _emailController, hint: "E-mail", to: language, prefix: FontAwesomeIcons.envelope, type: TextInputType.emailAddress),
                    const SizedBox(height: 10),
                    CustomTextField(validator: fieldsValidators["password"], controller: _passwordController, hint: "Password", obscured: true, to: language, prefix: FontAwesomeIcons.lock),
                    const SizedBox(height: 60),
                    Center(
                      child: StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) setS) {
                          return IgnorePointer(
                            ignoring: wait,
                            child: GestureDetector(
                              onTap: () async {
                                try {
                                  if (_formKey.currentState!.validate()) {
                                    setS(() => wait = true);
                                    await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim()).then(
                                          (UserCredential value) => Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) => const Home(),
                                            ),
                                          ),
                                        );
                                  } else {
                                    showToast(language == "en" ? "Verify fields please" : "Vérifiez les champs s'il vous plaît");
                                  }
                                } catch (_) {
                                  setS(() => wait = false);
                                  showToast(_.toString());
                                }
                              },
                              child: AnimatedContainer(
                                duration: 500.ms,
                                height: 40,
                                width: wait ? MediaQuery.of(context).size.width * .37 : MediaQuery.of(context).size.width * .6,
                                decoration: BoxDecoration(color: wait ? green : blue, borderRadius: BorderRadius.circular(25)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      if (!wait) const Spacer(),
                                      Translate(text: wait ? "Connecting ..." : "Sign-In", fontWeight: FontWeight.bold, to: language, fontSize: 20),
                                      if (!wait) const Spacer(),
                                      if (!wait) CircleAvatar(radius: 17, backgroundColor: darkBlue, child: const Icon(FontAwesomeIcons.chevronRight, size: 15)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const SignUp())),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Translate(text: "Don't have an account? ", fontSize: 18, to: language),
                            const SizedBox(width: 10),
                            Translate(text: "Register now", color: blue, fontSize: 18, fontWeight: FontWeight.bold, to: language),
                          ],
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
                        Translate(text: "OR", fontSize: 20, fontWeight: FontWeight.bold, to: language),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(height: .5, width: MediaQuery.of(context).size.width * .4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(25))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const <Widget>[OTPAuth(), GoogleAuth()],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
