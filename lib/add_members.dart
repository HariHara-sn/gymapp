import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymapp/Theme/appcolor.dart';
import 'package:gymapp/Utils/custom_snack_bar.dart';
import 'package:gymapp/main.dart';
import 'package:gymapp/Screens/widgets/build_radio_button.dart';
import 'package:gymapp/Screens/widgets/build_text.dart';
import 'package:gymapp/Screens/widgets/build_underline_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as path;

import 'Screens/widgets/build_measurementfield.dart';

class AddMemberScreen extends StatefulWidget {
  final String? gymId;
  const AddMemberScreen({super.key, this.gymId});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  String genderType = "Male";
  String trainingType = "Trainer";
  final SupabaseClient supabase = Supabase.instance.client;

  bool isSubmitting = false;
  File? _imageFile;

  // Controllers for all fields
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController batchTimeController = TextEditingController();
  final TextEditingController memberNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController employerController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController memberPlanController = TextEditingController();
  final TextEditingController paymentMethodController = TextEditingController();
  final TextEditingController fromJoiningDateController =
      TextEditingController();
  final TextEditingController toJoiningDateController = TextEditingController();
  final TextEditingController paidAmountController = TextEditingController();
  final TextEditingController paidDateController = TextEditingController();
  final TextEditingController dueAmountController = TextEditingController();

  ///<<---Measurements ---->>
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController chestController = TextEditingController();
  final TextEditingController waistController = TextEditingController();

  ///<<---Emergency Contact--->>
  final TextEditingController emergencyNameController = TextEditingController();
  final TextEditingController emergencyAddressController =
      TextEditingController();
  final TextEditingController emergencyRelationshipController =
      TextEditingController();
  final TextEditingController emergencyPhoneController =
      TextEditingController();

  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> pickFile(BuildContext context) async {
    if (!context.mounted) return;
    try {
      await Permission.photos.request();
      var status = await Permission.photos.status;
      if (status.isGranted) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );

        if (result == null || result.files.isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('No file selected!')));
          return;
        }

        setState(() {
          _imageFile = File(result.files.single.path!);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: ExcludeSemantics(
              child: Text(
                'Permission to access gallery is required.',
                style: TextStyle(color: AppColors.white),
              ),
            ),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Open Settings',
              onPressed: () => openAppSettings(),
            ),
            backgroundColor: AppColors.red,
            duration: const Duration(seconds: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(10),
          ),
        );
      }
    } catch (e) {
      CustomSnackBar.showSnackBar(
        'An error occurred while picking the file.',

        SnackBarType.failure,
      );
    }
  }

  Future<String?> uploadImage(File imageFile, context) async {
    try {
      final fileName =
          'membersphoto_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final filePath = 'membersphotos/$fileName';

      await supabase.storage.from('membersphotos').upload(filePath, imageFile);
      return supabase.storage.from('membersphotos').getPublicUrl(filePath);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Image upload failed')));

      return null;
    }
  }

  Future<void> saveMemberInfo() async {
    if (isSubmitting) return;
    setState(() => isSubmitting = true);

    if (!_validateInputs(context)) {
      setState(() => isSubmitting = false);
      CustomSnackBar.showSnackBar(
        "Please fill all the fields before submit",
        SnackBarType.failure,
      );
      return;
    }

    String? imageUrl;

    if (_imageFile != null) {
      imageUrl = await uploadImage(_imageFile!, context);
    }

    
    try {
      await supabase.from('memberinfo').insert({
  'gymId': widget.gymId ?? '',
  'name': memberNameController.text.trim().isNotEmpty ? memberNameController.text.trim() : '',
  'mobile': mobileController.text.trim().isNotEmpty ? mobileController.text.trim() : '',
  'gender': genderType ,
  'height': heightController.text.trim().isNotEmpty ? heightController.text.trim() : '',
  'weight': weightController.text.trim().isNotEmpty ? weightController.text.trim() : '',
  'chest': chestController.text.trim().isNotEmpty ? chestController.text.trim() : '',
  'waist': waistController.text.trim().isNotEmpty ? waistController.text.trim() : '',
  'dob': dobController.text.trim().isNotEmpty ? dobController.text.trim() : '',
  'address': addressController.text.trim().isNotEmpty ? addressController.text.trim() : '',
  'training': trainingType ,
  'batch_time': batchTimeController.text.trim().isNotEmpty ? batchTimeController.text.trim() : '',
  'email': emailController.text.trim().isNotEmpty ? emailController.text.trim() : '',
  'employer': employerController.text.trim().isNotEmpty ? employerController.text.trim() : '',
  'occupation': occupationController.text.trim().isNotEmpty ? occupationController.text.trim() : '',
  'emergency_name': emergencyNameController.text.trim().isNotEmpty ? emergencyNameController.text.trim() : '',
  'emergency_address': emergencyAddressController.text.trim().isNotEmpty ? emergencyAddressController.text.trim() : '',
  'emergency_relationship': emergencyRelationshipController.text.trim().isNotEmpty ? emergencyRelationshipController.text.trim() : '',
  'emergency_phone': emergencyPhoneController.text.trim().isNotEmpty ? emergencyPhoneController.text.trim() : '',
  'member_img': imageUrl ?? '',
  'member_plan': memberPlanController.text.trim().isNotEmpty ? memberPlanController.text.trim() : '',
  'payment_method': paymentMethodController.text.trim().isNotEmpty ? paymentMethodController.text.trim() : '',
  'from_joining_date': fromJoiningDateController.text.trim().isNotEmpty ? fromJoiningDateController.text.trim() : '',
  'to_joining_date': toJoiningDateController.text.trim().isNotEmpty ? toJoiningDateController.text.trim() : '',
  'paid_amount': paidAmountController.text.trim().isNotEmpty ? paidAmountController.text.trim() : '',
  'paid_date': paidDateController.text.trim().isNotEmpty ? paidDateController.text.trim() : '',
  'due_amount': dueAmountController.text.trim().isNotEmpty ? dueAmountController.text.trim() : '',
  'payment_status':'Pending',
});


      CustomSnackBar.showSnackBar(
        'Member added successfully!',
        SnackBarType.success,
      );

      clearForm();
    } catch (e) {
      logger.e(e);
      CustomSnackBar.showSnackBar(
        "Error saving member info",
        SnackBarType.failure,
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  bool _validateInputs(context) {
    if (memberNameController.text.isEmpty) {
      CustomSnackBar.showSnackBar(
        "Please enter the member's name",
        SnackBarType.failure,
      );

      return false;
    }
    if (mobileController.text.isEmpty || mobileController.text.length != 10) {
      CustomSnackBar.showSnackBar(
        "Enter a valid 10-digit mobile number",
        SnackBarType.failure,
      );
      return false;
    }
    if (emailController.text.isEmpty ||
        !emailRegex.hasMatch(emailController.text)) {
      CustomSnackBar.showSnackBar(
        "Enter a valid email address ✉️",
        SnackBarType.failure,
      );
      return false;
    }
    return true;
  }

  void clearForm() {
    setState(() {
      addressController.clear();
      memberNameController.clear();
      mobileController.clear();
      heightController.clear();
      weightController.clear();
      chestController.clear();
      waistController.clear();
      dobController.clear();
      batchTimeController.clear();
      emailController.clear();
      employerController.clear();
      occupationController.clear();
      emergencyNameController.clear();
      emergencyAddressController.clear();
      emergencyRelationshipController.clear();
      emergencyPhoneController.clear();
      memberPlanController.clear();
      paymentMethodController.clear();
      fromJoiningDateController.clear();
      toJoiningDateController.clear();
      paidAmountController.clear();
      paidDateController.clear();
      dueAmountController.clear();
      _imageFile = null;
      genderType = "Male";
      trainingType = "Trainer";
    });
  }

  void _nextPage() {
    // Validate current page before proceeding
    if (!_validateCurrentPage()) {
      return;
    }

    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  bool _validateCurrentPage() {
    switch (_currentPage) {
      case 0: // Basic Info Page
        if (memberNameController.text.isEmpty) {
          CustomSnackBar.showSnackBar(
            "Please enter the member's name",
            SnackBarType.failure,
          );
          return false;
        }
        if (mobileController.text.isEmpty ||
            mobileController.text.length != 10) {
          CustomSnackBar.showSnackBar(
            "Enter a valid 10-digit mobile number",
            SnackBarType.failure,
          );
          return false;
        }
        return true;

      case 1: // Measurements and Address Page
        if (addressController.text.isEmpty) {
          CustomSnackBar.showSnackBar(
            "Please enter address",
            SnackBarType.failure,
          );
          return false;
        }
        return true;

      case 2: // Employment and Payment Info Page
        if (emailController.text.isEmpty ||
            !emailRegex.hasMatch(emailController.text)) {
          CustomSnackBar.showSnackBar(
            "Enter a valid email address ✉️",
            SnackBarType.failure,
          );
          return false;
        }
        if (fromJoiningDateController.text.isEmpty ||
            toJoiningDateController.text.isEmpty) {
          CustomSnackBar.showSnackBar(
            "Please select joining dates",
            SnackBarType.failure,
          );
          return false;
        }
        return true;

      case 3: // Emergency Contact Page
        if (emergencyNameController.text.isEmpty ||
            emergencyPhoneController.text.isEmpty) {
          CustomSnackBar.showSnackBar(
            "Please fill emergency contact details",
            SnackBarType.failure,
          );
          return false;
        }
        return true;

      default:
        return true;
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text(
          "Add Member",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Page indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentPage == index
                            ? Colors.greenAccent
                            : Colors.grey,
                  ),
                );
              }),
            ),
          ),

          // Form pages
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Page 1: Basic Info
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () => pickFile(context),
                          child:
                              _imageFile == null
                                  ? Image.asset(
                                    "assets/member.avif",
                                    width: 60,
                                    height: 60,
                                  )
                                  : Image.file(
                                    _imageFile!,
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      BuildText("Name -:"),
                      BuildUnderlineText(controller: memberNameController),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BuildText("Upload Photo -:"),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.greenAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: const BorderSide(
                                    color: Colors.greenAccent,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 20,
                                ),
                              ),
                              icon: const Icon(
                                Icons.upload,
                                color: Colors.greenAccent,
                              ),
                              label: Text(
                                'Upload',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.greenAccent,
                                ),
                              ),
                              onPressed: () => pickFile(context),
                            ),
                          ),
                        ],
                      ),

                      BuildText("Mobile No. -:"),
                      BuildUnderlineText(
                        controller: mobileController,
                        inputType: TextInputType.number,
                        maxLength: 10,
                      ),

                      BuildText("Gender -:"),
                      Row(
                        children: [
                          BuildRadioButton(
                            value: "Male",
                            icon: Icons.male,
                            groupValue: genderType,
                            onChanged: (newValue) {
                              setState(() {
                                genderType = newValue;
                              });
                            },
                          ),
                          BuildRadioButton(
                            value: "Female",
                            icon: Icons.female,
                            groupValue: genderType,
                            onChanged: (newValue) {
                              setState(() {
                                genderType = newValue;
                              });
                            },
                          ),
                        ],
                      ),

                      BuildText("Date of Birth -:"),
                      BuildUnderlineText(
                        controller: dobController,
                        onTap: () => _selectDate(context, dobController),
                      ),
                    ],
                  ),
                ),

                // Page 2: Measurements and Address
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildText("Measurements -:"),
                      Row(
                        children: [
                          MeasurementField(
                            controller: heightController,
                            label: "Height",
                          ),
                          MeasurementField(
                            controller: weightController,
                            label: "Weight",
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          MeasurementField(
                            controller: chestController,
                            label: "Chest",
                          ),
                          MeasurementField(
                            controller: waistController,
                            label: "Waist",
                          ),
                        ],
                      ),

                      BuildText("Address -:"),
                      BuildUnderlineText(controller: addressController),

                      BuildText("Training -:"),
                      Row(
                        children: [
                          BuildRadioButton(
                            value: "Trainer",
                            icon: Icons.directions_run,
                            groupValue: trainingType,
                            onChanged: (newValue) {
                              setState(() {
                                trainingType = newValue;
                              });
                            },
                          ),
                          BuildRadioButton(
                            value: "Personal",
                            icon: Icons.person_rounded,
                            groupValue: trainingType,
                            onChanged: (newValue) {
                              setState(() {
                                trainingType = newValue;
                              });
                            },
                          ),
                        ],
                      ),

                      BuildText("Batch Time -:"),
                      BuildUnderlineText(
                        controller: batchTimeController,
                        onTap: () => _selectTime(context),
                      ),
                    ],
                  ),
                ),

                // Page 3: Employment and Payment Info
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildText("Email -:"),
                      BuildUnderlineText(controller: emailController),

                      BuildText("Employer -:"),
                      BuildUnderlineText(controller: employerController),

                      BuildText("Occupation -:"),
                      BuildUnderlineText(controller: occupationController),

                      BuildText("Joining Date -:"),
                      Row(
                        children: [
                          Expanded(
                            child: BuildUnderlineText(
                              controller: fromJoiningDateController,
                              onTap:
                                  () => _selectDate(
                                    context,
                                    fromJoiningDateController,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "To",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.greenAccent,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: BuildUnderlineText(
                              controller: toJoiningDateController,
                              onTap:
                                  () => _selectDate(
                                    context,
                                    toJoiningDateController,
                                  ),
                            ),
                          ),
                        ],
                      ),

                      BuildText("Plan -:"),
                      BuildUnderlineText(controller: memberPlanController),

                      BuildText("Payment Method -:"),
                      BuildUnderlineText(controller: paymentMethodController),

                      BuildText("Paid Amount -:"),
                      BuildUnderlineText(
                        controller: paidAmountController,
                        inputType: TextInputType.number,
                      ),
                      BuildText("Paid Date -:"),
                      BuildUnderlineText(
                        controller: paidDateController,
                        onTap: () => _selectDate(context, paidDateController),
                      ),
                      BuildText("Due Amount -:"),
                      BuildUnderlineText(
                        controller: dueAmountController,
                        inputType: TextInputType.number,
                      ),
                    ],
                  ),
                ),

                // Page 4: Emergency Contact
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildText(
                        "In case of emergency, Please Notify :",
                        bold: true,
                      ),
                      BuildText("1. Name -:"),
                      BuildUnderlineText(controller: emergencyNameController),
                      BuildText("2. Address -:"),
                      BuildUnderlineText(
                        controller: emergencyAddressController,
                      ),
                      BuildText("3. Relationship -:"),
                      BuildUnderlineText(
                        controller: emergencyRelationshipController,
                      ),
                      BuildText("4. Phone No. -:"),
                      BuildUnderlineText(
                        controller: emergencyPhoneController,
                        inputType: TextInputType.number,
                        maxLength: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.05),

                    child: ElevatedButton(
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
                      onPressed: _previousPage,
                      child: Text(
                        'Previous',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 100),

                if (_currentPage < 3)
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.05),

                    child: ElevatedButton(
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
                      onPressed: _nextPage,
                      child: Text(
                        'Next',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.05),
                    child: ElevatedButton(
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
                      onPressed: () => isSubmitting ? null : saveMemberInfo(),
                      child:
                          isSubmitting
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
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        batchTimeController.text = picked.format(context);
      });
    }
  }
}
