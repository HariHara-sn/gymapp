import 'package:flutter/material.dart';
import '../../../widgets/build_text.dart';
import '../../../widgets/build_underline_text.dart';

class EmergencyContactPage extends StatelessWidget {
  final TextEditingController emergencyNameController;
  final TextEditingController emergencyAddressController;
  final TextEditingController emergencyRelationshipController;
  final TextEditingController emergencyPhoneController;

  const EmergencyContactPage({
    super.key,
    required this.emergencyNameController,
    required this.emergencyAddressController,
    required this.emergencyRelationshipController,
    required this.emergencyPhoneController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          BuildUnderlineText(controller: emergencyAddressController),
          BuildText("3. Relationship -:"),
          BuildUnderlineText(controller: emergencyRelationshipController),
          BuildText("4. Phone No. -:"),
          BuildUnderlineText(
            controller: emergencyPhoneController,
            inputType: TextInputType.number,
            maxLength: 10,
          ),
        ],
      ),
    );
  }
}