// ----------------------------
// Member Info Widget (for AutoSizeText)
// ----------------------------
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:gymapp/Theme/appcolor.dart';

class MemberinfoWidget extends StatelessWidget {
  final String placeholder;
  final String value;

  const MemberinfoWidget({
    super.key,
    required this.placeholder,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: AutoSizeText(
              '$placeholder:',
              style: TextStyle(
                fontSize: 14 * textScaleFactor,
                fontWeight: FontWeight.bold,
                color: AppColors.greenAccent,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: AutoSizeText(
              value,
              style: TextStyle(
                fontSize: 14 * textScaleFactor,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
