// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:gymapp/Models/member_model.dart';
// import 'package:gymapp/Repositories/member_repository.dart';

// import 'package:gymapp/Utils/custom_snack_bar.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:uuid/uuid.dart';
// import 'package:gymapp/Screens/widgets/build_text.dart';
// import 'package:gymapp/Screens/widgets/build_radio_button.dart';


// class AddMemberScreen extends StatefulWidget {
//   final String? gymId;
//   const AddMemberScreen({super.key, this.gymId});

//   @override
//   State<AddMemberScreen> createState() => _AddMemberScreenState();
// }

// class _AddMemberScreenState extends State<AddMemberScreen> {
//   final _pageController = PageController();
//   int _currentPage = 0;
//   final MemberRepository _memberRepository = MemberRepository(Supabase.instance.client);
//   final Uuid _uuid = Uuid();
//   bool _isSubmitting = false;
//   File? _imageFile;

//   // Member data
//   final Member _member = Member(
//     memberId: '',
//     gymId: '',
//     name: '',
//     mobile: '',
//     gender: 'Male',
//     memberNo: '',
//     height: '',
//     weight: '',
//     chest: '',
//     waist: '',
//     dob: '',
//     address: '',
//     training: 'Trainer',
//     batchTime: '',
//     email: '',
//     employer: '',
//     occupation: '',
//     emergencyName: '',
//     emergencyAddress: '',
//     emergencyRelationship: '',
//     emergencyPhone: '',
//     memberImg: '',
//     memberPlan: '',
//     paymentMethod: '',
//     fromJoiningDate: '',
//     toJoiningDate: '',
//     paidAmount: '',
//     paidDate: '',
//     dueAmount: '',
//     paymentStatus: 'Pending',
//   );

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveMember() async {
//     if (_isSubmitting) return;
//     setState(() => _isSubmitting = true);

//     if (!_validateInputs()) {
//       setState(() => _isSubmitting = false);
//       CustomSnackBar.showSnackBar(
//         "Please fill all required fields",
//         SnackBarType.failure,
//       );
//       return;
//     }

//     try {
//       _member.memberId = _uuid.v4();
//       _member.gymId = widget.gymId ?? '';

//       await _memberRepository.addMember(_member, _imageFile);

//       CustomSnackBar.showSnackBar(
//         'Member added successfully!',
//         SnackBarType.success,
//       );

//       Navigator.pop(context);
//     } catch (e) {
//       CustomSnackBar.showSnackBar(
//         "Error saving member info: ${e.toString()}",
//         SnackBarType.failure,
//       );
//     } finally {
//       setState(() => _isSubmitting = false);
//     }
//   }

//   bool _validateInputs() {
//     if (_member.name.isEmpty) {
//       CustomSnackBar.showSnackBar(
//         "Please enter the member's name",
//         SnackBarType.failure,
//       );
//       return false;
//     }
//     if (_member.mobile.isEmpty || _member.mobile.length != 10) {
//       CustomSnackBar.showSnackBar(
//         "Enter a valid 10-digit mobile number",
//         SnackBarType.failure,
//       );
//       return false;
//     }
//     if (_member.email.isNotEmpty && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_member.email)) {
//       CustomSnackBar.showSnackBar(
//         "Enter a valid email address ✉️",
//         SnackBarType.failure,
//       );
//       return false;
//     }
//     return true;
//   }

//   void _nextPage() {
//     if (!_validateCurrentPage()) return;

//     if (_currentPage < 3) {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.ease,
//       );
//       setState(() => _currentPage++);
//     }
//   }

//   bool _validateCurrentPage() {
//     switch (_currentPage) {
//       case 0: // Basic Info Page
//         if (_member.name.isEmpty) {
//           CustomSnackBar.showSnackBar(
//             "Please enter the member's name",
//             SnackBarType.failure,
//           );
//           return false;
//         }
//         if (_member.mobile.isEmpty || _member.mobile.length != 10) {
//           CustomSnackBar.showSnackBar(
//             "Enter a valid 10-digit mobile number",
//             SnackBarType.failure,
//           );
//           return false;
//         }
//         if (_member.memberNo.isEmpty) {
//           CustomSnackBar.showSnackBar(
//             "Please enter member number",
//             SnackBarType.failure,
//           );
//           return false;
//         }
//         return true;

//       case 1: // Measurements and Address Page
//         if (_member.address.isEmpty) {
//           CustomSnackBar.showSnackBar(
//             "Please enter address",
//             SnackBarType.failure,
//           );
//           return false;
//         }
//         return true;

//       case 2: // Employment and Payment Info Page
//         if (_member.email.isNotEmpty && 
//             !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_member.email)) {
//           CustomSnackBar.showSnackBar(
//             "Enter a valid email address ✉️",
//             SnackBarType.failure,
//           );
//           return false;
//         }
//         if (_member.fromJoiningDate.isEmpty || _member.toJoiningDate.isEmpty) {
//           CustomSnackBar.showSnackBar(
//             "Please select joining dates",
//             SnackBarType.failure,
//           );
//           return false;
//         }
//         return true;

//       case 3: // Emergency Contact Page
//         if (_member.emergencyName.isEmpty || _member.emergencyPhone.isEmpty) {
//           CustomSnackBar.showSnackBar(
//             "Please fill emergency contact details",
//             SnackBarType.failure,
//           );
//           return false;
//         }
//         return true;

//       default:
//         return true;
//     }
//   }

//   void _previousPage() {
//     if (_currentPage > 0) {
//       _pageController.previousPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.ease,
//       );
//       setState(() => _currentPage--);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.greenAccent,
//         title: const Text("Add Member"),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Page indicator
//           _buildPageIndicator(),
          
//           // Form pages
//           Expanded(
//             child: PageView(
//               controller: _pageController,
//               physics: const NeverScrollableScrollPhysics(),
//               children: [
//                 BasicInfoPage(
//                   member: _member,
//                   imageFile: _imageFile,
//                   onImagePicked: (file) => setState(() => _imageFile = file),
//                 ),
//                 MeasurementsPage(
//                   member: _member,
//                   onGenderChanged: (gender) => setState(() => _member.gender = gender),
//                   onTrainingChanged: (training) => setState(() => _member.training = training),
//                 ),
//                 EmploymentPage(member: _member),
//                 EmergencyPage(member: _member),
//               ],
//             ),
//           ),
          
//           // Navigation buttons
//           _buildNavigationButtons(context),
//         ],
//       ),
//     );
//   }

//   Widget _buildPageIndicator() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(4, (index) {
//           return Container(
//             width: 10,
//             height: 10,
//             margin: const EdgeInsets.symmetric(horizontal: 5),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: _currentPage == index ? Colors.greenAccent : Colors.grey,
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   Widget _buildNavigationButtons(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           if (_currentPage > 0)
//             ElevatedButton(
//               style: _navigationButtonStyle(),
//               onPressed: _previousPage,
//               child: const Text('Previous'),
//             )
//           else
//             const SizedBox(width: 100),

//           if (_currentPage < 3)
//             ElevatedButton(
//               style: _navigationButtonStyle(),
//               onPressed: _nextPage,
//               child: const Text('Next'),
//             )
//           else
//             ElevatedButton(
//               style: _navigationButtonStyle(),
//               onPressed: _isSubmitting ? null : _saveMember,
//               child: _isSubmitting
//                   ? const CircularProgressIndicator(color: Colors.greenAccent)
//                   : const Text('Save'),
//             ),
//         ],
//       ),
//     );
//   }

//   ButtonStyle _navigationButtonStyle() {
//     return ElevatedButton.styleFrom(
//       backgroundColor: Colors.black,
//       foregroundColor: Colors.greenAccent,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(30),
//         side: const BorderSide(color: Colors.greenAccent),
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
//     );
//   }
// }




// ////----------


// class BasicInfoPage extends StatelessWidget {
//   final Member member;
//   final File? imageFile;
//   final Function(File) onImagePicked;

//   const BasicInfoPage({
//     super.key,
//     required this.member,
//     required this.imageFile,
//     required this.onImagePicked,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: GestureDetector(
//               onTap: () => _pickFile(context),
//               child: imageFile == null
//                   ? Image.asset("assets/member.avif", width: 60, height: 60)
//                   : Image.file(imageFile!, height: 60, width: 60, fit: BoxFit.cover),
//             ),
//           ),
//           const SizedBox(height: 10),

//           BuildText("Name -:"),
//           BuildUnderlineText(
//             controller: TextEditingController(text: member.name),
//             onChanged: (value) => member.name = value,
//           ),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               BuildText("Upload Photo -:"),
//               Padding(
//                 padding: const EdgeInsets.only(top: 5.0),
//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     foregroundColor: Colors.greenAccent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       side: const BorderSide(color: Colors.greenAccent),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 12, horizontal: 20),
//                   ),
//                   icon: const Icon(Icons.upload, color: Colors.greenAccent),
//                   label: const Text('Upload'),
//                   onPressed: () => _pickFile(context),
//                 ),
//               ),
//             ],
//           ),

//           BuildText("Mobile No. -:"),
//           BuildUnderlineText(
//             controller: TextEditingController(text: member.mobile),
//             inputType: TextInputType.number,
//             maxLength: 10,
//             onChanged: (value) => member.mobile = value,
//           ),

//           BuildText("Gender -:"),
//           Row(
//             children: [
//               BuildRadioButton(
//                 value: "Male",
//                 icon: Icons.male,
//                 groupValue: member.gender,
//                 onChanged: (newValue) => member.gender = newValue,
//               ),
//               BuildRadioButton(
//                 value: "Female",
//                 icon: Icons.female,
//                 groupValue: member.gender,
//                 onChanged: (newValue) => member.gender = newValue,
//               ),
//             ],
//           ),

//           BuildText("Member No. -:"),
//           BuildUnderlineText(
//             controller: TextEditingController(text: member.memberNo),
//             inputType: TextInputType.number,
//             onChanged: (value) => member.memberNo = value,
//           ),

//           BuildText("Date of Birth -:"),
//           BuildUnderlineText(
//             controller: TextEditingController(text: member.dob),
//             onTap: () => _selectDate(context, (date) => member.dob = date),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _pickFile(BuildContext context) async {
//     // Implement file picking logic
//   }

//   Future<void> _selectDate(BuildContext context, Function(String) onDateSelected) async {
//     // Implement date picking logic
//   }
// }

// ////------
// class BuildUnderlineText extends StatelessWidget {
//   final TextEditingController controller;
//   final String? hintText;
//   final TextInputType? inputType;
//   final int? maxLength;
//   final Function(String)? onChanged;
//   final VoidCallback? onTap;

//   const BuildUnderlineText({
//     super.key,
//     required this.controller,
//     this.hintText,
//     this.inputType,
//     this.maxLength,
//     this.onChanged,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       keyboardType: inputType,
//       maxLength: maxLength,
//       onChanged: onChanged,
//       onTap: onTap,
//       decoration: InputDecoration(
//         hintText: hintText,
//         border: const UnderlineInputBorder(),
//         contentPadding: const EdgeInsets.symmetric(vertical: 8),
//       ),
//     );
//   }
// }


// class MeasurementsPage extends StatelessWidget {
//   final Member member;
//   final Function(String) onGenderChanged;
//   final Function(String) onTrainingChanged;

//   const MeasurementsPage({
//     super.key,
//     required this.member,
//     required this.onGenderChanged,
//     required this.onTrainingChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           BuildText("Measurements -:"),
//           Row(
//             children: [
//               MeasurementField(
//                 value: member.height,
//                 label: "Height",
//                 onChanged: (value) => member.height = value,
//               ),
//               MeasurementField(
//                 value: member.weight,
//                 label: "Weight",
//                 onChanged: (value) => member.weight = value,
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               MeasurementField(
//                 value: member.chest,
//                 label: "Chest",
//                 onChanged: (value) => member.chest = value,
//               ),
//               MeasurementField(
//                 value: member.waist,
//                 label: "Waist",
//                 onChanged: (value) => member.waist = value,
//               ),
//             ],
//           ),

//           BuildText("Address -:"),
//           BuildUnderlineText(
//             controller: TextEditingController(text: member.address),
//             onChanged: (value) => member.address = value,
//           ),

//           BuildText("Training -:"),
//           Row(
//             children: [
//               BuildRadioButton(
//                 value: "Trainer",
//                 icon: Icons.directions_run,
//                 groupValue: member.training,
//                 onChanged: onTrainingChanged,
//               ),
//               BuildRadioButton(
//                 value: "Personal",
//                 icon: Icons.person_rounded,
//                 groupValue: member.training,
//                 onChanged: onTrainingChanged,
//               ),
//             ],
//           ),

//           BuildText("Batch Time -:"),
//           BuildUnderlineText(
//             controller: TextEditingController(text: member.batchTime),
//             onTap: () => _selectTime(context, (time) => member.batchTime = time),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _selectTime(BuildContext context, Function(String) onTimeSelected) async {
//     TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) {
//       onTimeSelected(picked.format(context));
//     }
//   }
// }


// class EmploymentPage extends StatelessWidget {
//   final Member member;

//   const EmploymentPage({super.key, required this.member});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           BuildText("Email -:"),
//           BuildUnderlineText(
//             controller: TextEditingController(text: member.email),
//             onChanged: (value) => member.email = value,
//           ),

//           BuildText("Employer -:"),
//           BuildUnderlineText(
//             controller: TextEditingController(text: member.employer),
//             onChanged: (value) => member.employer = value,
//           ),

//           BuildText("Occupation -:"),
//           BuildUnderlineText(
//             controller: TextEditingController(text: member.occupation),
//             onChanged: (value) => member.occupation = value,
//           ),

//           BuildText("Joining Date -:"),
//           Row(
//             children: [
//               Expanded(
//                 child: BuildUnderlineText(
//                   controller: TextEditingController(text: member.fromJoiningDate),
//                   onTap: () => _selectDate(context, (date) => member.fromJoiningDate = date),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               const Text("To"),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: BuildUnderlineText(
//                   controller: TextEditingController(text: member.toJoiningDate),
//                   onTap: () => _selectDate(context, (date) => member.toJoiningDate = date),
//                 ),
//               ),
//             ],
//           ),

//           BuildText("Plan -:"),
//           BuildUnderlineText(
//             controller: TextEditingController(text: member.memberPlan),
//             onChanged: (value) => member.memberPlan = value,
//           ),

//           BuildText("Payment Method -:"),
//           BuildUnderlineText(
//             controller: TextEditingController(text: member.paymentMethod),
//             onChanged: (value) => member.paymentMethod = value,
//           ),

//           BuildText("Paid Amount -:"),
//           BuildUnderlineText(
//             controller: TextEditingController(text: member.paidAmount),
//             inputType: TextInputType.number,
//             onChanged: (value) => member.paidAmount = value,
//           ),
          
//           BuildText("Paid Date -:"),
//           BuildUnderlineText(
//             controller: TextEditingController(text: member.paidDate),
//             onTap: () => _selectDate(context, (date) => member.paidDate = date),
//           ),
          
//           BuildText("Due Amount -:"),
//           BuildUnderlineText(
//             controller: TextEditingController(text: member.dueAmount),
//             inputType: TextInputType.number,
//             onChanged: (value) => member.dueAmount = value,
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _selectDate(BuildContext context, Function(String) onDateSelected) async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1950),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       onDateSelected("${picked.day}-${picked.month}-${picked.year}");
//     }
//   }
// }

// class EmergencyPage extends StatelessWidget {
//   final Member member;

//   const EmergencyPage({super.key, required this.member});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           BuildText("In case of emergency, Please Notify :", bold: true),
//           BuildText("1. Name -:"),
//           BuildUnderlineText(
//             controller: TextEditingController(text: member.emergencyName),
//             onChanged: (value) => member.emergencyName = value,
//           ),
          
//           BuildText("2. Address -:"),
//           BuildUnderlineText(
//             controller: TextEditingController(text: member.emergencyAddress),
//             onChanged: (value) => member.emergencyAddress = value,
//           ),
          
//           BuildText("3. Relationship -:"),
//           BuildUnderlineText(
//             controller: TextEditingController(text: member.emergencyRelationship),
//             onChanged: (value) => member.emergencyRelationship = value,
//           ),
          
//           BuildText("4. Phone No. -:"),
//           BuildUnderlineText(
//             controller: TextEditingController(text: member.emergencyPhone),
//             inputType: TextInputType.number,
//             maxLength: 10,
//             onChanged: (value) => member.emergencyPhone = value,
//           ),
//         ],
//       ),
//     );
//   }
// }


// class MeasurementField extends StatelessWidget {
//   final String value;
//   final String label;
//   final Function(String) onChanged;

//   const MeasurementField({
//     super.key,
//     required this.value,
//     required this.label,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 4.0),
//         child: TextField(
//           controller: TextEditingController(text: value),
//           onChanged: onChanged,
//           decoration: InputDecoration(
//             labelText: label,
//             border: const OutlineInputBorder(),
//           ),
//           keyboardType: TextInputType.number,
//         ),
//       ),
//     );
//   }
// }


//will do hyy use the model and repo they are good