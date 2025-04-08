import 'package:flutter/material.dart';
import 'package:gymapp/Utils/member_form_utils.dart';

import '../../../widgets/build_text.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadPhotoButton extends StatelessWidget {
  final void Function(dynamic file) onImageSelected;
  const UploadPhotoButton({super.key, required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
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
                side: const BorderSide(color: Colors.greenAccent),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
            icon: const Icon(Icons.upload, color: Colors.greenAccent),
            label: Text(
              'Upload',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.greenAccent,
              ),
            ),
            onPressed: () async {
              final file = await MemberFormUtils.pickFile(context);
              if (file != null) {
                onImageSelected(file); // ✅ Call the callback
              }
            },
          ),
        ),
      ],
    );
  }
}
