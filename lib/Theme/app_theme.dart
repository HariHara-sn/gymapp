import 'package:flutter/material.dart';
import 'package:gymapp/Theme/appcolor.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(
      centerTitle: true,

      surfaceTintColor: AppColors.backgroundColor,
      backgroundColor: AppColors.backgroundColor.withOpacity(0.1),
      titleTextStyle: GoogleFonts.poppins(
        color: AppColors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    inputDecorationTheme: darkInputDecorationTheme,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.greenAccent, // Cursor color
      selectionColor: AppColors.greenAccent.withOpacity(
        0.6,
      ), // Text selection background color
      selectionHandleColor: AppColors.greenAccent,
    ),
  );

  static final InputDecorationTheme darkInputDecorationTheme =
      InputDecorationTheme(
        labelStyle: TextStyle(color: AppColors.greenAccent),
        hintStyle: const TextStyle(color: Colors.white24),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.greenAccent),
          borderRadius: BorderRadius.circular(8), // Optional rounded borders
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.greenAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.greenAccent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
      );
}
