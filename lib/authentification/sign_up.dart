import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setS) {
      return Scaffold(
        key: signUpScaffoldKey,
        drawer: HealthDrawer(
          func: () {
            signUpScaffoldKey.currentState!.closeDrawer();
            setS(() {});
          },
        ),
        backgroundColor: darkBlue,
        body: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(children: <Widget>[const SizedBox(width: 10), CustomIcon(func: () => Navigator.pop(context), icon: FontAwesomeIcons.chevronLeft), const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
                Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
                Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), const SizedBox(width: 30)]),
                const SizedBox(height: 60),
                Translate(text: "Sign Up", color: blue, to: language, fontWeight: FontWeight.bold).animate().fadeIn(duration: 2.seconds),
                Translate(text: "Form.", fontWeight: FontWeight.bold, to: language).animate().fadeIn(duration: 2.seconds),
                Translate(text: "To create and account you need to fill this form.", fontSize: 16, to: language).animate().fadeIn(duration: 2.seconds),
                const SizedBox(height: 30),
                CustomTextField(controller: _usernameController, hint: "Medical Professional Name", to: language, prefix: FontAwesomeIcons.userDoctor, type: TextInputType.name),
                const SizedBox(height: 10),
                CustomTextField(controller: _serviceController, hint: "Service", to: language, prefix: FontAwesomeIcons.servicestack),
                const SizedBox(height: 10),
                CustomTextField(controller: _jobLocationController, hint: "Job Location", to: language, prefix: FontAwesomeIcons.locationPin),
                const SizedBox(height: 10),
                CustomTextField(controller: _cinController, hint: "National Identity Card", to: language, prefix: FontAwesomeIcons.idBadge, type: TextInputType.number),
                const SizedBox(height: 10),
                CustomTextField(controller: _idController, hint: "Identifier", to: language, prefix: FontAwesomeIcons.userSecret),
                const SizedBox(height: 10),
                CustomTextField(controller: _emailController, hint: "E-mail", to: language, prefix: FontAwesomeIcons.envelope, type: TextInputType.emailAddress),
                const SizedBox(height: 10),
                CustomTextField(controller: _passwordController, hint: "Password", to: language, prefix: FontAwesomeIcons.lock),
                const SizedBox(height: 20),
                StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) setS) {
                    return AnimatedContainer(
                      height: expanded ? 350 : 30,
                      duration: 500.ms,
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
                                  Translate(text: "Speciality", to: language, color: blue, fontSize: 18, fontWeight: FontWeight.bold),
                                  const SizedBox(width: 10),
                                  Translate(text: speciality, to: language, fontSize: 18, fontWeight: FontWeight.bold),
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
                                              child: Translate(text: speciality_, to: language, color: white, fontSize: 16, fontWeight: FontWeight.bold))))
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
                            Translate(text: "Sign-In", to: language, fontSize: 20, fontWeight: FontWeight.bold),
                            const Spacer(),
                            CircleAvatar(radius: 17, backgroundColor: darkBlue, child: const Icon(FontAwesomeIcons.chevronRight, size: 15)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    });
  }
}
