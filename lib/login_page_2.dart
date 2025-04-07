import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymapp/Screens/widgets/custom_email_pass_field.dart';
import 'package:gymapp/Screens/widgets/forget_password.dart';
import 'package:gymapp/Utils/custom_snack_bar.dart';
import 'package:gymapp/Utils/bottom_navigationbar.dart';
import 'package:gymapp/provider/auth_cubit.dart';
import 'Utils/service/internet_checker.dart';
import 'logic/bloc/auth_bloc.dart';
import 'main.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({super.key});

  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  //<<----Auth----->>
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailureState) {
            CustomSnackBar.showSnackBar(state.error, SnackBarType.failure);
          } else if (state is AuthSuccessState) {
            // Save the token in SharedPreferences
            context.read<AuthCubit>().saveToken(state.userId.toString());

            CustomSnackBar.showSnackBar(
              "Login Successful",
              SnackBarType.success,
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MyNavigationBar()),
              (route) => false,
            );
          } else if (state is ForgotPasswordSuccessState) {
            CustomSnackBar.showSnackBar(
              "Password reset link sent. Please check your email.",
              SnackBarType.success,
            );
          } else if (state is ForgotPasswordFailureState) {
            CustomSnackBar.showSnackBar(state.error, SnackBarType.failure);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/gym_banner.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const CircleAvatar(
                backgroundImage: AssetImage('assets/logo/logo.jpg'),
                radius: 35,
              ),
              const SizedBox(height: 10),
              Text(
                'Manage Your Gym',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Log in',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Email Field
              CustomTextField(
                controller: emailController,
                hintText: 'Email',
                icon: Icons.mail,
                autofillHints: [AutofillHints.email],
              ),

              const SizedBox(height: 10),

              // Password Field
              CustomTextField(
                controller: passwordController,
                hintText: 'Password',
                icon: Icons.lock,
                isPassword: true,
                autofillHints: [AutofillHints.password],
              ),

              const SizedBox(height: 20),

              // Login Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return ElevatedButton.icon(
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
                      onPressed:
                          state is AuthLoadingState ? null : _handleLogin,
                      icon:
                          state is AuthLoadingState
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Icon(Icons.login, color: Colors.white),
                      label: Text(
                        'Login',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              ForgetPassword(),
              const SizedBox(height: 10),
              // Contact Us
              // const ContactUsBtn(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        CustomSnackBar.showSnackBar(
          "Please enter email and password",
          SnackBarType.failure,
        );
        return;
      }

      // Check internet connection
      final hasConnection = await InternetChecker.hasInternetConnection();
      if (!hasConnection) {
        CustomSnackBar.showSnackBar(
          "No internet connection",
          SnackBarType.failure,
        );
        return;
      }

      context.read<AuthBloc>().add(
        SignInEvent(email: email, password: password),
      );
    } catch (e) {
      // Handle any unexpected errors
      CustomSnackBar.showSnackBar(
        "An error occurred. Please try again.",
        SnackBarType.failure,
      );
      logger.e('Login error: $e');
    }
  }
}
