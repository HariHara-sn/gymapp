import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymapp/Theme/appcolor.dart';
import 'package:gymapp/login_page_2.dart';
import 'divider_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';

class GymOwnerOptions extends StatelessWidget {
  final double width;
  const GymOwnerOptions({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Log in or Sign up',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
        ),

        const SizedBox(height: 20),

        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.backgroundColor,
            foregroundColor: AppColors.greenAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(color: Colors.greenAccent),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 14,
              horizontal: width * 0.1 + 50,
            ),
          ),
          icon: const Icon(Icons.mail, color: Colors.white),
          label: AutoSizeText(
            'Continue with Mail',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
            maxLines: 1,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EmailLogin()),
            );
          },
        ),

        const SizedBox(height: 10),
        DividerWidget(),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.greenAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(color: Colors.greenAccent),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 14,
              horizontal: width * 0.1 + 50,
            ),
          ),
          icon: Image.asset('assets/icons/google_logo.png', height: 24),
          label: AutoSizeText(
            'Sign in with Google',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
            maxLines: 1,
          ),
          onPressed: () {
            // Handle Google Sign-in
          },
        ),

        const SizedBox(height: 20),

        // GestureDetector(
        //   onTap:
        //       () => Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => SignUp()),
        //       ),
        //   child: Text(
        //     'DON\'T HAVE ACCOUNT? SIGN UP',
        //     style: GoogleFonts.poppins(
        //       fontSize: 15,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.greenAccent,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
