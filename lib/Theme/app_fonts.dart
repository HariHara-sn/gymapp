import 'package:flutter/material.dart';


class AppFonts {
  static const String poppinsRegular = "Poppins";
  static const String poppinsBold = "Poppins";
  
  // You can also define complete styles here
  static TextStyle get boldTitle => TextStyle(
    fontFamily: poppinsBold,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
}