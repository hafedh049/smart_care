import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../globals.dart';

// Define the primary and secondary color palettes
const Color primaryColor = Color(0xFF3FC5F0);
const Color secondaryColor = Color(0xFF48B5E8);
const Color darkGrayColor = Color(0xFF222222);

// Define the typography styles
final TextStyle headingTextStyle = GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.bold, color: white);

final TextStyle bodyTextStyle = GoogleFonts.openSans(fontSize: 16, color: white);

// Define the dark theme
final ThemeData darkTheme_ = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: darkGrayColor,
  appBarTheme: const AppBarTheme(color: darkGrayColor, elevation: 0, iconTheme: IconThemeData(color: white)),
  textTheme: TextTheme(
    displayLarge: headingTextStyle,
    displayMedium: headingTextStyle.copyWith(fontSize: 20),
    displaySmall: headingTextStyle.copyWith(fontSize: 18),
    headlineMedium: headingTextStyle.copyWith(fontSize: 16),
    headlineSmall: headingTextStyle.copyWith(fontSize: 14),
    titleMedium: bodyTextStyle,
    titleSmall: bodyTextStyle.copyWith(fontSize: 14),
    bodyLarge: bodyTextStyle,
    bodyMedium: bodyTextStyle.copyWith(fontSize: 14),
    labelLarge: bodyTextStyle.copyWith(color: white),
  ),
  buttonTheme: ButtonThemeData(buttonColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), textTheme: ButtonTextTheme.primary),
  inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: Colors.grey.shade800, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none), hintStyle: bodyTextStyle.copyWith(color: Colors.grey.shade400), errorStyle: bodyTextStyle.copyWith(color: Colors.redAccent)),
  iconTheme: const IconThemeData(color: secondaryColor),
  cardTheme: CardTheme(color: darkGrayColor, elevation: 2.0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
);
