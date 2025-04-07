import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../Theme/appcolor.dart';

class QrPreviewWidget extends StatelessWidget {
  final String qrReference;
  final String upiId;
  final String amount;  
  const QrPreviewWidget({super.key, required this.qrReference, required this.upiId, required this.amount});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return  Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                QrImageView(
                  data: qrReference.toString(),
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  "Scan to Pay or Access Gym",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 5),
                AutoSizeText(
                  "UPI ID: $upiId",
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: AppColors.greenAccent,
                  ),
                  maxLines: 1,
                  minFontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Amount: ₹$amount",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.greenAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      
    );
  }
}
