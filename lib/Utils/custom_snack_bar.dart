import 'package:flutter/material.dart';
import 'package:gymapp/Theme/appcolor.dart';

enum SnackBarType { success, failure }

class CustomSnackBar {
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(String message, SnackBarType type) {
    Color backgroundColor;
    switch (type) {
      case SnackBarType.success:
        backgroundColor = Colors.green;
        break;
      case SnackBarType.failure:
        backgroundColor = Colors.red;
        break;
    }

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: ExcludeSemantics(
          child: Text(message, style: TextStyle(color: AppColors.white)),
          
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }
}
