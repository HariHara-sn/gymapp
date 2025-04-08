import 'package:flutter/widgets.dart';
import 'package:gymapp/Theme/appcolor.dart';
import 'package:google_fonts/google_fonts.dart';
class NoticeCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;

  const NoticeCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.greenAccent,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: GoogleFonts.poppins(fontSize: 13, color: AppColors.white),
          ),
          const SizedBox(height: 5),
          Text(
            date,
            style: GoogleFonts.poppins(fontSize: 12, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
