import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Toggle extends StatelessWidget {
  final String title;
  final bool value;
  final VoidCallback onTap;
  const Toggle({super.key, required this.title, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: value ? Colors.greenAccent : Colors.black,
        foregroundColor: value ? Colors.black : Colors.greenAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: Colors.greenAccent),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
      ),
      onPressed: onTap,
      
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
