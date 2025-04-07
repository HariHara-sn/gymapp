import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(child: Divider(color: Colors.greenAccent, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'OR',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
          ),
        ),
        const Expanded(child: Divider(color: Colors.greenAccent, thickness: 1)),
      ],
    );
  }
}
