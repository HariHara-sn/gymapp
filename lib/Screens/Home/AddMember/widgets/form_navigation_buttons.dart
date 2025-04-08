import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormNavigationButtons extends StatelessWidget {
  final int currentPage;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;
  final VoidCallback onSavePressed;
  final bool isSubmitting;
  final double bottomPadding;

  const FormNavigationButtons({
    super.key,
    required this.currentPage,
    required this.onPreviousPressed,
    required this.onNextPressed,
    required this.onSavePressed,
    required this.isSubmitting,
    this.bottomPadding = 0.05,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Button
          if (currentPage > 0)
            Padding(
              padding: EdgeInsets.only(bottom: height * bottomPadding),
              child: _buildNavigationButton(
                text: 'Previous',
                onPressed: onPreviousPressed,
              ),
            )
          else
            const SizedBox(width: 100),

          // Next/Save Button
          if (currentPage < 3)
            Padding(
              padding: EdgeInsets.only(bottom: height * bottomPadding),
              child: _buildNavigationButton(
                text: 'Next',
                onPressed: onNextPressed,
              ),
            )
          else
            Padding(
              padding: EdgeInsets.only(bottom: height * bottomPadding),
              child: _buildSaveButton(
                onPressed: isSubmitting ? null : onSavePressed,
                isSubmitting: isSubmitting,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.greenAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: Colors.greenAccent),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 30,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSaveButton({
    required VoidCallback? onPressed,
    required bool isSubmitting,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.greenAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: Colors.greenAccent),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 40,
        ),
      ),
      onPressed: onPressed,
      child: isSubmitting
          ? const CircularProgressIndicator(
              color: Colors.greenAccent,
            )
          : Text(
              'Save',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    );
  }
}