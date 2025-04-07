import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymapp/Theme/appcolor.dart';
import '../../logic/bloc/auth_bloc.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _showBottomSheet(context),
      child: Text(
        'Forgot Password?',
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: AppColors.greenAccent,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            // final screenHeight = MediaQuery.of(context).size.height;
            // logger.f("keyboard height: $keyboardHeight");
            // logger.i("screen height: $screenHeight");

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: FractionallySizedBox(
                heightFactor: 0.55,
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 25,
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          'Forgot Password',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.poppins(
                          color: AppColors.backgroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: AppColors.backgroundColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        autofocus: true,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              final email = emailController.text.trim();
                              final isValidEmail = RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(email);

                              if (email.isNotEmpty && isValidEmail) {
                                context.read<AuthBloc>().add(
                                  ForgotPasswordEvent(email: email),
                                );
                                Navigator.pop(context);
                              } else {
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Enter a valid email address',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.white,
                                      ),
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "Send Reset Link",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
