import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../home/home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FocusNode _phoneNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _jobLocationController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool wait = false;

  @override
  void dispose() {
    _specialityController.dispose();
    _phoneNode.dispose();
    _phoneController.dispose();
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
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setS) {
        return Scaffold(
          key: signUpScaffoldKey,
          drawer: HealthDrawer(
            func: () {
              signUpScaffoldKey.currentState!.closeDrawer();
              setS(() {});
              _formKey.currentState!.validate();
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
                    Row(children: <Widget>[const SizedBox(width: 10), CustomIcon(func: () => Navigator.pop(context), icon: FontAwesomeIcons.chevronLeft), const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
                    Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
                    Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), const SizedBox(width: 30)]),
                    const SizedBox(height: 60),
                    Translate(text: "Sign Up", color: blue, to: language, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
                    Translate(text: "Form.", fontWeight: FontWeight.bold, to: language).animate().fadeIn(duration: 500.ms),
                    Translate(text: "To create and account you need to fill this form.", fontSize: 16, to: language).animate().fadeIn(duration: 500.ms),
                    const SizedBox(height: 30),
                    CustomTextField(validator: fieldsValidators["username"], controller: _usernameController, hint: "Medical Professional Name", to: language, prefix: FontAwesomeIcons.userDoctor, type: TextInputType.name),
                    const SizedBox(height: 10),
                    CustomTextField(validator: fieldsValidators["service"], controller: _serviceController, hint: "Service", to: language, prefix: FontAwesomeIcons.servicestack),
                    const SizedBox(height: 10),
                    CustomTextField(validator: fieldsValidators["job location"], controller: _jobLocationController, hint: "Job Location", to: language, prefix: FontAwesomeIcons.locationPin),
                    const SizedBox(height: 10),
                    CustomTextField(validator: fieldsValidators["cin"], controller: _cinController, hint: "National Identity Card", to: language, prefix: FontAwesomeIcons.idBadge, type: TextInputType.number),
                    const SizedBox(height: 10),
                    CustomTextField(validator: fieldsValidators["id"], controller: _idController, hint: "Identifier", to: language, prefix: FontAwesomeIcons.userSecret),
                    const SizedBox(height: 10),
                    CustomTextField(validator: fieldsValidators["email"], controller: _emailController, hint: "E-mail", to: language, prefix: FontAwesomeIcons.envelope, type: TextInputType.emailAddress),
                    const SizedBox(height: 10),
                    CustomTextField(validator: fieldsValidators["password"], controller: _passwordController, hint: "Password", to: language, prefix: FontAwesomeIcons.lock, obscured: true),
                    const SizedBox(height: 10),
                    StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) setS) {
                        return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const SizedBox(height: 10),
                                        ...specialityList
                                            .map((String speciality_) => GestureDetector(
                                                  onTap: () {
                                                    setS(() => _specialityController.text = speciality_);
                                                    Navigator.pop(context);
                                                  },
                                                  child: SizedBox(
                                                    height: 40,
                                                    child: Translate(text: speciality_, to: language, color: white, fontSize: 16, fontWeight: FontWeight.bold),
                                                  ),
                                                ))
                                            .toList(),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: CustomTextField(controller: _specialityController, hint: "Speciality", prefix: FontAwesomeIcons.bomb, validator: fieldsValidators["speciality"], to: language, readonly: true));
                      },
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InternationalPhoneNumberInput(
                        searchBoxDecoration: InputDecoration(
                          labelText: language == 'en' ? 'Country' : 'Pays',
                          labelStyle: GoogleFonts.abel(color: blue, fontSize: 16, fontWeight: FontWeight.bold),
                          prefix: Padding(padding: const EdgeInsets.only(right: 8.0), child: Icon(FontAwesomeIcons.flag, size: 15, color: blue)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
                        ),
                        autoValidateMode: AutovalidateMode.always,
                        focusNode: _phoneNode,
                        cursorColor: blue,
                        initialValue: PhoneNumber(isoCode: "TN", dialCode: "+216"),
                        errorMessage: language == 'en' ? 'Not a valid number' : 'Not a valid number',
                        inputBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
                        onInputChanged: (PhoneNumber value) {},
                        textStyle: GoogleFonts.abel(fontSize: 16),
                        spaceBetweenSelectorAndTextField: 0,
                        textFieldController: _phoneController,
                        selectorTextStyle: GoogleFonts.abel(fontSize: 16),
                        selectorButtonOnErrorPadding: 0,
                        onInputValidated: (bool value) => value ? _phoneNode.unfocus() : null,
                        selectorConfig: const SelectorConfig(leadingPadding: 8.0, selectorType: PhoneInputSelectorType.BOTTOM_SHEET, trailingSpace: false, useEmoji: true, setSelectorButtonAsPrefixIcon: true),
                        inputDecoration: InputDecoration(
                          labelText: language == 'en' ? 'Phone Number' : 'Numéro Du Téléphone',
                          labelStyle: GoogleFonts.abel(color: blue, fontSize: 16, fontWeight: FontWeight.bold),
                          prefix: Padding(padding: const EdgeInsets.only(right: 8.0), child: Icon(FontAwesomeIcons.phone, size: 15, color: blue)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: blue)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                                    await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim()).then((UserCredential value) async {
                                      await FirebaseFirestore.instance.collection("health_care_professionals").doc(FirebaseAuth.instance.currentUser!.uid).set({
                                        "account_creation_date": Timestamp.now(),
                                        "medical_professional_name": _usernameController.text.trim(),
                                        "service": _serviceController.text.trim(),
                                        "job_location": _jobLocationController.text.trim(),
                                        "cin": _cinController.text.trim(),
                                        "id": _idController.text.trim(),
                                        "email": _emailController.text.trim(),
                                        "password": _passwordController.text.trim(),
                                        "speciality": _specialityController.text.trim(),
                                        "phone_number": _phoneController.text.trim(),
                                      }).then(
                                        (void value) => Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) => const Home(),
                                          ),
                                        ),
                                      );
                                    });
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
                                width: wait ? MediaQuery.of(context).size.width * .35 : MediaQuery.of(context).size.width * .6,
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
                    const SizedBox(height: 10),
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
