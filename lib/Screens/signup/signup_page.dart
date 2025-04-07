// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:gymapp/Theme/appcolor.dart';
// import 'package:gymapp/Utils/check_permission.dart';
// import 'package:gymapp/repositories/auth_repository.dart';
// import 'package:gymapp/main.dart';
// import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
// import 'package:file_picker/file_picker.dart';
// import 'package:path/path.dart'; // Import for file extension
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../Utils/custom_snack_bar.dart';
// import '../login_page_1.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gymapp/logic/bloc/auth_bloc.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   _SignUpState createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   SharedPreferences? prefs; //sharedPreferences Instances
//   File? _imageFile;

//   final SupabaseClient supabase = Supabase.instance.client;
//   final AuthRepository _authRepository = AuthRepository();
//   //<<--Auth--->>
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   //<<--SignUp--->>
//   final confirmPasswordController = TextEditingController();
//   final gymNameController = TextEditingController();
//   final ownerNameController = TextEditingController();
//   final mobileNoController = TextEditingController();
//   final gymLicenceNoController = TextEditingController();
//   final addressController = TextEditingController();
//   final cityController = TextEditingController();
//   final pinCodeController = TextEditingController();
//   final stateController = TextEditingController();
//   final countryController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   Future<void> pickFile(BuildContext context) async {
//     if (!context.mounted) {
//       return; // Exit early if the widget is no longer in the tree
//     }
//     try {
//       await CheckPermission().requestGalleryPermission();
//       var status = await Permission.photos.status;
//       logger.i(status);
//       if (status.isGranted) {
//         FilePickerResult? result = await FilePicker.platform.pickFiles(
//           type: FileType.image,
//         );

//         if (result == null || result.files.isEmpty) {
//           CustomSnackBar.showSnackBar(
//             'No file selected!',
//             SnackBarType.failure,
//           );
//           return;
//         }

//         setState(() {
//           _imageFile = File(result.files.single.path!);
//           logger.e("_imageFile : $_imageFile");
//         });
//       }
//       // else if (status.isPermanentlyDenied) {
//       //   // Step 6: Handle permanently denied permission
//       //   ScaffoldMessenger.of(context).showSnackBar(
//       //     SnackBar(
//       //       content: Text(
//       //         'Permission to access gallery is permanently denied. Please enable it in app settings.',
//       //       ),
//       //       action: SnackBarAction(
//       //         label: 'Open Settings',
//       //         onPressed: () => openAppSettings(),
//       //       ),
//       //     ),
//       //   );
//       // }
//       else {
//         //        Step 7: Handle denied permission
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: ExcludeSemantics(
//               child: Text(
//                 'Permission to access gallery is required.',
//                 style: TextStyle(color: AppColors.white),
//               ),
//             ),
//             action: SnackBarAction(
//               label: 'Open Settings',
//               textColor: AppColors.white,

//               onPressed: () => openAppSettings(),
//             ),
//             behavior: SnackBarBehavior.floating,
//             backgroundColor: AppColors.red,
//             duration: const Duration(seconds: 4),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             margin: const EdgeInsets.all(10),
//           ),
//         );

//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(
//         //     content: Text('Permission to access gallery is required.'),
//         //     action: SnackBarAction(
//         //       label: 'Open Settings',

//         //       onPressed: () => openAppSettings(),
//         //     ),
//         //   ),
//         // );

//         // CustomSnackBar.showSnackBar(
//         //   "Permission to access gallery is required.",
//         //   SnackBarType.failure,
//         // );
//       }
//     } catch (e) {
//       logger.e("Error picking file: $e");
//       CustomSnackBar.showSnackBar(
//         "An error occurred while picking the file.",
//         SnackBarType.failure,
//       );
//     }
//   }

//   Future<String?> uploadImage(File imageFile) async {
//     try {
//       final fileExt = extension(imageFile.path);
//       final fileName =
//           'gymlogo_${DateTime.now().millisecondsSinceEpoch}$fileExt';
//       final filePath = 'gymlogo/$fileName';
//       print("File Path : $filePath");

//       // Upload the file
//       await supabase.storage.from('gymlogo').upload(filePath, imageFile);

//       // Get the public URL
//       final publicUrl = supabase.storage.from('gymlogo').getPublicUrl(filePath);
//       print("Public URL: $publicUrl");

//       return publicUrl;
//     } catch (e) {
//       print('Image Upload Error: $e');
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.greenAccent,
//         title: Text(
//           "Gym Registration",
//           style: GoogleFonts.poppins(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: AppColors.backgroundColor,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthSuccessState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("Successfully Signed Up! Check email.")),
//             );
//             Navigator.pop(context);
//           } else if (state is AuthFailureState) {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(SnackBar(content: Text(state.error)));
//           }
//         },
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey, // Assign the form key
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20.0),
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     margin: EdgeInsets.all(15),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         // color: AppColors.lightgreen,
//                         color: AppColors.greenAccent,
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 50,
//                           backgroundColor: AppColors.maingreen,
//                         ),
//                         Text(
//                           'SignUp',
//                           style: TextStyle(
//                             fontSize: 30,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.greenAccent,
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(10.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               // Gym Name
//                               _buildTextField(gymNameController, 'Gym Name'),
//                               SizedBox(height: 10),
//                               // Gym Licence No.
//                               _buildTextField(
//                                 gymLicenceNoController,
//                                 'Gym Licence No.',
//                               ),
//                               SizedBox(height: 10),
//                               // Owner Name
//                               _buildTextField(
//                                 ownerNameController,
//                                 'Owner Name',
//                               ),
//                               SizedBox(height: 10),
//                               // Email
//                               _buildTextField(
//                                 emailController,
//                                 'Email',
//                                 keyboardType: TextInputType.emailAddress,
//                               ),
//                               SizedBox(height: 10),
//                               // Mobile No
//                               _buildTextField(
//                                 mobileNoController,
//                                 'Mobile No',
//                                 keyboardType: TextInputType.phone,
//                               ),
//                               SizedBox(height: 10),
//                               // Address
//                               _buildTextField(addressController, 'Address'),
//                               SizedBox(height: 10),
//                               // City
//                               _buildTextField(cityController, 'City'),
//                               SizedBox(height: 10),
//                               // Pin Code
//                               _buildTextField(
//                                 pinCodeController,
//                                 'Pin Code',
//                                 keyboardType: TextInputType.number,
//                               ),
//                               SizedBox(height: 10),
//                               // State
//                               _buildTextField(countryController, 'Country'),
//                               SizedBox(height: 10),
//                               // Country
//                               _buildTextField(stateController, 'State'),
//                               SizedBox(height: 10),
//                               // Password
//                               _buildTextField(
//                                 passwordController,
//                                 'Password',
//                                 obscureText: true,
//                               ),
//                               SizedBox(height: 10),
//                               // Confirm Password
//                               _buildTextField(
//                                 confirmPasswordController,
//                                 'Confirm Password',
//                                 obscureText: true,
//                               ),
//                               SizedBox(height: 15),

//                               // Upload Gym Logo Button
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   ElevatedButton.icon(
//                                     onPressed: () => pickFile(context),
//                                     icon: Icon(
//                                       Icons.image,
//                                       color: AppColors.greenAccent,
//                                     ),
//                                     label: Text(
//                                       'Upload Gym Logo',
//                                       style: TextStyle(
//                                         color: AppColors.greenAccent,
//                                       ),
//                                     ),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.transparent,
//                                       side: BorderSide(
//                                         color: AppColors.greenAccent,
//                                       ),
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: 15,
//                                         horizontal: 20,
//                                       ),
//                                     ),
//                                   ),
//                                   // Display Selected Image
//                                   if (_imageFile != null)
//                                     Padding(
//                                       padding: const EdgeInsets.all(15.0),
//                                       child: Image.file(
//                                         _imageFile!,
//                                         height: 100,
//                                         width: 100,
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Register Button
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 50.0),
//                   child: ElevatedButton(
//                     onPressed:
//                         () => _handleSignUp(
//                           passwordController.text.trim(),
//                           confirmPasswordController.text.trim(),
//                           context,
//                         ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green, // Button color
//                       padding: EdgeInsets.symmetric(
//                         horizontal: MediaQuery.of(context).size.width * 0.3,
//                         vertical: 14,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(
//                           5,
//                         ), // Makes it rectangular
//                       ),
//                     ),
//                     child: Text(
//                       'Register',
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _handleSignUp(
//     String pass,
//     String confirmPass,
//     BuildContext context,
//   ) async {
//     if (!_formKey.currentState!.validate()) {
//       // If the form is not valid, stop the process
//       return;
//     }

//     if (pass != confirmPass) {
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Passwords do not match")));
//       }
//       return;
//     }

//     String? imageUrl;
//     if (_imageFile != null) {
//       imageUrl = await uploadImage(_imageFile!);
//     }

//     // try {
//     //   if (mounted) {
//     //     // Sign up with email and password
//     //     final signUpResult = await _authRepository.signUpWithEmail(
//     //       emailController.text.trim(),
//     //       passwordController.text.trim(),
//     //     );

//     //     signUpResult.fold(
//     //       (error) {
//     //         ScaffoldMessenger.of(
//     //           context,
//     //         ).showSnackBar(SnackBar(content: Text('Error: $error')));
//     //       },
//     //       (userId) async {
//     //         // ref.read(sampleProvider.notifier).saveToken(userId.toString());  ///token

//     //         CustomSnackBar.showSnackBar(
//     //           "Successfully Signed Up! Check your email to verify.",
//     //           SnackBarType.success,
//     //         );

//     //         await supabase.from('signup').insert({
//     //           'gymId': userId,
//     //           'gym_name': gymNameController.text.trim(),
//     //           'gym_licence_no': gymLicenceNoController.text.trim(),
//     //           'owner_name': ownerNameController.text.trim(),
//     //           'email': emailController.text.trim(),
//     //           'mobile_no': mobileNoController.text.trim(),
//     //           'address': addressController.text.trim(),
//     //           'city': cityController.text.trim(),
//     //           'pin_code': pinCodeController.text.trim(),
//     //           'state': stateController.text.trim(),
//     //           'country': countryController.text.trim(),
//     //           'gym_logo_url': imageUrl ?? '',
//     //         });

//     //         Navigator.pushAndRemoveUntil(
//     //           context,
//     //           MaterialPageRoute(builder: (context) => LoginScreen()),
//     //           (route) => false,
//     //         );
//     //       },
//     //     );
//     //   }
//     // } catch (e) {
//     //   if (mounted) {
//     //     ScaffoldMessenger.of(
//     //       context,
//     //     ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     //   }
//     //   logger.e(e);
//     // }
//   }
// }

// Widget _buildTextField(
//   TextEditingController controller,
//   String labelText, {
//   bool obscureText = false,
//   TextInputType keyboardType = TextInputType.text,
// }) {
//   return TextFormField(
//     controller: controller,
//     obscureText: obscureText,
//     keyboardType: keyboardType,
//     style: const TextStyle(color: Colors.white),
//     // cursorColor: Colors.lightGreenAccent,
//     decoration: InputDecoration(
//       labelText: labelText,

//       contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//     ),
//     validator: (value) {
//       if (value == null || value.isEmpty) {
//         return 'This field is required';
//       }
//       return null;
//     },
//   );
// }

import 'package:flutter/material.dart';
import 'package:gymapp/Theme/appcolor.dart';
import 'package:gymapp/Utils/custom_snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
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
