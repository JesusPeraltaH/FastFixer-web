import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTextTheme {
  static TextTheme lightTextTheme = TextTheme(
      bodyLarge: GoogleFonts.montserrat(color: Colors.black),
      bodySmall: GoogleFonts.poppins(
        color: Colors.black,
        fontSize: 12,
      ),
      titleLarge: GoogleFonts.poppins(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 14,
      ));

  static TextTheme darkTextTheme = TextTheme(
      bodyLarge: GoogleFonts.montserrat(
        color: Colors.white,
      ),
      bodySmall: GoogleFonts.poppins(
        color: Colors.white54,
        fontSize: 12,
      ),
      titleLarge: GoogleFonts.poppins(
        color: Colors.white54,
        fontSize: 30,
      ));
}
