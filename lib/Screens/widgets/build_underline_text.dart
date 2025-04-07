import 'package:flutter/material.dart';

class BuildUnderlineText extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType inputType;
  final int? maxLength;
  final VoidCallback? onTap;
  const BuildUnderlineText({this.inputType=TextInputType.text,super.key, required this.controller, this.maxLength, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      maxLength: maxLength,
      readOnly: onTap != null,
      onTap: onTap,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        counterText: "",
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 2),
      ),
    );
    
  }
}
