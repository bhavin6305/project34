import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0E0E10), // Twitch dark bg
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF9146FF), // Twitch purple
      brightness: Brightness.dark,
      background: const Color(0xFF0E0E10),
      surface: const Color(0xFF18181B),
    ),

    textTheme: GoogleFonts.rajdhaniTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black.withOpacity(0.7),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.rajdhani(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    cardTheme: const CardThemeData(
  color: Color(0xFF1E1E20),
  elevation: 6,
  margin: EdgeInsets.all(10),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      hintStyle: TextStyle(
        color: Colors.white.withOpacity(0.5),
        fontSize: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF9146FF), width: 1.5),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF9146FF),
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.rajdhani(
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF9146FF),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );
}
