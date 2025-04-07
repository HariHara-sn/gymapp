import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymapp/Theme/appcolor.dart';

class BuildRadioButton extends StatefulWidget {
  final String value;
  final IconData icon;
  final String groupValue;
  final Function(String) onChanged; // Callback function

  const BuildRadioButton({
    super.key,
    required this.value,
    required this.icon,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  State<BuildRadioButton> createState() => _BuildRadioButtonState();
}

class _BuildRadioButtonState extends State<BuildRadioButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(widget.icon, color: Colors.greenAccent, size: 20),
        Radio(
          activeColor: AppColors.greenAccent,
        
          value: widget.value,
          groupValue: widget.groupValue, // Use the passed group value
          onChanged: (val) {
            widget.onChanged(widget.value); // Call the callback function
          },
        ),
        Text(
          widget.value,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.greenAccent),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
