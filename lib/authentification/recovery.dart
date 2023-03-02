import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../stuff/functions.dart';

class Recovery extends StatefulWidget {
  const Recovery({super.key});

  @override
  State<Recovery> createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool wait = false;

  @override
  void dispose() {
    _oldpasswordController.dispose();
    _newpasswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setS) {
        return Scaffold(
          backgroundColor: darkBlue,
          body: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[const SizedBox(width: 10), CustomIcon(func: () => Navigator.pop(context), icon: FontAwesomeIcons.chevronLeft), const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
                  Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
                  Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), const SizedBox(width: 30)]),
                  LottieBuilder.asset("assets/recover.json"),
                  Translate(text: AppLocalizations.of(context)!.account, color: blue, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
                  Translate(text: AppLocalizations.of(context)!.recovery, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
                  Translate(text: AppLocalizations.of(context)!.after_continuing, fontSize: 16).animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      CustomTextField(controller: _emailController, hint: AppLocalizations.of(context)!.old_email, prefix: FontAwesomeIcons.envelope, type: TextInputType.emailAddress, validator: fieldsValidators["email"]),
                      const SizedBox(height: 10),
                      CustomTextField(controller: _oldpasswordController, hint: AppLocalizations.of(context)!.old_password, prefix: FontAwesomeIcons.key, validator: fieldsValidators["password"], obscured: true),
                      const SizedBox(height: 10),
                      CustomTextField(controller: _newpasswordController, hint: AppLocalizations.of(context)!.new_password, prefix: FontAwesomeIcons.key, validator: fieldsValidators["password"], obscured: true),
                    ]),
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
                                  await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _oldpasswordController.text.trim()).then((UserCredential value) async {
                                    await FirebaseAuth.instance.currentUser!.updatePassword(_newpasswordController.text.trim()).then(
                                      (void value) async {
                                        await showDialog(
                                          context: context,
                                          builder: (BuildContext context) => AlertDialog(
                                            content: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Center(child: LottieBuilder.asset("assets/ok.json")),
                                                  const SizedBox(height: 20),
                                                  Translate(text: AppLocalizations.of(context)!.email_sent, fontSize: 20, fontWeight: FontWeight.bold).animate().shimmer(duration: 5.seconds, color: blue),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ).then((value) async {
                                          setS(() => wait = false);
                                          await GoogleSignIn().signOut();
                                          await FirebaseAuth.instance.signOut();
                                        });
                                      },
                                    );
                                  });
                                } else {
                                  showToast(AppLocalizations.of(context)!.verify_email_field);
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
                                    Translate(text: wait ? AppLocalizations.of(context)!.done : AppLocalizations.of(context)!.send_email, fontWeight: FontWeight.bold, fontSize: 20),
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
        );
      },
    );
  }
}
