import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymapp/Screens/MemberScreen/member_screen.dart';
import 'package:gymapp/Theme/appcolor.dart';
import 'package:gymapp/Screens/widgets/gym_owner_options.dart';
import 'package:gymapp/Screens/widgets/toggle.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isGymOwner = false; // Default is Member

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/gym_banner.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            CircleAvatar(
              backgroundImage: AssetImage('assets/logo/logo.jpg'),
              radius: 35,
            ),

            const SizedBox(height: 10),

            Text(
              'Manage Your Gym',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.greenAccent,
              ),
            ),

            const SizedBox(height: 20),

            // Toggle Buttons: Gym Owner / Member
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Toggle(
                  title: "Member",
                  value: !isGymOwner,
                  onTap: () {
                    setState(() {
                      isGymOwner = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WorkoutScreen()),
                    );
                  },
                ),
                const SizedBox(width: 10),
                Toggle(
                  title: "Gym Owner",
                  value: isGymOwner,
                  onTap: () {
                    setState(() {
                      isGymOwner = true;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // If Gym Owner is selected, show login/signup options
            if (isGymOwner) GymOwnerOptions(width: width),
            if (!isGymOwner) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '🔥 Tap to enter as a Member!',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
