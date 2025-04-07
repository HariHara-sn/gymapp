import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildText extends StatelessWidget {
  final String text; 
  final bool bold;
  const BuildText(this.text, {this.bold = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: bold ? Colors.red : Colors.greenAccent,
        ),
      ),
    );
  }
}