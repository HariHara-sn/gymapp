import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymapp/Screens/Home/AddMember/widgets/form_navigation_buttons.dart';
import 'package:gymapp/Screens/Home/AddMember/widgets/page1_info.dart';
import 'package:gymapp/Utils/custom_snack_bar.dart';
import 'package:gymapp/main.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gymapp/utils/member_form_utils.dart';
import 'model/member_model.dart';
import 'widgets/emergency_contact_page.dart';
import 'widgets/employment_payment_page.dart';
import 'widgets/measurements_address_page.dart';
import 'widgets/page_indicator.dart';

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
    dobController.dispose();
    addressController.dispose();
    batchTimeController.dispose();
    memberNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    employerController.dispose();
    occupationController.dispose();
    memberPlanController.dispose();
    paymentMethodController.dispose();
    fromJoiningDateController.dispose();
    toJoiningDateController.dispose();
    paidAmountController.dispose();
    paidDateController.dispose();
    dueAmountController.dispose();
    heightController.dispose();
    weightController.dispose();
    chestController.dispose();
    waistController.dispose();
    emergencyNameController.dispose();
    emergencyAddressController.dispose();
    emergencyRelationshipController.dispose();
    emergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> saveMemberInfo(context) async {
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
      imageUrl = await MemberFormUtils.uploadImage(_imageFile!, context);
      if (imageUrl == null) {
        setState(() => isSubmitting = false);
        CustomSnackBar.showSnackBar(
          "Image upload failed",
          SnackBarType.failure,
        );
        return;
      }
    }

    try {
      final member = Member(
        gymId: widget.gymId,
        name: memberNameController.text.trim(),
        mobile: mobileController.text.trim(),
        gender: genderType,
        height: heightController.text.trim(),
        weight: weightController.text.trim(),
        chest: chestController.text.trim(),
        waist: waistController.text.trim(),
        dob: dobController.text.trim(),
        address: addressController.text.trim(),
        training: trainingType,
        batchTime: batchTimeController.text.trim(),
        email: emailController.text.trim(),
        employer: employerController.text.trim(),
        occupation: occupationController.text.trim(),
        emergencyName: emergencyNameController.text.trim(),
        emergencyAddress: emergencyAddressController.text.trim(),
        emergencyRelationship: emergencyRelationshipController.text.trim(),
        emergencyPhone: emergencyPhoneController.text.trim(),
        memberImg: imageUrl,
        memberPlan: memberPlanController.text.trim(),
        paymentMethod: paymentMethodController.text.trim(),
        fromJoiningDate: fromJoiningDateController.text.trim(),
        toJoiningDate: toJoiningDateController.text.trim(),
        paidAmount: paidAmountController.text.trim(),
        paidDate: paidDateController.text.trim(),
        dueAmount: dueAmountController.text.trim(),
      );

      await supabase.from('memberinfo').insert(member.toMap());

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

  bool _validateInputs(BuildContext context) {
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
    if (!_validateCurrentPage()) return;

    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() => _currentPage++);
    }
  }

  bool _validateCurrentPage() {
    switch (_currentPage) {
      case 0:
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
      case 1:
        if (addressController.text.isEmpty) {
          CustomSnackBar.showSnackBar(
            "Please enter address",
            SnackBarType.failure,
          );
          return false;
        }
        return true;
      case 2:
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
      case 3:
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
      setState(() => _currentPage--);
    }
  }

  @override
  Widget build(BuildContext context) {

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
          PageIndicator(currentPage: _currentPage),

          // Form pages
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Page 1: Basic Info
                Page1Info(
                  memberNameController: memberNameController,
                  mobileController: mobileController,
                  dobController: dobController,
                  genderType: genderType,
                  onGenderChanged:
                      (newValue) => setState(() => genderType = newValue),
                  imageFile: _imageFile,
                  onImageSelected: (file) => setState(() => _imageFile = file),
                ),
                // Page 2: Measurements and Address
                MeasurementsAddressPage(
                  heightController: heightController,
                  weightController: weightController,
                  chestController: chestController,
                  waistController: waistController,
                  addressController: addressController,
                  batchTimeController: batchTimeController,
                  trainingType: trainingType,
                  onTrainingChanged:
                      (newValue) => setState(() => trainingType = newValue),
                ),
                // Page 3: Employment and Payment Info
                EmploymentPaymentPage(
                  emailController: emailController,
                  employerController: employerController,
                  occupationController: occupationController,
                  fromJoiningDateController: fromJoiningDateController,
                  toJoiningDateController: toJoiningDateController,
                  memberPlanController: memberPlanController,
                  paymentMethodController: paymentMethodController,
                  paidAmountController: paidAmountController,
                  paidDateController: paidDateController,
                  dueAmountController: dueAmountController,
                ),
                // Page 4: Emergency Contact
                EmergencyContactPage(
                  emergencyNameController: emergencyNameController,
                  emergencyAddressController: emergencyAddressController,
                  emergencyRelationshipController:
                      emergencyRelationshipController,
                  emergencyPhoneController: emergencyPhoneController,
                ),
              ],
            ),
          ),

          // Navigation buttons
          FormNavigationButtons(
            currentPage: _currentPage,
            onPreviousPressed: _previousPage,
            onNextPressed: _nextPage,
            onSavePressed: () => saveMemberInfo(context),
            isSubmitting: isSubmitting,
          ),
        ],
      ),
    );
  }
}
