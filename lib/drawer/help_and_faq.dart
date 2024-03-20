import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/globals.dart';

class HelpAndFAQ extends StatefulWidget {
  const HelpAndFAQ({super.key});

  @override
  State<HelpAndFAQ> createState() => _HelpAndFAQState();
}

class _HelpAndFAQState extends State<HelpAndFAQ> {
  final List<Map<String, String>> _texts = const <Map<String, String>>[
    <String, String>{"state": "Header", "text": "Welcome to our mobile app! We are here to help you get the most out of our product. Below you'll find some frequently asked questions and answers to help you navigate our app."},
    <String, String>{"state": "Space", "number": "\n\n"},
    <String, String>{"state": "Big Title", "text": "Getting Started"},
    <String, String>{"state": "Space", "number": "\n"},
    <String, String>{"state": "Title", "text": "How do I get started with the app?"},
    <String, String>{"state": "Normal", "text": "To get started with our app, simply download it from the App Store or Google Play and install it on your mobile device. Once installed, open the app and follow the prompts to create an account."},
    <String, String>{"state": "Title", "text": "How do I log in to my account?"},
    <String, String>{"state": "Normal", "text": "To log in to your account, open the app and enter your username and password on the login screen."},
    <String, String>{"state": "Title", "text": "I am having trouble logging in. What should I do?"},
    <String, String>{"state": "Normal", "text": 'If you are having trouble logging in, please make sure that you have entered the correct username and password. If you still can\'t log in, tap on the "Forgot Password" link on the login screen and follow the instructions provided.'},
    <String, String>{"state": "Space", "number": "\n\n"},
    <String, String>{"state": "Big Title", "text": "App Features"},
    <String, String>{"state": "Space", "number": "\n"},
    <String, String>{"state": "Title", "text": "How do I schedule an appointment with a healthcare provider?"},
    <String, String>{"state": "Normal", "text": 'To schedule an appointment with a healthcare provider, tap on the "Schedule Appointment" tab and follow the instructions provided. You can choose the provider, date, and time that works best for you.'},
    <String, String>{"state": "Title", "text": "How do I access my medical records?"},
    <String, String>{"state": "Normal", "text": 'To access your medical records, tap on the "Medical Records" tab and select the record you wish to view. You can view your test results, medications, and other relevant information.'},
    <String, String>{"state": "Title", "text": "Can I message my healthcare provider through the app?"},
    <String, String>{"state": "Normal", "text": 'Yes, you can message your healthcare provider through the app. To do so, tap on the "Messages" tab and select the provider you wish to message.'},
    <String, String>{"state": "Title", "text": "How do I refill my prescription through the app?"},
    <String, String>{"state": "Normal", "text": 'To refill your prescription through the app, tap on the "Prescriptions" tab and follow the instructions provided. You can request a refill, view your current prescriptions, and more.'},
    <String, String>{"state": "Title", "text": "How do I make a payment for services rendered?"},
    <String, String>{"state": "Normal", "text": 'To make a payment for services rendered, tap on the "Payments" tab and follow the instructions provided. You can view your balance, make a payment, and view payment history.'},
    <String, String>{"state": "Space", "number": "\n\n"},
    <String, String>{"state": "Big Title", "text": "Account Management"},
    <String, String>{"state": "Space", "number": "\n"},
    <String, String>{"state": "Title", "text": "How do I reset my password?"},
    <String, String>{"state": "Normal", "text": 'To reset your password, tap on the "Forgot Password" link on the login screen and follow the instructions provided.'},
    <String, String>{"state": "Title", "text": "How do I update my account information?"},
    <String, String>{"state": "Normal", "text": 'To update your account information, tap on the "My Account" tab and select "Edit Profile". You can then update your information and save your changes.'},
    <String, String>{"state": "Title", "text": "How do I change my notification settings?"},
    <String, String>{"state": "Normal", "text": 'To change your notification settings, tap on the "Settings" tab and select "Notifications". You can then choose which notifications you want to receive and how often.'},
    <String, String>{"state": "Space", "number": "\n\n"},
    <String, String>{"state": "Big Title", "text": "Contact Support"},
    <String, String>{"state": "Space", "number": "\n"},
    <String, String>{"state": "Footer", "first_half": "If you still have questions or need additional help, please contact our customer support team at ", "link": "www.fmm.tn", "second_half": " We're always here to help you make the most of our product."},
    <String, String>{"state": "Space", "number": "\n"},
    <String, String>{"state": "Normal", "text": 'We hope this help page has been informative and helpful. Thank you for choosing our app!.'},
  ];

  @override
  void initState() {
    _loadTexts();
    super.initState();
  }

  void _loadTexts() {
    _animatedTextsList.add(
      (_texts[_index]["state"] == "Header")
          ? TypewriterAnimatedText(_texts[_index]["text"]!, textStyle: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold))
          : (_texts[_index]["state"] == "Big Title")
              ? TypewriterAnimatedText(_texts[_index]["text"]!, textStyle: GoogleFonts.roboto(fontSize: 24, color: blue, fontWeight: FontWeight.bold))
              : (_texts[_index]["state"] == "Title")
                  ? TypewriterAnimatedText("\u25A0 ${_texts[_index]["text"]}", textStyle: GoogleFonts.roboto(fontSize: 16, color: blue, fontWeight: FontWeight.bold))
                  : (_texts[_index]["state"] == "Footer")
                      ? TypewriterAnimatedText("${_texts[_index]["first_half"]}${_texts[_index]["link"]}${_texts[_index]["second_half"]}", textStyle: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold))
                      : (_texts[_index]["state"] == "Normal")
                          ? TypewriterAnimatedText("    ${_texts[_index]["text"]}", textStyle: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold))
                          : TypewriterAnimatedText(_texts[_index]["number"]!, textStyle: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  int _index = 0;
  final List<AnimatedText> _animatedTextsList = <AnimatedText>[];

  @override
  void dispose() {
    _index = 0;
    _animatedTextsList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 50),
                  for (int index = 0; index < _animatedTextsList.length; index++)
                    AnimatedTextKit(
                      displayFullTextOnTap: true,
                      animatedTexts: <AnimatedText>[_animatedTextsList[index]],
                      isRepeatingAnimation: false,
                      pause: 500.ms,
                      onFinished: () {
                        if (index == _animatedTextsList.length - 1) {
                          _index += 1;
                          if (_index < 38) {
                            _loadTexts();
                            _(() {});
                          }
                        }
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
