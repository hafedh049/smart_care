import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../globals.dart';

// Define the primary and secondary color palettes
const Color primaryColor = Color(0xFF3FC5F0);
const Color secondaryColor = Color(0xFF48B5E8);
const Color lightGrayColor = Color(0xFFEFEFEF);

// Define the typography styles
final TextStyle headingTextStyle = GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.bold);

final TextStyle bodyTextStyle = GoogleFonts.openSans(fontSize: 16);

// Define the light theme
final ThemeData lightTheme_ = ThemeData(
  primaryColor: primaryColor,
  scaffoldBackgroundColor: lightGrayColor,
  appBarTheme: const AppBarTheme(color: Colors.white, elevation: 0, iconTheme: IconThemeData(color: black)),
  textTheme: TextTheme(
    displayLarge: headingTextStyle,
    displayMedium: headingTextStyle.copyWith(fontSize: 20.0),
    displaySmall: headingTextStyle.copyWith(fontSize: 18.0),
    headlineMedium: headingTextStyle.copyWith(fontSize: 16.0),
    headlineSmall: headingTextStyle.copyWith(fontSize: 14.0),
    titleMedium: bodyTextStyle,
    titleSmall: bodyTextStyle.copyWith(fontSize: 14.0),
    bodyLarge: bodyTextStyle,
    bodyMedium: bodyTextStyle.copyWith(fontSize: 14.0),
    labelLarge: bodyTextStyle.copyWith(color: Colors.white),
  ),
  buttonTheme: ButtonThemeData(buttonColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), textTheme: ButtonTextTheme.primary),
  inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: lightGrayColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)), hintStyle: bodyTextStyle.copyWith(color: Colors.grey)),
  iconTheme: const IconThemeData(color: secondaryColor),
  cardTheme: CardTheme(color: Colors.white, elevation: 2.0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
);
