import 'package:flutter/material.dart';
import 'package:gymapp/Theme/appcolor.dart';
import 'package:gymapp/Utils/custom_snack_bar.dart';
// import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymapp/logic/bloc/auth_bloc.dart';
import '../../login_page_1.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final gymNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final mobileNoController = TextEditingController();
  final gymLicenceNoController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final pinCodeController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();

  void _handleSignUp(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return;
    }

    final userData = {
      'gym_name': gymNameController.text.trim(),
      'gym_licence_no': gymLicenceNoController.text.trim(),
      'owner_name': ownerNameController.text.trim(),
      'email': emailController.text.trim(),
      'mobile_no': mobileNoController.text.trim(),
      'address': addressController.text.trim(),
      'city': cityController.text.trim(),
      'pin_code': pinCodeController.text.trim(),
      'state': stateController.text.trim(),
      'country': countryController.text.trim(),
    };

    context.read<AuthBloc>().add(
      SignUpEvent(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        userData: userData,
      ),
    );
  }

  void _clearFields() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    gymNameController.clear();
    ownerNameController.clear();
    mobileNoController.clear();
    gymLicenceNoController.clear();
    addressController.clear();
    cityController.clear();
    pinCodeController.clear();
    stateController.clear();
    countryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Gym Registration",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccessState) {
            CustomSnackBar.showSnackBar(
              "Successfully Signed Up! Check your email to verify.",
              SnackBarType.success,
            );
            _clearFields();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            );
          } else if (state is AuthFailureState) {
            CustomSnackBar.showSnackBar(state.error, SnackBarType.failure);
          }
        },
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(30),
            height: height * 0.75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                style: BorderStyle.solid,
                color: Colors.greenAccent,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/logo/logo.jpg'),
                          radius: 40,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'SignUp',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent,
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: PageView(
                            controller: _pageController,

                            physics:
                                NeverScrollableScrollPhysics(), // Disable swipe
                            children: [
                              _buildStep1(),
                              _buildStep2(),
                              _buildStep3(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildNavigationButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildTextField(gymNameController, 'Gym Name'),
          _buildTextField(gymLicenceNoController, 'Gym Licence No.'),
          _buildTextField(ownerNameController, 'Owner Name'),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildTextField(
            emailController,
            'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          _buildTextField(
            mobileNoController,
            'Mobile No',
            keyboardType: TextInputType.phone,
          ),
          _buildTextField(addressController, 'Address'),
          _buildTextField(cityController, 'City'),
          _buildTextField(
            pinCodeController,
            'Pin Code',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildTextField(stateController, 'State'),
          _buildTextField(countryController, 'Country'),
          _buildTextField(passwordController, 'Password', obscureText: true),
          _buildTextField(
            confirmPasswordController,
            'Confirm Password',
            obscureText: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentStep--;
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });
              },
              child: Text("Previous", style: TextStyle(color: AppColors.white)),
            ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Colors.greenAccent.withOpacity(0.2),
              ),
            ),
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                // Prevent navigation if validation fails
                return;
              }

              if (_currentStep < 2) {
                setState(() {
                  _currentStep++;
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });
              } else {
                _handleSignUp(context);
              }
            },
            child: Text(
              _currentStep < 2 ? "Next" : "Register",
              style: TextStyle(
                color: AppColors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent),
          ),
        ),
        validator:
            (value) =>
                value == null || value.isEmpty
                    ? 'This field is required'
                    : null,
      ),
    );
  }
}
