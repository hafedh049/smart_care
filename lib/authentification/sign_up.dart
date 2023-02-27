import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_care/stuff/classes.dart';
import 'package:health_care/stuff/functions.dart';
import 'package:health_care/stuff/globals.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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
  String speciality = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
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
                    Translate(text: "Sign Up", color: blue, to: language, fontWeight: FontWeight.bold).animate().fadeIn(duration: 2.seconds),
                    Translate(text: "Form.", fontWeight: FontWeight.bold, to: language).animate().fadeIn(duration: 2.seconds),
                    Translate(text: "To create and account you need to fill this form.", fontSize: 16, to: language).animate().fadeIn(duration: 2.seconds),
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
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
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
                                                  setS(() => speciality = "( $speciality_ )");
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
                          child: Row(
                            children: <Widget>[
                              Translate(text: "Speciality", to: language, color: blue, fontSize: 18, fontWeight: FontWeight.bold),
                              if (speciality.isNotEmpty) const SizedBox(width: 10),
                              if (speciality.isNotEmpty) Translate(text: speciality, to: language, fontSize: 18, fontWeight: FontWeight.bold),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            if (_formKey.currentState!.validate()) {
                              showToast(language == "en" ? "Welcome" : "Bienvenue");
                            } else {
                              showToast(language == "en" ? "Verify fields please" : "Vérifiez les champs s'il vous plaît");
                            }
                          } catch (_) {
                            showToast(_.toString());
                          }
                        },
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
          ),
        );
      },
    );
  }
}
