import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

import '../Theme/appcolor.dart';

class MemberFormUtils {
  static Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.greenAccent, // Header background color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.greenAccent, // OK button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = "${picked.day}-${picked.month}-${picked.year}";
    }
  }

  static Future<void> selectTime(
    BuildContext context,
    TextEditingController controller,
  ) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.text = picked.format(context);
    }
  }

  static Future<File?> pickFile(BuildContext context) async {
    try {
      await Permission.photos.request();
      var status = await Permission.photos.status;
      if (status.isGranted) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );

        if (result == null || result.files.isEmpty) return null;

        return File(result.files.single.path!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Permission to access gallery is required.',
              style: TextStyle(color: Colors.white),
            ),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Open Settings',
              onPressed: () => openAppSettings(),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(10),
          ),
        );
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<String?> uploadImage(
    File imageFile,
    BuildContext context,
  ) async {
    try {
      final fileName =
          'membersphoto_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final filePath = 'membersphotos/$fileName';

      final supabase = Supabase.instance.client;
      await supabase.storage.from('membersphotos').upload(filePath, imageFile);
      return supabase.storage.from('membersphotos').getPublicUrl(filePath);
    } catch (e) {
      return null;
    }
  }
}
