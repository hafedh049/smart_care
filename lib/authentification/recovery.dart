import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/authentification/sign_in.dart';
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
  final FocusNode _phoneNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool wait = false;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setS) {
        return Scaffold(
          backgroundColor: darkBlue,
          resizeToAvoidBottomInset: false,
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
                  Row(children: <Widget>[const SizedBox(width: 10), CustomIcon(func: () => Navigator.pop(context), icon: FontAwesomeIcons.chevronLeft), const Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
                  Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), const SizedBox(width: 30)]),
                  LottieBuilder.asset("assets/recover.json"),
                  CustomizedText(text: AppLocalizations.of(context)!.account, color: blue, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
                  CustomizedText(text: AppLocalizations.of(context)!.recovery, fontWeight: FontWeight.bold).animate().fadeIn(duration: 500.ms),
                  CustomizedText(text: AppLocalizations.of(context)!.after_continuing, fontSize: 16).animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: 10),
                  CustomTextField(controller: _emailController, hint: "E-mail", prefix: FontAwesomeIcons.envelope, validator: fieldsValidatorsFunction("email", context), type: TextInputType.emailAddress),
                  const SizedBox(height: 10),
                  Center(
                    child: StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) setS) {
                        return IgnorePointer(
                          ignoring: wait,
                          child: GestureDetector(
                            onTap: () async {
                              if (play == 1) {
                                playNote("tap.wav");
                              }
                              try {
                                if (_formKey.currentState!.validate()) {
                                  setS(() => wait = false);
                                  await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim()).then((void value) {
                                    showToast("Password reset email sent to ${_emailController.text.trim()} (If not found check the SPAM section)", color: blue);
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const SignIn()), (Route route) => route.isFirst);
                                  });
                                }
                              } catch (_) {
                                setS(() => wait = false);
                                showToast(_.toString(), color: red);
                              }
                            },
                            child: AnimatedContainer(
                              duration: 500.ms,
                              height: 40,
                              width: wait ? MediaQuery.of(context).size.width * .35 : MediaQuery.of(context).size.width * .6,
                              decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Visibility(visible: !wait, child: const Spacer()),
                                    CustomizedText(text: wait ? AppLocalizations.of(context)!.done : AppLocalizations.of(context)!.send_email, color: black, fontWeight: FontWeight.bold, fontSize: 18),
                                    Visibility(visible: !wait, child: const Spacer()),
                                    Visibility(visible: !wait, child: Icon(FontAwesomeIcons.chevronRight, size: 15, color: black)),
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
