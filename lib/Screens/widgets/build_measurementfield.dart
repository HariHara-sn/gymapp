import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'build_underline_text.dart';
class MeasurementField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const MeasurementField({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$label :",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.greenAccent,
              ),
            ),
            BuildUnderlineText(
              controller: controller,
              inputType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}
