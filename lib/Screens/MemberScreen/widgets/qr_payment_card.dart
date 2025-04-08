import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymapp/Theme/appcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class QuickPaymentCard extends StatelessWidget {
  final String upiId;
  final String amount;
  final String qrReference;

  const QuickPaymentCard({
    super.key,
    required this.upiId,
    required this.amount,
    required this.qrReference,
  });
  Future<void> _openGPay() async {
    // String upiUrl = "upi://pay?pa=sudhanabirami007-1@okhdfcbank&pn=Hari%20Hara%20Sudhan&am=100&cu=INR"; //limit to 100
    // String upiUrl = "upi://pay?pa=sudhanabirami007-1@okhdfcbank&pn=Hari%20Hara%20Sudhan&cu=INR";
    // String upiUrl =  "upi://pay?${Secrets.upiId}&pn=Hari%20Hara%20Sudhan&cu=INR"; // with name
    // String upiUrl = "upi://pay?$upiId&cu=INR"; // without name

    Uri uri = Uri.parse(qrReference);

    launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _shareQRCode(BuildContext context) async {
    try {
      final qrPainter = QrPainter(
        data: qrReference,
        version: QrVersions.auto,
        color: Colors.black,
        emptyColor: Colors.white,
      );

      // Convert to image
      final picData = await qrPainter.toImageData(250);
      if (picData == null) return;

      final buffer = picData.buffer;
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/gpay_qr_code.png').writeAsBytes(
        buffer.asUint8List(picData.offsetInBytes, picData.lengthInBytes),
      );

      // Share the QR code
      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'Scan this QR code to pay me:\nUPI ID: sudhanabirami007-1@okhdfcbank',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing QR Code: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 15,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Quick Payment',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                QrImageView(
                  data: qrReference, // Updated QR Code data
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  'Scan to Pay',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '₹$amount',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'UPI ID: $upiId',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.payment, size: 24, color: AppColors.white),
            label: Text(
              'Pay via GPay',
              style: TextStyle(fontSize: 18, color: AppColors.greenAccent),
            ),
            onPressed: () => _openGPay(),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.share, size: 24, color: AppColors.white),
            label: Text(
              'Share QR Code',
              style: TextStyle(fontSize: 18, color: AppColors.greenAccent),
            ),
            onPressed: () => _shareQRCode(context),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 33, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
