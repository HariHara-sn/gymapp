import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ContactUsBtn extends StatelessWidget {
  const ContactUsBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
              onTap: () {
                // Handle Contact Us action
              },
              child: Text(
                'Contact Us',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.greenAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            );
  }
}