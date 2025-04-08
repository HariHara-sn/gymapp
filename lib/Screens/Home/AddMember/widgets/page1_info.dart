import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymapp/Screens/widgets/build_radio_button.dart';
import '../../../../Utils/member_form_utils.dart';
import '../../../widgets/build_text.dart';
import '../../../widgets/build_underline_text.dart';

class Page1Info extends StatelessWidget {
  final TextEditingController memberNameController;
  final TextEditingController mobileController;
  final TextEditingController dobController;
  final String genderType;
  final Function(String) onGenderChanged;
  final File? imageFile;
  final Function(File) onImageSelected;

  const Page1Info({
    super.key,
    required this.memberNameController,
    required this.mobileController,
    required this.dobController,
    required this.genderType,
    required this.onGenderChanged,
    required this.imageFile,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GestureDetector(
              onTap: () async {
                final file = await MemberFormUtils.pickFile(context);
                if (file != null) {
                  onImageSelected(file);
                }
              },
              child: imageFile == null
                  ? Image.asset(
                      "assets/member.avif",
                      width: 60,
                      height: 60,
                    )
                  : Image.file(
                      imageFile!,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(height: 10),

          BuildText("Name -:"),
          BuildUnderlineText(controller: memberNameController),

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
                onChanged: onGenderChanged,
              ),
              BuildRadioButton(
                value: "Female",
                icon: Icons.female,
                groupValue: genderType,
                onChanged: onGenderChanged,
              ),
            ],
          ),

          BuildText("Date of Birth -:"),
          BuildUnderlineText(
            controller: dobController,
            onTap: () => MemberFormUtils.selectDate(context, dobController),
          ),
        ],
      ),
    );
  }
}